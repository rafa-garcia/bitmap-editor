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
              expect { subject }.must_raise ArgumentError
            end
          end

          describe 'and even when they can be coerced' do
            let(:bitmap_params) { { columns: '1', rows: '2' } }

            it 'fails to initialize' do
              expect { subject }.must_raise ArgumentError
            end
          end
        end

        describe 'and the values are valid' do
          describe 'but they are out of range' do
            let(:bitmap_params) { { columns: -1, rows: 256 } }

            it 'fails to initialize' do
              expect { subject }.must_raise ArgumentError
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
    let(:bitmap_params) { { columns: 5, rows: 6 } }

    describe 'when it is called with no arguments' do
      it 'fails to initialize' do
        expect { subject.paint }.must_raise ArgumentError
      end
    end

    describe 'when it is called with arguments' do
      describe 'and they are invalid' do
        describe 'with wrong horizontal range' do
          let(:paint_params) { { col_group: 'wrong', row_group: [1, 2] } }

          it 'raises an exception' do
            expect { subject.paint }.must_raise ArgumentError
          end
        end

        describe 'with wrong vertical range' do
          let(:paint_params) { { col_group: [1, 2], row_group: 'wrong' } }

          it 'raises an exception' do
            expect { subject.paint }.must_raise ArgumentError
          end
        end

        describe 'with wrong colour character' do
          let(:paint_params) do
            { col_group: [1, 2], row_group: [1, 2], colour: 'ZZ' }
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
            { col_group: [1], row_group: [3, 3], colour: 'A' }
          end
          let(:expected) do
            [
              %w[O O O O O],
              %w[O O O O O],
              %w[A O O O O],
              %w[O O O O O],
              %w[O O O O O],
              %w[O O O O O]
            ]
          end

          it 'paints it' do
            _(image).must_equal expected
          end
        end

        describe 'when it is a line' do
          describe 'and it is vertical' do
            let(:paint_params) do
              { col_group: [2], row_group: [3, 6], colour: 'W' }
            end
            let(:expected) do
              [
                %w[O O O O O],
                %w[O O O O O],
                %w[O W O O O],
                %w[O W O O O],
                %w[O W O O O],
                %w[O W O O O]
              ]
            end

            it 'paints it' do
              _(image).must_equal expected
            end
          end

          describe 'and it is horizontal' do
            let(:paint_params) do
              { col_group: [3, 5], row_group: [2], colour: 'Z' }
            end
            let(:expected) do
              [
                %w[O O O O O],
                %w[O O Z Z Z],
                %w[O O O O O],
                %w[O O O O O],
                %w[O O O O O],
                %w[O O O O O]
              ]
            end

            it 'paints it' do
              _(image).must_equal expected
            end
          end
        end

        describe 'when it is the whole image' do
          let(:paint_params) do
            { col_group: [1, 5], row_group: [1, 6], colour: 'O' }
          end
          let(:expected) do
            [
              %w[O O O O O],
              %w[O O O O O],
              %w[O O O O O],
              %w[O O O O O],
              %w[O O O O O],
              %w[O O O O O]
            ]
          end

          it 'paints it clear' do
            _(image).must_equal expected
          end
        end
      end
    end
  end

  describe '#clear' do
    let(:bitmap_params) { { columns: 5, rows: 6 } }
    let(:expected) do
      [
        %w[O O O O O],
        %w[O O O O O],
        %w[O O O O O],
        %w[O O O O O],
        %w[O O O O O],
        %w[O O O O O]
      ]
    end

    it 'clears out the image' do
      subject.clear
      _(image).must_equal expected
    end
  end

  describe '#show' do
    let(:bitmap_params) { { columns: 5, rows: 6 } }
    let(:paint_params) do
      { col_group: [1, 3], row_group: [1, 5], colour: 'X' }
    end
    let(:expected) do
      <<~OUTPUT
        XXXOO
        XXXOO
        XXXOO
        XXXOO
        XXXOO
        OOOOO
      OUTPUT
    end

    it 'prints out the image' do
      subject.paint(paint_params)
      expect { subject.show }.must_output expected
    end
  end
end
