require 'spec_helper'
module DuperVisor
  RSpec.describe Main do
    let(:stdout) { instance_double('IO') }

    let(:config) { Config.new(to: :ini, output: stdout) }

    let(:yaml_file) { 'spec/fixtures/supervisord.yml' }
    let(:yaml_string) { File.read(yaml_file) }

    let(:ini_file) { 'spec/fixtures/supervisord.ini' }
    let(:ini_string) { File.read(ini_file) }

    let(:main) { Main.new(config) }

    before do
      expect(ARGF).to receive(:filename).and_return(yaml_file)
      expect(ARGF).to receive(:read).and_return(yaml_string)
    end

    context 'when running from yaml' do
      it 'correctly outputs ini file' do
        expect(stdout).to receive(:puts).with(ini_string)
        expect(stdout).to receive(:close)
        expect(main.run).to match(/\[supervisord\]/)
      end
    end

    context 'when parsing fails' do
      let(:yaml_string) { "\t\tasfasdfa\n{}s:f \t -sdfa" }
      it 'should rescue from ParseError' do
        expect(main).to receive(:report_error)
        expect(main.run).to be_nil
      end
    end
  end
end
