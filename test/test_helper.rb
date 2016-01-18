require 'minitest/autorun'
require 'minitest/reporters' # requires gem
require 'shoulda/context' # requires gem

Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new
