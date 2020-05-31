# frozen_string_literal: true

require 'spec_helper'
require 'dupervisor/detector'

module DuperVisor
  RSpec.describe Content do
    let(:hash) {
      { 'section' => { 'first' => 'Bob', 'last' => 'Marley' } }
    }
    context 'converting from an existing format such as ' do
      %i(ini yaml yml json).each do |format|
        context format.to_s do
          let(:content) { Content.to_format_from(hash, format) }
          context 'should properly instantiate Content' do
            subject { content }
            it { is_expected.to be_an_instance_of(Content) }
          end

          it 'should still contain values' do
            expect(content.body).to match /Bob/
          end
        end
      end
    end
  end
end
