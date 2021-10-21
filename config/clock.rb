require 'clockwork'

require File.expand_path('../boot', __FILE__)
require File.expand_path('../environment', __FILE__)

module Clockwork
  handler do |job|
    Product.np_check
  end

  every(1.day, 'midnight.job', :at => '17:10')
end

#every(10.seconds, 'frequent.job')
#every(3.minutes, 'less.frequent.job')
#every(1.hour, 'hourly.job')
#every(1.day, 'midnight.job', :at => '00:00')