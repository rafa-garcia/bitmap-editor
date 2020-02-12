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
        expect { subject }.must_raise BitmapEditor::InvalidInputError
      end
    end

    describe 'and it is valid' do
      describe 'when the command is not recognised' do
        let(:command_entries) do
          <<~HEREDOC
            Z
          HEREDOC
        end

        it 'outputs a message' do
          expect { subject }.must_output("Unrecognised command :(\n", nil)
        end
      end

      describe 'when the command is recognised' do
        let(:command_entries) do
          <<~HEREDOC
            S
          HEREDOC
        end

        it 'outputs a message' do
          expect { subject }.must_output("There is no image\n", nil)
        end
      end
    end
  end
end
