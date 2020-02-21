# frozen_string_literal: true

require 'bitmap_editor'

describe BitmapEditor do
  describe '::new' do
    subject { BitmapEditor.new }

    describe 'when called with no arguments' do
      it 'initialises' do
        _(subject).must_be_instance_of BitmapEditor
      end

      it 'does not have a bitmap' do
        _(subject.instance_variable_get(:@image)).must_be_nil
      end
    end
  end

  describe '#run' do
    describe 'when called with no arguments' do
      subject { BitmapEditor.new.run }

      it 'raises an exception' do
        expect { subject }.must_raise ArgumentError
      end
    end

    describe 'when called with an argument' do
      subject { BitmapEditor.new.run(entries) }

      describe 'and it is invalid' do
        let(:entries) { %i[invalid_input] }

        it 'raises an exception' do
          expect { subject }.must_raise NoMethodError
        end
      end

      describe 'and it is valid' do
        let(:interpreter) { Minitest::Mock.new }
        let(:bitmap)      { Minitest::Mock.new }

        describe 'but there is no bitmap' do
          describe 'and the method does not create one' do
            let(:entries) { 'S' }
            let(:operation) { [:show, {}] }

            it 'raises an exception' do
              interpreter.expect :call, operation, [entries]

              BitmapEditor::Interpreter.stub :process, interpreter do
                expect { subject }.must_raise BitmapEditor::MissingBitmap
              end
              assert_mock interpreter
            end
          end

          describe 'and the method creates a new one' do
            let(:entries) { 'I 3 3' }
            let(:operation) { [:new, { columns: 3, rows: 3 }] }

            it 'calls ::new on the Bitmap class' do
              interpreter.expect :call, operation, [entries]
              bitmap.expect :call, true, [*operation]

              BitmapEditor::Interpreter.stub :process, interpreter do
                BitmapEditor::Bitmap.stub :public_send, bitmap do
                  subject
                end
                assert_mock bitmap
              end
              assert_mock interpreter
            end
          end
        end
      end
    end
  end
end
