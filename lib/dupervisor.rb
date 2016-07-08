require 'dupervisor/version'
require 'require_dir'
module Dupervisor
  extend RequireDir

  init_from_source __FILE__
end

require_relative 'dupervisor/cli'
require_relative 'dupervisor/detector'

