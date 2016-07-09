require 'DuperVisor/version'
require 'require_dir'
module DuperVisor
  extend RequireDir
  init_from_source __FILE__
end

require_relative 'DuperVisor/cli'
require_relative 'DuperVisor/main'
require_relative 'DuperVisor/generator'
require_relative 'DuperVisor/detector'

