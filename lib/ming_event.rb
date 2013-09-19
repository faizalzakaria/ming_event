require "ming_event/version"

module MingEvent

  class Timer

	def initialize(second, &block)
	  @thread = Thread.new do
		sleep(second)
		block.call
	  end
	end

	def wait
	  @thread.join
	end

	def cancel
	  @thread.kill
	end

  end

  class Event

	def initialize
	  @observers = []
	end

	# Register all the observers def register(observers, interval)
	@observers.concat observers Timer.new(interval,
	&method(:fire_observers)) end

	def fire_observers
	  puts "Done ..."
	end
  end
end
