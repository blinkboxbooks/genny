require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
$LOAD_PATH.unshift File.join(__dir__, "../lib")
require "genny"