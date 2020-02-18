# frozen_string_literal: true

require_relative 'interpreter'

class BitmapEditor
  # Command delegates the task of processing a command entry (raw string input)
  # to an utility class and gives structure to the returned data.
  class Command
    attr_reader :operation, :params

    def initialize(input)
      @operation, @params = Interpreter.process(input)
    end
  end
end
