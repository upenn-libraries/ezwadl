require 'nokogiri'

module EzWadl
  class Parser
  
    class << self
      def parse(wadl)
        doc = File.open(wadl) { |f| Nokogiri::XML f }
        top_resources = uris(doc).map {|xml|
          Resource.new(xml)
        }
      
        top_resources.each {|r|
          add_methods(r)
          add_resources(r)
        }
				
        yield(top_resources) if block_given?
        top_resources
      end
      
      private
  
      def uris(doc)
        doc.xpath("//ns01:resources", 'ns01' => 'http://wadl.dev.java.net/2009/02')
      end
      
      def methods(element)
        element.children.select {|c| c.name == 'method'} .map {|m| m.attributes['name'].value}
      end
      
      def resources(element)
        element.children.select {|c| c.name == 'resource'}
      end
      
      def add_methods(resource)
        methods(resource.xml).each {|method|
          resource.httpmethods << method
        }
      end
      
      def add_resources(resource)
        resources(resource.xml).each {|xml|
          child = Resource.new(xml)
          add_methods(child)
          add_resources(child)
          resource << child
        }
      end
  
    end

  end
end
