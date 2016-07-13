require 'spec_helper'
module DuperVisor
  RSpec.describe CLI do
    let(:cli) { DuperVisor::CLI.new(args) }
    let(:config) { cli.parse }
    %i(yaml ini json).each do |format|
      context "when --#{format.to_s} is passed in" do
        let (:args) { ["--#{format.to_s}"] }
        it 'should return Config instance' do
          expect(config).to be_kind_of(Config)
        end
        it 'should property set config.to' do
          expect(config.to).to eql(format)
        end
        it 'should not set config.output' do
          expect(config.output).to be_nil
        end
      end
    end

    context 'when --output is provided' do
      let (:args) { %w(-o somefile.json) }
      it 'should property set config.to' do
        expect(config.output).to eql('somefile.json')
      end
    end

    context 'when wrong flags are provided' do
      let (:args) { %w(--hello) }
      it 'should raise an exception' do
        expect { config }.to raise_error(OptionParser::InvalidOption)
      end
    end

    context 'when no config.to is specified' do
      let (:args) { %w() }
      it 'should raise an exception' do
        expect { config.validate! }.to raise_error(DuperVisor::CLIError)
      end
    end
  end
end
