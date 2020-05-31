# frozen_string_literal: true

module DuperVisor
  module Formats
    module Accessors
      def formats
        ::DuperVisor::Formats::Base.formats
      end

      def format_classes
        ::DuperVisor::Formats::Base.formats.values.map(&:to_s).sort.uniq.map { |klass| Module.const_get(klass) }
      end
    end

    class Base
      @formats = {}

      class << self
        attr_writer :formats
        attr_accessor :format_aliases

        # Returns a hash: +{ format: format_class, format_alias: format_class, ...}+
        # For example { yaml: YAML, yml: YAML, etc.}
        def formats
          aliases = {}
          @formats.each_value do |format_class|
            if format_class.aliases && !format_class.aliases.empty?
              format_class.aliases.each { |format_alias| aliases[format_alias] = format_class }
            end
          end
          @formats.merge!(aliases)
        end
      end

      def self.inherited(klass)
        klass.instance_eval do
          class << self
            %i(aliases from to errors).each do |a|
              define_method(a) do |*args|
                arg = args.first
                %i(aliases errors).each do |array_field|
                  if a == array_field && arg && !arg.is_a?(Array)
                    arg = [arg]
                  end
                end
                if arg
                  instance_variable_set("@#{a}".to_sym, arg)
                else
                  instance_variable_get("@#{a}".to_sym)
                end
              end
            end
          end

          def format
            name.split(/::/)[-1].downcase.to_sym
          end
        end

        formats[klass.format] = klass
      end
    end
  end
end

DuperVisor.dir('dupervisor/formats')
