module Dupervisor
  class Detector
    attr_accessor :config
    def initialize(config)
      self.config = config
    end

    def detect_output
      return config.to if config.to
      if config.output.is_a?(String)
        config.to = format_from_extension(config.output.dup)
      end
      config.to
    end

    def detect_input(body = nil)
      return config.from if config.from && !config.from.eql?(:auto)
      if config.input.is_a?(String)
        config.from = format_from_extension(config.input.dup)
      end
      config.from
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
