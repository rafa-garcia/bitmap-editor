# frozen_string_literal: true

require 'scanf'

class BitmapEditor
  class Interpreter
    # Parser scans an input string and yields tokenised data.
    class Parser
      def self.scan(input)
        # https://ruby-doc.org/stdlib-2.3.0/libdoc/scanf/rdoc/String.html#scanf
        cmd_code, *args_ary = input.block_scanf('%s') do |char,|
          # Detects types (digit/string) on the fly
          char.match(/\d/) ? char.to_i : char.upcase
        end

        yield cmd_code.to_sym, args_ary
      end
    end
  end
end
