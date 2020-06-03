# frozen_string_literal: true

require 'spec_helper'
require 'dupervisor/detector'

module DuperVisor
  RSpec.describe Detector do
    let(:bogus_dir) { '/Users/kig/tmp/' }
    let(:ini) { bogus_dir + 'file_whatever.ini' }
    let(:yml) { bogus_dir + 'some_other_file.yml' }
    let(:yaml) { bogus_dir + 'some_other_file.yaml' }
    let(:json) { bogus_dir + 'some_other_file.json' }
    MAPPING = { ini: :ini, json: :json, yaml: :yaml, yml: :yaml }.freeze

    context 'when have the filename' do
      %i(ini yaml yml json).each do |format|
        context "of type #{format}" do
          let(:filename) { send(format) }
          subject { Detector.new(filename).detect }
          it "autodetects it to be #{MAPPING[format]}" do
            is_expected.to eql(MAPPING[format])
          end
        end
      end
    end
  end
end
