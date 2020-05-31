# frozen_string_literal: true

require 'spec_helper'
require 'dupervisor/formats'

# rubocop: disable Style/GuardClause
module DuperVisor
  RSpec.describe Formats do
    let(:base) { DuperVisor::Formats::Base }

    context 'format aliases' do
      subject { base.formats.keys }
      it { is_expected.to include(:yml) }
      it { is_expected.to include(:yaml) }
    end

    context 'new format' do
      class Blurp < DuperVisor::Formats::Base
        class BlurpError < RuntimeError;
        end
        aliases :burp
        from ->(body) {
          if body =~ /burp/
            raise BlurpError, 'No burping!'
          else
            { blurp: 'boo' }
          end
        }
        to ->(_hash) { 'blurp' }
        errors BlurpError
      end

      context '#aliases' do
        subject { base.formats.keys }
        it { is_expected.to include(:burp) }
        it { is_expected.to include(:blurp) }
        it 'should respond to #aliases' do
          expect(Blurp.aliases).to eql([:burp])
        end
      end
      context '#to ' do
        context 'no errors' do
          subject { Blurp.to.call('something') }
          it { is_expected.to eql('blurp') }
        end
        context 'error raised' do
          subject { -> { Blurp.from.call('burp') } }
          it { is_expected.to raise_error(Blurp::BlurpError) }
        end
      end
    end
  end
  module Formats
    RSpec.describe Accessors do
      class A
        include DuperVisor::Formats::Accessors
      end
      context '#formats' do
        subject { A.new.formats }
        it { is_expected.to be_an_instance_of(Hash) }
        it { is_expected.not_to be_empty }
        context 'registered formats' do
          subject { A.new.formats.keys }
          it { is_expected.to include(:yaml, :json, :ini) }
        end
      end
      context '#format_classes' do
        subject { A.new.format_classes }
        it { is_expected.to include(DuperVisor::Formats::Ini) }
        it { is_expected.to include(DuperVisor::Formats::YAML) }
        it { is_expected.to include(DuperVisor::Formats::JSON) }
      end
    end
  end
end

# rubocop: enable Style/GuardClause
