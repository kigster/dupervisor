# frozen_string_literal: true

require 'dupervisor/version'
require 'require_dir'

module DuperVisor
  RequireDir.enable_require_dir! self, __FILE__
  dir_r 'dupervisor'
end
