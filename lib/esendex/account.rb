require 'nokogiri'

module Esendex
  class Account
    attr_accessor :reference
    
    def initialize(account_reference = Esendex.account_reference)
      @reference = account_reference
    end
    
    def api_connection
      @api_connection ||= ApiConnection.new
    end

    def messages_remaining
      response = api_connection.get "/v1.0/accounts"
      doc = Nokogiri::XML(response.body)
	  node = doc.at_xpath("//api:account[api:reference='#{@reference}']/api:messagesremaining", 'api' => Esendex::API_NAMESPACE)
	  raise AccountReferenceError.new() if node.nil?
	  node.content.to_i
    end

    def send_message(args={})
      raise ArgumentError.new(":to required") unless args[:to]
      raise ArgumentError.new(":body required") unless args[:body]
      if  args[:sms_type] == "Voice"
        raise ArgumentError.new(":lang required") unless args[:voice_lang]
      end

      send_messages([Message.new(args[:to], args[:body], args[:from],args[:sms_type],args[:voice_lang],args[:voice_retries])])
    end
    
    def send_messages(messages)
      batch_submission = MessageBatchSubmission.new(@reference, messages)
      response = api_connection.post "/v1.0/messagedispatcher", batch_submission.to_s
      doc = Nokogiri::XML(response.body)
      doc.at_xpath('//api:messageheaders', 'api' => Esendex::API_NAMESPACE)['batchid']
    end

  end
end
