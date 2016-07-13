require 'yaml'
require 'json'
require 'inifile'

module DuperVisor
  #
  # This class is responsible for taking the input and converting it into a
  # Hash. It can also be initialized with the Hash, in which no conversion is performed.
  #
  # The +result+
  class Content
    attr_accessor :body, :format, :parse_result

    def initialize(body: nil, format: nil)
      self.body   = body
      self.format = format
      self.parse_result = {}
    end

    def self.to_format_from(hash, format)
      format_class = ::DuperVisor::Formats::Base.formats[format]
      raise ArgumentError.new("No format #{format} found") unless format_class
      Content.new(body: format_class.to.call(hash), format: format_class.format)
    end
  end
end

