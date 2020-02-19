# frozen_string_literal: true

require 'yaml'

class BitmapEditor
  class Interpreter
    # Mapper associates each command entry (command + arguments) with a defined
    # set of commands and command options. The values of the params and options
    # defined in the map must match the 0-based indices of the input arguments.
    class Mapper
      InvalidCommand = Class.new(StandardError) do
        def initialize(command)
          super("unrecognised command: <#{command}>")
        end
      end

      CMD_MAP = YAML.load_file('config/mappings.yml').freeze

      def self.resolve(command, arguments)
        config = CMD_MAP.fetch(command) { raise InvalidCommand, command }.values
        params = config.pop
        validate!(arguments, params) unless arguments.empty?
        # Iterates through the params config hash to map its values on the spot.
        params.each { |name, value| params[name] = arguments[value] }
        config.push params
      end

      private

      def self.validate!(args, params)
        allowed = params.values.flat_map { |v| Array[*v] }.size
        msg = "wrong number of arguments (given #{args.size}, need #{allowed})"
        raise ArgumentError, msg unless args.size == allowed
      end
      private_class_method :validate!
    end
  end
end
