# frozen_string_literal: true

require 'bitmap_editor/interpreter/parser'

describe BitmapEditor::Interpreter::Parser do
  subject { BitmapEditor::Interpreter::Parser }

  describe '::scan' do
    describe 'when called without arguments' do
      it 'raises an exception' do
        expect { subject.scan }.must_raise ArgumentError
      end
    end

    describe 'when called with an argument' do
      describe 'and it is invalid' do
        it 'raises an exception' do
          expect { subject.scan(['invalid_entry']) }.must_raise NoMethodError
        end
      end

      describe 'and it is valid' do
        describe 'when the input contains command arguments' do
          let(:raw_entry)   { '          a    4     2       x       ' }
          let(:clean_entry) { { command: :A, arguments: [4, 2, 'X'] } }

          it 'yields a normalised command with arguments' do
            subject.scan(raw_entry) do |cmd_code, args_ary|
              _(cmd_code).must_equal clean_entry[:command]
              _(args_ary).must_equal clean_entry[:arguments]
            end
          end
        end

        describe 'when the input does not contain command arguments' do
          let(:raw_entry)   { '          a           ' }
          let(:clean_entry) { { command: :A, arguments: [] } }

          it 'yields a normalised command without arguments' do
            subject.scan(raw_entry) do |cmd_code, args_ary|
              _(cmd_code).must_equal clean_entry[:command]
              _(args_ary).must_equal clean_entry[:arguments]
            end
          end
        end
      end
    end
  end
end
