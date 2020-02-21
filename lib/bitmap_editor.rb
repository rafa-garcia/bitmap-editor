# frozen_string_literal: true

require_relative 'bitmap_editor/bitmap'
require_relative 'bitmap_editor/interpreter'

# BitmapEditor takes an input that responds to #each_line and brokers its
# contents on the fly between a command entry and an image object.
class BitmapEditor
  MissingBitmap = Class.new(StandardError)

  def run(entries)
    entries.each_line do |entry|
      next if entry.strip.empty?

      @method, @params = Interpreter.process(entry.strip)
      raise MissingBitmap, 'there is no image' if no_bitmap_yet?

      execute!
    end
  end

  def bitmap
    @bitmap || Bitmap
  end

  private

  def execute!
    # HACK: workaround due to a Ruby pre-v2.7 bug where an empty hash won't
    # unpack by doube-splatting (https://bugs.ruby-lang.org/issues/10708).
    @bitmap =
      if @params.empty?
        bitmap.public_send(@method)
      else
        bitmap.public_send(@method, **@params)
      end
  end

  def no_bitmap_yet?
    bitmap == Bitmap && @method != :new
  end
end
