# frozen_string_literal: true

class BitmapEditor
  class Interpreter
    # Mapper handles the mapping of each command entry (command + arguments)
    # and transforms to its corresponding operation and parameters.
    class Mapper
      CONTEXT = {
        supported_commands: {
          I: { method: :new,   params: { columns: 0, rows: 1 } },
          L: { method: :paint, params: { vector: 2, range: 0..1, colour: 3 } },
          H: { method: :paint, params: { vector: 2, range: 0..1, colour: 3 } },
          V: { method: :paint, params: { vector: 0, range: 1..2, colour: 3 } },
          C: { method: :paint,
              # HACK: n..nil is neater for endless ranges if using Ruby v2.6.1+
              options: { range_h: 0..Float::INFINITY, range_v: 0..Float::INFINITY } },
          S: { method: :show }
        }
      }.freeze
      private_constant :CONTEXT

      attr_reader :operation, :parameters

      def initialize(command:, arguments:)
        command_code = commands.fetch(command) { raise CommandError, command }
        @operation   = command_code[:operation]
        @parameters  = normalise(arguments)
      end

      def self.resolve(args)
        'pepe'
      end

      private

      def normalise(arguments)
        Hash[command_code[:pattern].to_a.zip(arguments)]
      end

      def commands
        CONTEXT[:supported_commands]
      end
    end
  end
end
