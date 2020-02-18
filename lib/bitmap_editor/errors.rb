# frozen_string_literal: true

class BitmapEditor
  # Errors
  module Errors
    BitmapEditorError = Class.new(StandardError)

    MissingBitmap = Class.new(BitmapEditorError) do
      def initialize
        super('there is no image')
      end
    end

    InvalidCommand = Class.new(BitmapEditorError) do
      def initialize
        super('unrecognised command :(')
      end
    end
  end
end
