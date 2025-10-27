module Contexts
  # Base module for all context classes

  module AvailabilitySlots
  end

  module Viewings
  end

  module Properties
  end
end

# Load all context files when this module is loaded
Dir[File.join(File.dirname(__FILE__), '**', '*.rb')].each do |file|
  next if file == __FILE__
  load file
end
