# frozen_string_literal: true

require 'set'
require_relative 'formats'
module DuperVisor
  class Renderer
    SUPPORTED_CLASSES = [Hash, Array].freeze

    include DuperVisor::Formats::Accessors

    attr_accessor :output, :content_hash, :rendered_content

    def initialize(content_hash, output_stream = nil)
      unless type_supported?(content_hash)
        raise ArgumentError, "Don't know how to render #{content_hash.class.name}, we support only #{SUPPORTED_CLASSES.map(&:name)}"
      end

      self.output = output_stream
      self.content_hash = content_hash
    end

    def render(format)
      self.rendered_content = formats[format].to.call(content_hash)
      if output.respond_to?(:puts)
        output.puts rendered_content
        output.close if output.respond_to?(:close) && output != STDOUT
      end
      rendered_content
    end

    private

    def type_supported?(klass)
      SUPPORTED_CLASSES.any? { |type| klass.is_a?(type) }
    end
  end
end
