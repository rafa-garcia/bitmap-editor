# frozen_string_literal: true

describe BitmapEditor::Interpreter do
  subject { BitmapEditor::Interpreter }

  describe '::process' do
    describe 'when called with no arguments' do
      it 'raises an exception' do
        _(proc { subject.process }).must_raise ArgumentError
      end
    end

    describe 'when called with an argument' do
      let(:input)  { 'input text' }
      let(:parser) { Minitest::Mock.new }

      it 'processes the input' do
        parser.expect :call, [:output, { object: true }], [input]

        subject::Parser.stub :scan, parser do
          subject.process(input)
        end
        assert_mock parser
      end
    end
  end
end
