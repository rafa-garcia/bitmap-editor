# frozen_string_literal: true

require_relative 'interpreter/mapper'
require_relative 'interpreter/parser'

class BitmapEditor
  # Interpreter orchestrates input data processing.
  class Interpreter
    def self.process(input)
      # Cleans the input and yields normalised data.
      Parser.scan(input) do |cmd, args|
        # Looks up command in table and maps against option params.
        Mapper.resolve(cmd, args)
      end
    end
  end
end
