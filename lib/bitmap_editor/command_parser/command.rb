# frozen_string_literal: true

module BitmapEditor
  module CommandParser
    # Command handles the mapping of each command entry (command + arguments)
    # against its corresponding operation and parameters.
    class Command
      CONTEXT = {
        supported_commands: {
          I: { operation: :new,   keys: { columns: 0, rows: 1 } },
          L: { operation: :paint, keys: { vector: 2, range: 0..1, colour: 3 } },
          H: { operation: :paint, keys: { vector: 2, range: 0..1, colour: 3 } },
          V: { operation: :paint, keys: { vector: 0, range: 1..2, colour: 3 },
               options: { transpose: true } },
          C: { operation: :paint,
               options: { range_h: 0..nil, range_v: 0..nil } },
          S: { operation: :show }
        }
      }.freeze
      private_constant :CONTEXT

      attr_reader :operation, :parameters

      def initialize(command:, arguments:)

      end

      private

      def commands
        CONTEXT[:supported_commands]
      end
    end
  end
end
