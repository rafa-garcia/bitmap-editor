# frozen_string_literal: true

require 'bitmap_editor/command_parser'

describe BitmapEditor::CommandParser, :parse do
  subject { BitmapEditor::CommandParser }

  describe 'when called without arguments' do
    it 'raises an exception' do
      expect { subject.parse }.must_raise ArgumentError
    end
  end

  describe 'when called with an argument' do
    describe 'and it is invalid' do
      it 'raises an exception' do
        expect { subject.parse(['invalid_entry']) }.must_raise NoMethodError
      end
    end

    describe 'and it is valid' do
      let(:raw_entry)         { '   a    4 2 x     ' }
      let(:clean_entry)       { { command: :A, arguments: [4, 2, 'X'] } }
      let(:command_operation) { :print }
      let(:command_params)    { { range_h: [], range_v: [], colour: 'X' } }
      let(:command)           { Minitest::Mock.new }
      let(:command_klass)     { Minitest::Mock.new }

      it 'cleans the entry' do
        command.expect :operation,  command_operation
        command.expect :parameters, command_params
        command_klass.expect :call, command, [clean_entry]

        BitmapEditor::CommandParser::Command.stub :new, command_klass do
          subject.parse(raw_entry) do |operation, *parameters|
            operation.must_equal :print
            parameters.must_equal [{ range_h: [], range_v: [], colour: 'X' }]
          end
        end
        assert_mock command
        assert_mock command_klass
      end
    end
  end
end
