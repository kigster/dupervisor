require 'spec_helper'
require 'dupervisor/parser'

module DuperVisor

  RSpec.describe Parser do
    let(:parser) { Parser.new(body) }
    let(:parsed_result) { { 'main' => { 'first' => 'Bob', 'last' => 'Marley' } } }

    def self.verify_hash(format)
      let(:content) { parser.parse(format) }
      context 'return object' do
        subject { content }
        it { is_expected.to be_an_instance_of(Content) }
        it "should have #{format} type set" do
          expect(content.format).to eql(format)
        end
      end
      context 'parse result' do
        subject { content.parse_result }
        it { is_expected.to eql(parsed_result) }
      end
    end

    context 'yaml content' do
      let(:body) { "main:\n  first: Bob\n  last: Marley\n" }
      verify_hash(:yaml)
    end

    context 'json content' do
      let(:body) { '{ "main": { "first": "Bob", "last": "Marley" } }' }
      verify_hash(:json)
    end

    context 'ini content' do
      context 'no third level hash' do
        let(:body) { "[main]\nfirst = Bob\nlast = Marley\n" }
        verify_hash(:ini)
      end

      context 'with third level hash' do
        let(:body) { "[main]\nfirst = Bob\nlast = Marley\n\n[program:pgbouncer]\ncmd = /usr/local/bin/pgbouncer" }
        let(:parsed_result) { {
          'main'    => { 'first' => 'Bob', 'last' => 'Marley' },
          'program' => { 'pgbouncer' => { 'cmd' => '/usr/local/bin/pgbouncer' } }
        } }
        verify_hash(:ini)
      end
    end

    context 'bad content' do
      let(:body) { "\n\t\t\tE@()@!#% {--- }sadfasdf" }
      %i(ini yaml yml json).each do |format|
        context "and the format is #{format}" do
          it 'should raise parse error' do
            expect { parser.parse(format) }.to raise_error(Parser::ParseError)
          end
        end
      end
    end
  end
end
