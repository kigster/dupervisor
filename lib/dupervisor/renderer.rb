require 'set'
require_relative 'formats'
module DuperVisor
  class Renderer
    include DuperVisor::Formats::Accessors

    attr_accessor :output, :content_hash, :rendered_content

    def initialize(content_hash, output_stream = nil)
      raise ArgumentError.new("Don't know how to render #{content_hash.class.name}, I was expecting a Hash.") unless content_hash.is_a?(Hash)
      self.output  = output_stream
      self.content_hash = content_hash
    end

    def render(format)
      self.rendered_content = self.formats[format].to.call(content_hash)
      if output.respond_to?(:puts)
        output.puts rendered_content
        output.close if output.respond_to?(:close) && output != STDOUT
      end
      rendered_content
    end
  end
end
