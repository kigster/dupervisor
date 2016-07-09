module DuperVisor
  class ExtensionDetector
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
      format = if extension =~ /(json|ya?ml|ini)/i
        f = extension.downcase.to_sym
        f == :yml ? :yaml : f
      end
      format
    end
  end
end
