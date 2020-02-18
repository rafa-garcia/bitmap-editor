# frozen_string_literal: true

require 'bitmap_editor/interpreter/mapper'

describe BitmapEditor::Interpreter::Mapper do
  subject { BitmapEditor::Interpreter::Mapper }

  describe '::resolve' do
    describe 'when called without arguments' do
      it 'raises an exception' do
        expect { subject.resolve }.must_raise ArgumentError
      end
    end

    describe 'when called with an argument' do
      it 'raises an exception' do
        expect { subject.resolve }.must_raise ArgumentError
      end
    end

    describe 'when called with two arguments' do
      describe 'and they are valid' do
        it 'returns mapped data' do
          
          
        end
      end
    end
  end
end
