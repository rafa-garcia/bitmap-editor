# frozen_string_literal: true

require 'scanf'

class BitmapEditor
  module CommandUtils
    # CommandUtils::Parser scans a raw command entry and yields normalised data.
    class Parser
      def self.process(raw_entry)
        cmd_code, *args_ary = raw_entry.block_scanf('%s') do |char,|
          char.match(/\d/) ? char.to_i : char.upcase
        end

        yield cmd_code.to_sym, args_ary
      end
    end
  end
end
