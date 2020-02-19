# frozen_string_literal: true

require 'ostruct'

class BitmapEditor
  # Bitmap represents an image whose matrix of 'pixels' can be manipulated.
  class Bitmap
    BLANK_PIXEL = 'O'
    SIZE_RANGE  = (1..250).freeze

    def initialize(columns:, rows:)
      validate!(SIZE_RANGE, [columns], [rows])

      @image = [[BLANK_PIXEL] * Integer(columns)] * Integer(rows)
    end

    # Handles the 'colour' of the bitmap whether a pixel, a line or all of it.
    def paint(range_h:, range_v:, colour:)
      validate!(SIZE_RANGE, range_h, range_v)
      normalise_ranges(range_h, range_v) do |rows, cols|
        switch(!range_v.one? && !range_h.one?) do |img|
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
      range_h, range_v = ranges.map do |range|
        Range.new(*[range.first.pred, range.last.pred])
      end

      yield range_h, range_v
    end

    def validate!(ref, columns, rows)
      # HACK: an easy-ish way to determine if an array includes another array.
      # Better calling #cover? with Ruby v2.6.1 or newer as it supports ranges.
      return if ((columns + rows) & ref.to_a).any?

      raise ArgumentError, "values out of range (scope #{ref.begin}-#{ref.end})"
    end
  end
end
