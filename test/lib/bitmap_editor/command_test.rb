# frozen_string_literal: true

require 'bitmap_editor/command'

describe BitmapEditor::Command do
  subject { BitmapEditor::Command }

  describe '::new' do
    describe 'when called without arguments' do
      it 'raises an exception' do
        expect { subject.new }.must_raise ArgumentError
      end
    end

    describe 'when called with an argument' do
      let(:interpreter) { Minitest::Mock.new }

      describe 'and it is invalid' do
        describe 'when the command is not supported' do
          let(:error) { -> { raise BitmapEditor::Command::InvalidCommand } }

          it 'raises an exception' do
            interpreter.expect :call, error
            BitmapEditor::Interpreter.stub :process, interpreter do
              _(proc { subject.new }).must_raise ArgumentError
            end
          end
        end
      end

      describe 'and it is valid' do
        let(:raw_entry) { '    I   3             4     ' }
        let(:interpreter_output) { [:new, { columns: 3, rows: 4 }] }

        it 'initialises' do
          interpreter.expect :call, interpreter_output, [raw_entry]
          BitmapEditor::Interpreter.stub :process, interpreter do
            instance = subject.new(raw_entry)
            _(instance).must_be_instance_of BitmapEditor::Command
          end
        end
      end
    end
  end
end
