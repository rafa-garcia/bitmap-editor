# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('.', 'lib'))

require 'minitest/autorun'

Dir['./**/*_test.rb'].sort.each { |file| require file }
