# frozen_string_literal: true

module DuperVisor
  module Errors
    class Error < StandardError; end

    class ParseError < Error; end

    class FormatNotFound < ParseError; end

    class DataTypeNotSupported < Error; end
  end
end
