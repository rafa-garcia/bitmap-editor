# frozen_string_literal: true

# BitmapEditor
module BitmapEditor
  InvalidInputError = Class.new(StandardError)

  def self.run(command_entries)
    raise InvalidInputError unless command_entries.respond_to?(:each_line)

    command_entries.each_line do |entry|
      entry = entry.chomp
      case entry
      when 'S'
        puts 'There is no image'
      else
        puts 'Unrecognised command :('
      end
    end
  end
end
