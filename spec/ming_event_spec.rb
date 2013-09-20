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

  it "Should add user " do
    user = MingEvent::User.new(1, MingEvent::Gender.male)
    user.user_id.should be 1
  end

  it "Should not add user " do
    user = MingEvent::User.new(1, "tata")
    #user.should be nil
  end

end
