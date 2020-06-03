# frozen_string_literal: true

require 'json'
require_relative '../formats'
module DuperVisor
  module Formats
    class JSON < Base
      from   ->(string) { ::JSON.parse(string) }
      to     ->(hash)   { ::JSON.pretty_generate(hash) }
      errors [::JSON::ParserError]
    end
  end
end
