# frozen_string_literal: true

module DuperVisor
  class Detector
    attr_accessor :filename

    def initialize(filename)
      self.filename = filename
    end

    def detect
      format_from_extension(filename) if filename.is_a?(String)
    end

    private

    def format_from_extension(filename)
      extension = filename.gsub(/.*\.([\w]+)/, '\1')
      auto_detect_format(extension)
    end

    def auto_detect_format(extension)
      return unless extension =~ /(json|ya?ml|ini)/i

      f = extension.downcase.to_sym
      f = :yaml if f == :yml
      f
    end
  end
end
