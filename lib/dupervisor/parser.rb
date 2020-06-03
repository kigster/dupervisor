# frozen_string_literal: true

require_relative 'formats'
require_relative 'errors'

module DuperVisor
  # This class is responsible for coordination of parsing attempts of a
  # given content with different format parsers.
  class Parser
    include DuperVisor::Formats::Accessors

    attr_accessor :content, :parse_errors

    def initialize(body)
      self.content = Content.new(body: body)
    end

    def parse(input_format = nil)
      self.parse_errors = {}

      content.parse_result = nil

      formats_to_check = input_format ? [formats[input_format]] : format_classes

      formats_to_check.each do |format_class|
        format       = format_class.format
        parse_result = try_format(format, format_class)

        next unless parse_result

        content.parse_result = parse_result
        content.format       = format
        break
      end

      # rubocop: disable Style/GuardClause
      unless content.parse_result || parse_errors.empty?
        if input_format
          raise Errors::ParseError, "Can not parse from format #{input_format}.\nFormat exception:" +
                                    parse_errors.values.map(&:inspect).join("\n")
        else
          raise Errors::FormatNotFound, 'No suitable format detected. Query #parse_errors for specifics.'
        end
      end
      # rubocop: enable Style/GuardClause

      content
    end

    def try_format(format, format_class)
      format_class.from.call(content.body)
    rescue *format_class.errors => e
      parse_errors[format] = e
      nil
    end
  end
end
