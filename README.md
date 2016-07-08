[![Gem Version](https://badge.fury.io/rb/dupervisor.svg)](https://badge.fury.io/rb/dupervisor)
[![Build Status](https://travis-ci.org/kigster/dupervisor.svg?branch=master)](https://travis-ci.org/kigster/dupervisor)
[![Code Climate](https://codeclimate.com/github/kigster/dupervisor/badges/gpa.svg)](https://codeclimate.com/github/kigster/dupervisor)
[![Test Coverage](https://codeclimate.com/github/kigster/dupervisor/badges/coverage.svg)](https://codeclimate.com/github/kigster/dupervisor/coverage)
[![Issue Count](https://codeclimate.com/github/kigster/dupervisor/badges/issue_count.svg)](https://codeclimate.com/github/kigster/dupervisor)

# DuperVisor &tm;

The super-duper awesome DuperVisor gem is your helper if you want to use a great tool called __supervisord__, which is highly applicable today, but unfortunately uses an [archaic configuration file format](http://supervisord.org/configuration.html) of the decades old Windows INI files (Yuck!)

And while we can try to forgive the authors for using Windows environment variable format like %BOOO% (yuck!), but we just could not deal with the INI format. Something had to be done about it.

## YAML/JSON vs INI

Consider the following example taken from the (_supervisord_ configuration documentation)[http://supervisord.org/configuration.html]:

```ini
[supervisord]
nodaemon = false
minfds = 1024
minprocs = 200
umask = 022
user = chrism
identifier = supervisor
directory = /tmp
nocleanup = true
childlogdir = /tmp
strip_ansi = false
environment = PATH="/usr/bin:/usr/local/bin:/bin:/sbin",ENVIRONMENT="development"

[program:cat]
command=/bin/cat
process_name=%(program_name)s
numprocs=1
directory=/tmp
umask=022
priority=999
autostart=true
autorestart=unexpected

```

We think that it is much easier to read this:

```yaml
supervisord:
  nodaemon: false
  minfds: 1024
  minprocs: 200
  umask: 022
  user: chrism
  identifier: supervisor
  directory: /tmp
  nocleanup: true
  childlogdir: /tmp
  strip_ansi: false
  environment: PATH="/usr/bin:/usr/local/bin:/bin:/sbin",ENVIRONMENT="development"

program:
  cat:
    command: /bin/cat
    process_name: %(program_name)s
    numprocs: 1
    directory: /tmp
    umask: 022
    priority: 999
    autostart: true
    autorestart: unexpected
```

Not only that, but with this structure you can leverage existing tools for merging information from the default environment to your production, and so on.

## Installation

Install the gem using the `gem install dupervisor` command, or if you are using Bundler, you can add it to your gem file like so:

```
gem 'dupervisor'
```

## Usage

You can use the provided executable `dupervisor` to convert from a JSON or YAML file into an INI

```
Usage: dupervisor [options]

       Convert between several hierarchical configuration
       file formats, such as ini, yaml, json

Specific options:
        --ini                        Assume the output is INI file
        --yaml                       Assume the output is YAML file
        --json                       Assume the output is JSON file

    -i, --input [FILE]               File to read, if not supplied read from STDIN
                                     If provided, will be used to guess source format

    -o, --output [FILE]              File to write, if not supplied write to STDOUT
                                     If provided, will be used to guess destination format

    -v, --verbose                    Print extra debugging info

Examples:

    # guess input format, write output in INI
    cat config.yml | dupervisor --ini > config.ini

    # convert from INI to JSON using file extensions for format
    dupervisor -i config.ini -f config.json

Common options:
    -h, --help                       Show this message
        --version                    Show version
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kigster/warp-dir.

## Author

<p>&copy; 2016 Konstantin Gredeskoul, all rights reserved.</p>

#### Acknowledgements

 * [Shippo, Inc.](https://goshippo.com/) for sponsoring this work financially, and their commitment to open source.
 * [Wissam Jarjoul](https://github.com/bosswissam) for many great ideas and for being a great partner.

## License

This project is distributed under the [MIT License](https://raw.githubusercontent.com/kigster/dupervisor/master/LICENSE).
