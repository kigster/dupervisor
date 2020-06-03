# frozen_string_literal: true

require 'spec_helper'

module DuperVisor
  RSpec.describe Main do
    FIXTURES = {
      yaml: File.expand_path('../fixtures/supervisord.yml', __dir__),
      ini: File.expand_path('../fixtures/supervisord.ini', __dir__),
      json: File.expand_path('../fixtures/supervisord.json', __dir__),
    }.freeze

    JSON_ARRAY = <<~JSON
      [
        {
          "id": "a8cfcb76-7f24-4420-a5ba-d46dd77bdffd",
          "username": "Sofiel",
          "age": "frozen",
          "rank": 20,
          "levelingRate": 0.63
        },
        {
          "id": "58e9b5fe-3fde-4a27-8e98-682e58a4a65d",
          "username": "Arderon",
          "age": "frozen",
          "rank": 375,
          "levelingRate": 0.4
        }
      ]
    JSON

    let(:stdout) { StringIO.new }

    FIXTURES.each_pair do |from_type, filename|
      FIXTURES.each_key do |to_type|
        context "from #{from_type} to #{to_type}" do
          let(:string) { File.read(filename) }
          let(:config) { Config.new(to: from_type, output: stdout) }
          let(:main) { Main.new(config) }

          before do
            expect(ARGF).to receive(:filename).and_return(filename)
            expect(ARGF).to receive(:read).and_return(string)
          end

          context 'when running from yaml' do
            it 'correctly outputs ini file' do
              expect(main.run).to match(/supervisord/)
            end
          end
        end
      end
    end

    context 'when parsing fails' do
      let(:config) { Config.new(to: :ini, output: stdout) }
      let(:main) { Main.new(config) }
      let(:string) { "\t\tasfasdfa\n{}s:f \t -sdfa" }

      before do
        expect(ARGF).to receive(:filename).and_return(FIXTURES[:yaml])
        expect(ARGF).to receive(:read).and_return(string)
      end

      it 'should rescue from ParseError' do
        expect(main).to receive(:report_error)
        expect(main.run).to be_nil
      end
    end

    context 'when parsing a JSON array' do
      let(:config) { Config.new(to: :yaml, output: stdout) }
      let(:main) { Main.new(config) }
      let(:string) { JSON_ARRAY }

      before do
        expect(ARGF).to receive(:filename).and_return(FIXTURES[:json])
        expect(ARGF).to receive(:read).and_return(string)
      end

      it 'should rescue from ParseError' do
        expect(main).not_to receive(:report_error)
        expect(main.run).to match /: Arderon/
      end
    end
  end
end
