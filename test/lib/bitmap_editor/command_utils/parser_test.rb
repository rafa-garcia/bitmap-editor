# frozen_string_literal: true

require 'bitmap_editor/command_utils/parser'

describe BitmapEditor::CommandUtils::Parser, :parse do
  subject { BitmapEditor::CommandUtils::Parser }

  describe 'when called without arguments' do
    it 'raises an exception' do
      expect { subject.process }.must_raise ArgumentError
    end
  end

  describe 'when called with an argument' do
    describe 'and it is invalid' do
      it 'raises an exception' do
        expect { subject.process(['invalid_entry']) }.must_raise NoMethodError
      end
    end

    describe 'and it is valid' do
      let(:raw_entry)   { '          a    4     2       x       ' }
      let(:clean_entry) { { command: :A, arguments: [4, 2, 'X'] } }

      it 'yields the clean entry' do
        subject.process(raw_entry) do |cmd_code, args_ary|
          _(cmd_code).must_equal clean_entry[:command]
          _(args_ary).must_equal clean_entry[:arguments]
        end
      end
    end
  end
end
