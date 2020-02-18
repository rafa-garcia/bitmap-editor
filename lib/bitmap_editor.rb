# frozen_string_literal: true

require_relative 'bitmap_editor/bitmap'
require_relative 'bitmap_editor/command'
require_relative 'bitmap_editor/errors'

# BitmapEditor takes an input that responds to #each_line and brokers its
# contents on the fly between a command object and an image object.
class BitmapEditor
  def run(entries)
    entries.each_line do |entry|
      command = Command.new(entry)
      # HACK: workaround due to a Ruby pre-v2.7 bug where an empty hash won't
      # unpack by doube-splatting (https://bugs.ruby-lang.org/issues/10708).
      @bitmap =
        if command.params.empty?
          handle_err { bitmap.public_send(command.operation) }
        else
          handle_err { bitmap.public_send(command.operation, **command.params) }
        end
    end
  end

  def bitmap
    @bitmap || Bitmap
  end

  private

  def handle_err
    yield
  rescue NoMethodError
    raise Errors::MissingBitmap
  end
end
