require 'uri'
require 'httparty'

module EzWadl
  class Resource
    include HTTParty
  
    attr_reader :xml
    attr_accessor :parent, :path, :httpmethods, :resources
  
    def initialize(xml)
      @xml = xml
      @path = (xml.attributes['base']&.value || xml.attributes['path'].value)
      @httpmethods = []
      @resources = []
    end
  
    def uri
      URI.join(parent&.uri.to_s || '', CGI.escape(path + '/'))
    end
  
    def uri_template(data)
      URI.unescape(uri.to_s).gsub(/{/, '%{') % data
    end
  
    def <<(resource)
      resource.parent = self
      @resources << resource
    end
  
    def method_missing(method, *args)
      result = @resources.select {|r| symbolize(r.path) == method}[0]
      if !result && httpmethods.map(&:downcase).map(&:to_sym).include?(method)
         return Resource.send(method, uri_template(args.last[:query]), *args)
      end
      return result
    end
  
    def respond_to_missing?(method, include_all = false)
      resource_paths = resources.map() {|r| symbolize(r.path)}
      httpmethods.map(&:downcase).map(&:to_sym).include?(method) || resource_paths.include?(method)
    end
  
    def symbolize(str)
      str.tr('^a-zA-Z0-9_', '_')
         .squeeze('_')
         .gsub(/\A_|_\Z/, '')
         .to_sym
    end
  
    def paths
      @resources.map {|r| [r.path, symbolize(r.path)]}
    end

  end
end
