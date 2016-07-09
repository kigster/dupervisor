require 'spec_helper'
require 'dupervisor/detector'

module DuperVisor
  RSpec.describe ExtensionDetector do
    before do
      expect(ARGF).to receive(:filename).and_return(input)
    end

    let(:config) { Config.new(output: output) }
    let(:bogus_dir) { '/Users/kig/tmp/' }
    let(:ini) { bogus_dir + 'file_whatever.ini' }
    let(:yml) { bogus_dir + 'some_other_file.yml' }
    let(:yaml) { bogus_dir + 'some_other_file.yaml' }
    let(:json) { bogus_dir + 'some_other_file.json' }
    let(:mapping) { { ini: :ini, json: :json, yaml: :yaml, yml: :yaml } }

    context 'when guessing format from filename' do
      %i(ini yaml yml json).each do |format|
        context "and the format is #{format}" do
          let(:input) { send(format) }
          let(:output) { send(format) }
          let(:detector) { ExtensionDetector.new(config) }
          context 'input' do
            subject { detector.detect }
            it { is_expected.to eql(mapping[format]) }
          end
          context 'output' do
            subject { detector.detect }
            it { is_expected.to eql(mapping[format]) }
          end
        end
      end
    end
  end
end
