# frozen_string_literal: true

require 'ostruct'

class BitmapEditor
  # Bitmap represents an image whose matrix of 'pixels' can be manipulated.
  class Bitmap
    CONTEXT = {
      defaults: {
        blank_pixel: 'O',
        size_range: 1..250
      }
    }.freeze
    private_constant :CONTEXT

    def initialize(columns:, rows:)
      @settings = OpenStruct.new(CONTEXT[:defaults])
      validate!(settings.size_range, [columns], [rows])

      @image = [[settings.blank_pixel] * Integer(columns)] * Integer(rows)
    end

    # Handles the 'colour' of the bitmap whether a pixel, a line or all of it.
    def paint(range_h:, range_v:, colour: settings.blank_pixel)
      validate!(settings.size_range, range_h, range_v)

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

    attr_reader :settings, :image

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
      # HACK: an easy-ish way to determine if an array includes another array.
      # Better calling #cover? with Ruby v2.6.1 or newer as it supports ranges.
      return if ((columns + rows) & size.to_a).any?

      message = "The values are out of range (scope #{size.begin}-#{size.end})"
      raise Errors::ArgumentError, message
    end
  end
end
