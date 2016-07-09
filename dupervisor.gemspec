# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'DuperVisor/version'

Gem::Specification.new do |spec|
  spec.name          = 'DuperVisor'
  spec.version       = DuperVisor::VERSION
  spec.authors       = ['Konstantin Gredeskoul']
  spec.email         = ['kigster@gmail.com']

  spec.summary       = %q{Convert between YAML/JSON format and Windows INI format. }
  spec.description   = %q{This gem's purpose in life is to convert a configuration stored in a hierarchical hash (YAML/JSON) and into the Windows INI file format frmo the Dark Ages. It's named after a popular package supervisord, which uses INI file format for it's configuration. If you are using supervisord or any other software, with the help of this gem you can stop editing INI files and enjoy the readability of YAML.}
  spec.homepage      = 'https://guthub.com/kigster/DuperVisor'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'require_dir'
  spec.add_dependency 'awesome_print'
  spec.add_dependency 'colored2'
  spec.add_dependency 'inifile'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
