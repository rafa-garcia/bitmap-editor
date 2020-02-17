# frozen_string_literal: true

require './lib/bitmap_editor/bitmap'

describe BitmapEditor::Bitmap do
  subject { BitmapEditor::Bitmap.new(params) }

  describe '::new' do
    describe 'when called with no parameters' do
      let(:params) { {} }

      it 'fails to initialize' do
        expect { subject }.must_raise ArgumentError
      end
    end

    describe 'when called with parameters' do
      describe 'and the keys are invalid' do
        let(:params) { { wrong: 'parameter' } }

        it 'fails to initialize' do
          expect { subject }.must_raise ArgumentError
        end
      end

      describe 'and the keys are valid' do
        describe 'but the values are invalid' do
          describe 'when they can not be coerced' do
            let(:params) { { columns: 'wrong', rows: 'value' } }

            it 'fails to initialize' do
              expect { subject }.must_raise BitmapEditor::Errors::ArgumentError
            end
          end

          describe 'and even when they can be coerced' do
            let(:params) { { columns: '1', rows: '2' } }

            it 'fails to initialize' do
              expect { subject }.must_raise BitmapEditor::Errors::ArgumentError
            end
          end
        end

        describe 'and the values are a valid' do
          describe 'but they are out of range' do
            let(:params) { { columns: -1, rows: 256 } }

            it 'fails to initialize' do
              expect { subject }.must_raise BitmapEditor::Errors::ArgumentError
            end
          end

          describe 'when they are in range' do
            let(:params) { { columns: 5, rows: 6 } }

            it 'initialises' do
              subject.must_be_instance_of BitmapEditor::Bitmap
            end
          end
        end
      end
    end
  end
end
