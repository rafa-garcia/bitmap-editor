# frozen_string_literal: true

require 'bitmap_editor'

describe BitmapEditor, :new do
  subject { BitmapEditor.new }

  it 'initialises' do
    subject.must_be_instance_of BitmapEditor
  end

  describe :run do
    describe 'when called with no arguments' do
      subject { BitmapEditor.new.run }

      it 'raises an exception' do
        expect { subject }.must_raise ArgumentError
      end
    end

    describe 'when called with an argument' do
      subject { BitmapEditor.new.run file_path }

      describe 'and it is invalid' do
        let(:file_path) { './path_to/invalid_file.txt' }

        it 'outputs a message' do
          expect { subject }.must_output "please provide correct file\n"
        end
      end

      describe 'and it is valid' do
        let(:file_path) { 'examples/show.txt' }

        it 'opens the file' do
          subject.must_be_instance_of File
        end

        it 'outputs a message' do
          expect { subject }.must_output "There is no image\n"
        end
      end
    end
  end
end
