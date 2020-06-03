# frozen_string_literal: true

require 'yaml'
require_relative '../formats'

module DuperVisor
  module Formats
    class YAML < Base
      aliases %i(yml)
      from    ->(string)  { ::YAML.safe_load(string) }
      to      ->(hash)    { ::YAML.dump(hash) }
      errors  [Psych::SyntaxError]
    end
  end
end
