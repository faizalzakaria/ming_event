require 'spec_helper'

describe MingEvent do

  it "Timer 5 seconds " do

	fired = false
	t = MingEvent::Timer.new(1) do
	  fired = true
	end

	t.wait
	fired.should be_true
  end

  it "Event should fire observers " do
	event = MingEvent::Event.new
	event.register(['a', 'b'], 1)
	sleep 2
  end

end
