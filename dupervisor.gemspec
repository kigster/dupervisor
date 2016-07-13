# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dupervisor/version'

Gem::Specification.new do |spec|
  spec.name          = 'dupervisor'
  spec.version       = DuperVisor::VERSION
  spec.authors       = ['Konstantin Gredeskoul']
  spec.email         = ['kigster@gmail.com']

  spec.summary       = %q{Convert between YAML/JSON format and Windows INI format. }
  spec.description   = %q{This gem's purpose in life is to freely convert various configurations between supported formats, which are currently YAML, JSON and Windows INI file format. The gem is named after a popular package supervisord, which uses INI file format for it's configuration. This gem will allow you to move supervisord configuration into a YAML file, and integrate with other DevOps tools, while generating INI file on the fly. When installed, library exposes 'dv' executable, which is a an easy-to-use converter between these three formats.} 
  spec.homepage      = 'https://github.com/kigster/dupervisor'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'require_dir'
  spec.add_dependency 'awesome_print'
  spec.add_dependency 'colored2'
  spec.add_dependency 'inifile'

  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
