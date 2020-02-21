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

    describe 'when called with an invalid number of arguments' do
      it 'raises an exception' do
        expect { subject.resolve }.must_raise ArgumentError
      end
    end

    describe 'when called with a valid number of arguments' do
      describe 'but they are invalid' do
        describe 'when the command is not supported' do
          let(:command) { :X }
          let(:args) { [1, 3] }

          it 'raises an exception' do
            expect { subject.resolve(command, args) }.must_raise
            BitmapEditor::Interpreter::Mapper::InvalidCommand
          end
        end

        describe 'when the number of params is wrong' do
          describe 'when they are too few' do
            let(:command) { :I }
            let(:args) { [1] }

            it 'raises an exception' do
              expect { subject.resolve(command, args) }.must_raise ArgumentError
            end
          end

          describe 'whey they are too many' do
            let(:command) { :I }
            let(:args) { [1, 2, 3] }

            it 'raises an exception' do
              expect { subject.resolve(command, args) }.must_raise ArgumentError
            end
          end
        end
      end
      describe 'and they are valid' do
        describe 'when command is I' do
          let(:command) { :I }
          let(:args)    { [5, 6] }
          let(:expected) { [:new, { columns: 5, rows: 6 }] }

          it 'resolves the mappings' do
            _(subject.resolve(command, args)).must_equal expected
          end
        end

        describe 'when command is L' do
          let(:command) { :L }
          let(:args)    { [1, 3, 'A'] }
          let(:expected) do
            [:paint, { col_group: [1], row_group: [3], colour: 'A' }]
          end

          it 'resolves the mappings' do
            _(subject.resolve(command, args)).must_equal expected
          end
        end

        describe 'when command is V' do
          let(:command) { :V }
          let(:args)    { [2, 3, 6, 'W'] }
          let(:expected) do
            [:paint, { col_group: [2], row_group: [3, 6], colour: 'W' }]
          end

          it 'resolves the mappings' do
            _(subject.resolve(command, args)).must_equal expected
          end
        end

        describe 'when command is H' do
          let(:command) { :H }
          let(:args)    { [2, 3, 6, 'Z'] }
          let(:expected) do
            [:paint, { col_group: [2, 3], row_group: [6], colour: 'Z' }]
          end

          it 'resolves the mappings' do
            _(subject.resolve(command, args)).must_equal expected
          end
        end

        describe 'when command is S' do
          let(:command) { :S }
          let(:args) { [] }
          let(:expected) { [:show, {}] }

          it 'resolves the mappings' do
            _(subject.resolve(command, args)).must_equal expected
          end
        end
      end
    end
  end
end
