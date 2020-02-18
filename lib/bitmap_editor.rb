# frozen_string_literal: true

require_relative 'bitmap_editor/bitmap'
require_relative 'bitmap_editor/command_parser'
require_relative 'bitmap_editor/errors'

# BitmapEditor takes an argument that responds to #each_line and brokers on the
# fly its content between a command-parser object and a command-receiver object.
class BitmapEditor
  def self.run(entries)
    entries.each_line do |entry|
      CommandParser.parse(entry) do |operation, params|
        # HACK: workaround due to a Ruby pre-v2.7 bug where an empty hash won't
        # unpack into nil by the doube splat operator when sent dinamically as
        # optional keyword arguments (https://bugs.ruby-lang.org/issues/10708).
        @bitmap =
          if params.empty?
            bitmap.public_send(operation)
          else
            bitmap.public_send(operation, **params)
          end
      end
    end
  end

  def initialize
    @bitmap = nil
  end

  def bitmap
    @bitmap || Bitmap
  rescue NoMethodError
    raise Errors::MissingBitmap
  end
end
