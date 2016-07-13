require 'dupervisor/version'
require 'require_dir'
module DuperVisor
  extend RequireDir
  init_from_source __FILE__
end

DuperVisor.dir_r 'dupervisor'
