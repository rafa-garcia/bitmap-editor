# frozen_string_literal: true

require 'minitest/autorun'

base_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
lib_dir = File.join(base_dir, 'lib')

$LOAD_PATH.unshift(base_dir, lib_dir)

Dir['**/*_test.rb'].each { |file| require file }
