[![Gem Version](https://badge.fury.io/rb/dupervisor.svg)](https://badge.fury.io/rb/dupervisor)
[![Build Status](https://travis-ci.org/kigster/dupervisor.svg?branch=master)](https://travis-ci.org/kigster/dupervisor)
[![Code Climate](https://codeclimate.com/github/kigster/dupervisor/badges/gpa.svg)](https://codeclimate.com/github/kigster/dupervisor)
[![Test Coverage](https://codeclimate.com/github/kigster/dupervisor/badges/coverage.svg)](https://codeclimate.com/github/kigster/dupervisor/coverage)
[![Issue Count](https://codeclimate.com/github/kigster/dupervisor/badges/issue_count.svg)](https://codeclimate.com/github/kigster/dupervisor)

# dupervisor

`dupervisor` is a Ruby gem and a well tested library, as well as a CLI executable, that offer an easy way to convert configuration between any two of the supported formats, which (at this time) are:  

 * JSON
 * YAML
 * and the Windows INI file formats. 

Please see the [section "Motivation"](#motivation) below, which contains further discussion about why this is useful.

If you enjoy using this library, please star the repo, and do submit pull requests and/or bug reports, as well as any other contributions – which are all accepted with gratitude.

## YAML/JSON vs INI

Consider the following example taken from the [_supervisord_ configuration documentation](http://supervisord.org/configuration.html]):

```ini
[supervisord]
nodaemon = false
minfds = 1024
minprocs = 200

[program:cat]
command=/bin/cat
process_name=%(program_name)s
autostart=true
autorestart=unexpected
```

We think that it is much easier to read this:

```yaml
supervisord:
  nodaemon: false
  minfds: 1024
  minprocs: 200

program:
  cat:
    command: /bin/cat
    process_name: %(program_name)s
    autostart: true
    autorestart: unexpected
```

Besides arguably better readability, YAML format also allows you to leverage existing configuration management tools such as Chef, SaltStack or Ansible.

### Supervisord Specifics

When parsing INI files, and upon encountering a hash key of the form `word1:word2`, such key is broken up into the two parts and second part is used to create a sub-hash, thus generating a three-level hash. Supervisord uses this syntax for describing all commands to run, such as `program:cat` or `program:pgbouncer`, etc. Parser for INI format will create a hash with keys `cat` and `pgbouncer`, which itself will be mapped to the key `program`. 

Reverse is also true – and such a three-level hash will be collapsed by joining second and third level keys with a colon, before rendering INI file.

## Installation

Install the gem:

```
gem install dupervisor
``` 

or, if you are using Bundler, you can add it to your gem file like so:

```ruby
gem 'dupervisor'
```

## Usage

### From Ruby Code

To perform config transformations in ruby, you would typically use the `DuperVisor::Parser` class to parse an existing format and, optionally, to guess the format of the content. 

You would then use the `DuperVisor::Renderer` class to render the intermediate hash into the destination format, like so:

```ruby
# This is how you can parse content by specifying the format
content = Parser.new(File.read('myfile.json')).parse(:json) 

# But the gem can also guess the source format from either 
# the filename (if available) or the source content
content = Parser.new(File.read('myfile.json')).parse()
content.format # => :json
content.parse_result # => { ... } Hash  

# Finally, here we are using Renderer to convert a hash stored
# in content.parse_result into a YAML formatted string.
Renderer.new(content.parse_result).render(:yaml) # => YAML string
```

There is an additional helper available to grab format from a filename:

```ruby
# This helper extracts format from a file extension
Detector.new('myfile.json').detect  # => :json
```

### Command Line

You can also use the provided executable `dv` to transform between supported formats.

```bash
$ dv [source_file | STDIN ] 
     [ --yaml | --ini | --json ] 
     [ -o | --output output_file | STDOUT ]
```

#### CLI Options

```
        --ini            Generate an INI file
        --yaml           Generate a YAML file
        --json           Generate a JSON file
    -o, --output [FILE]  File to write, if not supplied write to STDOUT
    -v, --verbose        Print extra debugging info
    -h, --help           Show this message
        --version        Show version
```

#### Examples

__Guess input format, convert YAML format to an INI file:__

```bash
$ cat config.yml | dv --ini > config.ini
```

__Guess input format, convert INI format to a JSON file:__

```bash
$ dv config.ini --json -o config.json
```

## Adding New Formats

It should be relatively trivial to add new formats to the gem. Please check out the `lib/dupervisor/formats` folder, copy eg. `yaml.rb` file to a new name, and update the code.

Below is the actual code of YAML converter. 

```ruby
module DuperVisor
  module Formats
    class YAML < Base
      aliases %i(yml)
      from    ->(string)  { ::YAML.load(string) }
      to      ->(hash)    { ::YAML.dump(hash)   }
      errors  [Psych::SyntaxError]
    end
  end
end
```

 * __aliases__ are additional names of the format. Main name is the class name without the modules.
 * __from__ is a proc that receives a string, and should return a hash or raise an error.
 * __to__ is a proc that receives a hash, and is supposed to return a string representing the hash in a given format.
 * __errors__ is a list of exceptions that parsing (`#to`) may raise if the content is not valid for this format.


## Motivation

This tool was originally created to allow storing as YAML configuration of [__supervisord__](http://supervisord.org), which uses a [decades old configuration file format](http://supervisord.org/configuration.html) known as the Windows INI file.

Some of the modern DevOps tools (such as Ansible and SaltStack) are using YAML format extensively to configure the environments. Chef stores node attributes as a hash, which is DuperVisor's intermediate data structure. Therefore DuperVisor offers an opportunity to "embed" INI-files for tools like _supervisord_ natively within the configuration management software, to keep all configuration centralized. When configuration management tool executes, INI files can be re-rendered on the fly. 

Note that the same applies to rendering into YAML or JSON, and that the source could also be any one of the three.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kigster/dupervisor.

## Author

<p>&copy; 2016 Konstantin Gredeskoul, all rights reserved.</p>

#### Acknowledgements

 * [Shippo, Inc.](https://goshippo.com/) for sponsoring this work financially, and their commitment to open source.
 * [Wissam Jarjoul](https://github.com/bosswissam) for many great ideas and a good eye for bugs.

## License

This project is distributed under the [MIT License](https://raw.githubusercontent.com/kigster/dupervisor/master/LICENSE).
