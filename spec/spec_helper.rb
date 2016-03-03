require 'simplecov'
require 'simplecov-rcov'

class SimpleCov::Formatter::MergedFormatter
  def format(result)
     SimpleCov::Formatter::HTMLFormatter.new.format(result)
     SimpleCov::Formatter::RcovFormatter.new.format(result)
  end
end
SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter

SimpleCov.minimum_coverage 90
SimpleCov.maximum_coverage_drop 5

SimpleCov.start do
  add_filter '/config/'
  add_filter 'config'
  add_filter '/spec/'

  add_group 'Libraries', 'lib'
  add_group 'Workers', 'workers'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'shoryuken/notifier'
