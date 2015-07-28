require 'nokogiri'

#  <message>
#    <to>$TO</to>
#    <body>$BODY</body>
#  </message>

module Esendex
  class Message
    attr_accessor :to, :body, :from, :sms_type, :voice_lang, :voice_retries
    
    def initialize(to, body, from=nil, sms_type=nil,voice_lang=nil,voice_retries=nil)
      @to = to
      @body = body
      @from = from
      @sms_type = sms_type
      @lang = voice_lang == nil ? "en-GB" : voice_lang
      @retries = voice_retries == nil ? 0 : voice_retries

    end
    
    def xml_node
      doc = Nokogiri::XML('<message/>')
                  
      to = Nokogiri::XML::Node.new 'to', doc
      to.content = @to
      doc.root.add_child(to)
      
      body = Nokogiri::XML::Node.new 'body', doc
      body.content = @body
      doc.root.add_child(body)

      if @from
        from = Nokogiri::XML::Node.new 'from', doc
        from.content = @from
        doc.root.add_child(from)
      end

      if @sms_type == "Voice"
        sms_type = Nokogiri::XML::Node.new 'type', doc
        sms_type.content = @sms_type
        doc.root.add_child(sms_type)

        sms_lang = Nokogiri::XML::Node.new 'lang', doc
        sms_lang.content = @lang
        doc.root.add_child(sms_lang)

        sms_retries = Nokogiri::XML::Node.new 'retries', doc
        sms_retries.content = @retries
        doc.root.add_child(sms_retries)
      end

      doc.root
    end
  end
end