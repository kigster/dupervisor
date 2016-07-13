require 'spec_helper'

module DuperVisor
  module Formats

    RSpec.describe Ini do
      let(:hash) {
        {
          'supervisord' => { 'root' => '/var/supervisord' },
          'program'     => {
            'pgbouncer' => { 'command' => '/usr/local/bin/pgbouncer' }
          }
        }
      }

      context 'converting to the INI file format' do
        let(:format) { :ini }
        let(:inifile_string) { Ini.to.call(hash) }

        context 'when two level hash is found' do
          it 'should merge second and third with a colon' do
            expect(inifile_string).to match /\[program:pgbouncer\]/
          end
        end
      end
    end
  end
end
