# frozen_string_literal: true

require './lib/bitmap_editor/bitmap'

describe BitmapEditor::Bitmap do
  subject { BitmapEditor::Bitmap.new(bitmap_params) }

  let(:image) { subject.instance_variable_get(:@image) }

  describe '::new' do
    describe 'when called with no parameters' do
      let(:bitmap_params) { {} }

      it 'fails to initialize' do
        expect { subject }.must_raise ArgumentError
      end
    end

    describe 'when called with parameters' do
      describe 'and the keys are invalid' do
        let(:bitmap_params) { { wrong: 'parameter' } }

        it 'fails to initialize' do
          expect { subject }.must_raise ArgumentError
        end
      end

      describe 'and the keys are valid' do
        describe 'but the values are invalid' do
          describe 'when they can not be coerced' do
            let(:bitmap_params) { { columns: 'wrong', rows: 'value' } }

            it 'fails to initialize' do
              expect { subject }.must_raise BitmapEditor::Errors::ArgumentError
            end
          end

          describe 'and even when they can be coerced' do
            let(:bitmap_params) { { columns: '1', rows: '2' } }

            it 'fails to initialize' do
              expect { subject }.must_raise BitmapEditor::Errors::ArgumentError
            end
          end
        end

        describe 'and the values are valid' do
          describe 'but they are out of range' do
            let(:bitmap_params) { { columns: -1, rows: 256 } }

            it 'fails to initialize' do
              expect { subject }.must_raise BitmapEditor::Errors::ArgumentError
            end
          end

          describe 'when they are in range' do
            let(:bitmap_params) { { columns: 5, rows: 6 } }

            it 'initialises' do
              _(subject).must_be_instance_of BitmapEditor::Bitmap
            end

            it 'has an image of the correct size' do
              _(image.length).must_equal 6
              _(image.flatten.length).must_equal 30
            end
          end
        end
      end
    end
  end

  describe '#paint' do
    let(:bitmap_params) { { columns: 3, rows: 5 } }

    describe 'when it is called with no arguments' do
      it 'fails to initialize' do
        expect { subject.paint }.must_raise ArgumentError
      end
    end

    describe 'when it is called with arguments' do
      describe 'and they are invalid' do
        describe 'with wrong horizontal range' do
          let(:paint_params) { { range_h: 'wrong', range_v: [1, 2] } }

          it 'raises an exception' do
            expect { subject.paint }.must_raise ArgumentError
          end
        end

        describe 'with wrong vertical range' do
          let(:paint_params) { { range_h: [1, 2], range_v: 'wrong' } }

          it 'raises an exception' do
            expect { subject.paint }.must_raise ArgumentError
          end
        end

        describe 'with wrong colour character' do
          let(:paint_params) do
            { range_h: [1, 2], range_v: [1, 2], colour: [''] }
          end

          it 'raises an exception' do
            expect { subject.paint }.must_raise ArgumentError
          end
        end
      end

      describe 'and they are valid' do
        before { subject.paint(paint_params) }

        describe 'when it is a pixel' do
          let(:paint_params) do
            { range_h: [2, 2], range_v: [3, 3], colour: 'X' }
          end
          let(:expected) do
            [
              %w[O O O],
              %w[O O O],
              %w[O X O],
              %w[O O O],
              %w[O O O]
            ]
          end

          it 'paints it' do
            _(image).must_equal expected
          end
        end

        describe 'when it is a line' do
          describe 'and it is horizontal' do
            let(:paint_params) do
              { range_h: [1, 3], range_v: [3, 3], colour: 'X' }
            end
            let(:expected) do
              [
                %w[O O O],
                %w[O O O],
                %w[X X X],
                %w[O O O],
                %w[O O O]
              ]
            end

            it 'paints it' do
              _(image).must_equal expected
            end
          end

          describe 'and it is vertical' do
            let(:paint_params) do
              { range_h: [2, 2], range_v: [1, 5], colour: 'X' }
            end
            let(:expected) do
              [
                %w[O X O],
                %w[O X O],
                %w[O X O],
                %w[O X O],
                %w[O X O]
              ]
            end

            it 'paints it' do
              _(image).must_equal expected
            end
          end
        end

        describe 'when it is the whole image' do
          let(:paint_params) do
            { range_h: [1, 3], range_v: [1, 5], colour: 'O' }
          end
          let(:expected) do
            [
              %w[O O O],
              %w[O O O],
              %w[O O O],
              %w[O O O],
              %w[O O O]
            ]
          end

          it 'paints it clear' do
            _(image).must_equal expected
          end
        end
      end
    end
  end

  describe '#show' do
    let(:bitmap_params) { { columns: 3, rows: 5 } }
    let(:paint_params) do
      { range_h: [1, 3], range_v: [1, 5], colour: 'X' }
    end
    let(:expected) do
      <<~OUTPUT
        XXX
        XXX
        XXX
        XXX
        XXX
      OUTPUT
    end

    it 'prints out the image' do
      subject.paint(paint_params)
      expect { subject.show }.must_output expected
    end
  end
end
