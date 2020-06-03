# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

def shell(*args)
  puts "running: #{args.join(' ')}"
  system(args.join(' '))
end

task :permissions do
  shell('rm -rf pkg/')
  shell("chmod -v o+r,g+r * */* */*/* */*/*/* */*/*/*/* */*/*/*/*/*")
  shell("find . -type d -exec chmod o+x,g+x {} \\;")
end

task build: :permissions

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = %w(lib/**/*.rb exe/*.rb - README.adoc LICENSE.adoc)
  t.options.unshift('--title', "This gem's purpose in life is to freely convert various configurations between supported formats, which are currently YAML, JSON and Windows INI file format. The gem is named after a popular package supervisord, which uses INI file format for it's configuration. This gem will allow you to move supervisord configuration into a YAML file, and integrate with other DevOps tools, while generating INI file on the fly. When installed, library exposes 'dv' executable, which is a an easy-to-use converter between these three formats.")
  t.after = -> { exec('open doc/index.html') } if RUBY_PLATFORM =~ /darwin/
end

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop)

task default: %i[spec rubocop]
