# frozen_string_literal: true

require 'bitmap_editor'

describe BitmapEditor, :run do
  describe 'when called with no arguments' do
    subject { BitmapEditor.run }

    it 'raises an exception' do
      expect { subject }.must_raise ArgumentError
    end
  end

  describe 'when called with an argument' do
    subject { BitmapEditor.run(command_entries) }

    describe 'and it is invalid' do
      let(:command_entries) { %i[invalid_input] }

      it 'outputs a message' do
        expect { subject }.must_raise NoMethodError
      end
    end

    describe 'and it is valid' do
      let(:parser) { Minitest::Mock.new }

      describe 'when there is no bitmap' do
        let(:command_entries) { "S\n" }

        it 'raises an exception' do
          parser.expect :call, :show, [command_entries]

          BitmapEditor::CommandParser.stub :parse, parser do
            subject
            # expect { subject }.must_raise BitmapEditor::Errors::MissingBitmap
          end
          assert_mock parser
        end
      end

      describe 'when there is a bitmap' do
        it 'outputs a bitmap' do
          let(:command_entries) do
            <<~HEREDOC
              S
            HEREDOC
          end

          it 'raises an exception' do
            # parser_mock.expect :call, nil

            # BitmapEditor::CommandParser.stub :parse, parser_mock do
            #   proc { subject }.must_raise StandardError
            # end

            # assert_mock parser_mock
          end
        end
      end
    end
  end
end
