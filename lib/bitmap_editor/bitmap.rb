# frozen_string_literal: true

require 'ostruct'

class BitmapEditor
  # Bitmap represents an image whose matrix of 'pixels' can be manipulated.
  class Bitmap
    BLANK_PIXEL = 'O'
    COL_LIMIT   = ROW_LIMIT = (1..250).freeze

    def initialize(columns:, rows:)
      validate_inclusion!([columns], [rows], COL_LIMIT, ROW_LIMIT)

      @col_range = 1..columns
      @row_range = 1..rows
      @image     = [[BLANK_PIXEL] * Integer(columns)] * Integer(rows)
    end

    # Handles the 'colour' of the bitmap whether a pixel, a line or all of it.
    def paint(col_group:, row_group:, colour:)
      validate_colour!(colour)
      validate_inclusion!(col_group, row_group, col_range, row_range)

      normalise_groups(col_group, row_group) do |cols, rows|
        switch do |img|
          img[cols].each { |vector| vector.fill(colour, rows) }
        end
      end
      self
    end

    def clear
      paint(col_group: col_range, row_group: row_range, colour: BLANK_PIXEL)
      self
    end

    def show
      puts image.map(&:join)
      self
    end

    private

    attr_reader :image, :col_range, :row_range

    # Yields the transposed image for easier manipulation.
    def switch
      @image = image.transpose
      yield image
      @image = image.transpose
      image
    end

    # Yields ranges with their indices reset to zero-based.
    def normalise_groups(*groups)
      col_group, row_group = groups.map do |group|
        Range.new(group.first.pred, group.last.pred)
      end

      yield col_group, row_group
    end

    def validate_colour!(colour)
      msg = 'colour must be a capital letter'
      raise ArgumentError, msg unless colour&.match(/^[A-Z]{1}$/)
    end

    def validate_inclusion!(col_group, row_group, col_range, row_range)
      included = col_group.all? { |point| col_range.cover? point } &&
                 row_group.all? { |point| row_range.cover? point }

      raise ArgumentError, 'values out of range' unless included
    end
  end
end
