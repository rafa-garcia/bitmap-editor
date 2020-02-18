# frozen_string_literal: true

require 'scanf'
require_relative 'command_parser/command'

class BitmapEditor
  module CommandParser # :nodoc:
    def self.parse(command_entry)
      normalise(command_entry) do |command_code, arguments|
        command = Command.new(command: command_code, arguments: arguments)

        yield command.operation, command.parameters
      end
    end

    def self.normalise(entry)
      command, *arguments = entry.block_scanf('%s') do |char,| # ',' unpacks ary
        char.match(/\d/) ? char.to_i : char.upcase
      end

      yield command.to_sym, arguments
    end
    private_class_method :normalise
  end
end
