pattern = File.join(File.dirname(__FILE__), 'models', '**', '*.rb')
Dir[pattern].each { |filepath| require_relative filepath }

require_relative 'receipt_printer'
