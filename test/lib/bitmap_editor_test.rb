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
        let(:command_klass) { Minitest::Mock.new }
        let(:command_inst)  { Minitest::Mock.new }

        describe 'but there is no bitmap' do
          # describe 'and the method does not create one' do
          #   let(:entries) { "S\n" }

          #   it 'raises an exception' do
          #     command_klass.expect :call, command_inst,
          #                          [entries.each_line.first]
          #     command_inst.expect :params, [{}]
          #     command_inst.expect :operation, :show

          #     BitmapEditor::Command.stub :process, command_klass do
          #       expect { subject }.must_raise
          #       BitmapEditor::Errors::MissingBitmap
          #     end
          #     assert_mock command_klass
          #     assert_mock command_inst
          #   end
          # end

          describe 'and the method creates a new one' do
            let(:entries)      { "I 3 3\n" }
            let(:bitmap_klass) { Minitest::Mock.new }
            let(:bitmap_inst) { Minitest::Mock.new }

            it 'calls ::new on the Bitmap class' do
              command_klass.expect :call, command_inst,
                                   [entries.each_line.first]
              command_inst.expect :params, { columns: 3, rows: 3 }
              command_inst.expect :params, { columns: 3, rows: 3 }
              command_inst.expect :operation, :new
              bitmap_klass.expect :call, bitmap_inst,
                                  [:new, { columns: 3, rows: 3 }]

              BitmapEditor::Command.stub :new, command_klass do
                BitmapEditor::Bitmap.stub :public_send, bitmap_klass do
                  subject
                end
              end
              assert_mock bitmap_klass
              assert_mock command_klass
              assert_mock command_inst
            end
          end
        end
      end
    end
  end
end
