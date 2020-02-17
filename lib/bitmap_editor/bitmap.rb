# frozen_string_literal: true

module BitmapEditor
  # Bitmap represents the image and takes commands in the form of operations
  # and parameters to change and display its matrix of 'pixels'.
  class Bitmap
    SIZE        = (1..250).freeze
    BLANK_PIXEL = 'O'

    def initialize(columns:, rows:)
      validate!(SIZE, [columns], [rows])

      @image = [[BLANK_PIXEL] * Integer(columns)] * Integer(rows)
    end

    # Handles the 'colour' of the bitmap whether a pixel, a line or all.
    def paint(range_h:, range_v:, colour: BLANK_PIXEL)
      validate!(SIZE, range_h, range_v)

      normalise_ranges(range_h, range_v) do |rows, cols|
        switch(range_h.one?) do |img|
          img[rows].each { |vector| vector.fill(colour, cols) }
        end
      end
      self
    end

    def show
      puts image.map(&:join)
      self
    end

    private

    attr_reader :image

    # Yields the transposed image when working on cols for easier manipulation.
    def switch(transpose)
      @image = image.transpose unless transpose
      yield image
      @image = image.transpose unless transpose

      image
    end

    # Yields ranges with their indices reset to zero-based.
    def normalise_ranges(*ranges)
      range_h, range_v = ranges.map { |range| Range.new(*range.map(&:pred)) }

      yield range_h, range_v
    end

    def validate!(size, columns, rows)
      return if ((columns + rows) & size.to_a).any?

      message = "The values are out of range (scope #{size.begin}-#{size.end})"
      raise Errors::ArgumentError, message
    end
  end
end
