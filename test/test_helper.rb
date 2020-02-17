# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('.', 'lib'))

require 'minitest/autorun'
require 'bitmap_editor/errors'

Dir['./**/*_test.rb'].each { |file| require file }
