require 'nokogiri'

#  <message>
#    <to>$TO</to>
#    <body>$BODY</body>
#  </message>

module Esendex
  class Message
    attr_accessor :to, :body, :from, :sms_type
    
    def initialize(to, body, from=nil, sms_type=nil)
      @to = to
      @body = body
      @from = from
      @sms_type = sms_type
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

      if @sms_type
        sms_type = Nokogiri::XML::Node.new 'type', doc
        sms_type.content = @sms_type
        doc.root.add_child(sms_type)
      end

      p doc.root
      doc.root
    end
  end
end