require 'DuperVisor/version'
require 'require_dir'
module DuperVisor
  extend RequireDir
  init_from_source __FILE__
end

DuperVisor.dir_r 'dupervisor'
# require_relative 'DuperVisor/cli'
# require_relative 'DuperVisor/formats'
# require_relative 'DuperVisor/detector'
# require_relative 'DuperVisor/parser'
# require_relative 'DuperVisor/renderer'
# require_relative 'DuperVisor/main'

