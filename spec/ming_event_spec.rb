require 'spec_helper'

describe MingEvent do

  describe "Testing Timer" do
    it "Timer 5 seconds " do
      fired = false
      t = MingEvent::Timer.new(1) do
        fired = true
      end

      t.wait
      fired.should be_true
    end
  end

  describe "Testing User" do
    it "Should add user " do
      user = MingEvent::User.new(1, MingEvent::Gender.male)
      user.user_id.should be 1
    end

    # TODO, testing the raise error on gender
    it "Should not add user " do
      user = MingEvent::User.new(1, "tata")
      #user.should be nil
    end
  end

  describe "Testing linkedList ..." do
    it "@head should return 'A'" do
      list = MingEvent::LinkedList::List.new
      list.add("A")
      list.head.obj.should eq("A")
    end

    it "@head.next should return 'B'" do
      list = MingEvent::LinkedList::List.new
      list.add("A")
      list.add("B")
      list.head.next.obj.should eq("B")
    end

    it "@head.next should return 'C'" do
      list = MingEvent::LinkedList::List.new
      list.add("A")
      list.add("B")
      list.add("C")
      list.remove(list.head.next)
      list.head.next.obj.should eq("C")
    end

    it "size should return 3" do
      list = MingEvent::LinkedList::List.new
      list.add("A")
      list.add("B")
      list.add("C")
      list.size.should eq(3)
    end
  end

  describe "Testing Event" do
    it "should have 5 males and 5 females" do
      event = MingEvent::Event.new
      female_users = [1,2,3,4,5]
      male_users = [6,7,8,9,10]
      event.register_users(female_users, male_users)
      size_male = 0
      size_female = 0
      t = event.male_list.head
      while !t.nil?
        size_male += 1
        t = t.next
      end
      t = event.female_list.head
      while !t.nil?
        size_female += 1
        t = t.next
      end
      size_male.should eq(5)
      size_female.should eq(5)
    end

    it "should have correct next partner" do
      event = MingEvent::Event.new
      female_users = [1,2,3,4,5]
      male_users = [6,7,8,9,10]
      event.register_users(female_users, male_users)
      event.prepare
      event.male_list.head.obj.next_partner.should eq(event.female_list.head)
    end

    it "should have correct next partner after next_partner has been called" do
      event = MingEvent::Event.new
      female_users = [1,2,3,4,5]
      male_users = [6,7,8,9,10]
      event.register_users(female_users, male_users)
      event.prepare
      event.next_partner(event.male_list.head)
      event.next_partner(event.male_list.head)
      event.male_list.head.obj.next_partner.should eq(event.female_list.head.next.next)
    end

    it "should have correct next partner after next_partners has been called" do
      event = MingEvent::Event.new
      female_users = [1,2,3,4,5]
      male_users = [6,7,8,9,10]
      event.register_users(female_users, male_users)
      event.prepare
      event.next_partners
      event.male_list.head.obj.next_partner.should eq(event.female_list.head.next)
      event.male_list.head.next.obj.next_partner.should eq(event.female_list.head.next.next)
      last = event.male_list.head.next.next.next.next
      last.obj.next_partner.should eq(event.female_list.head)
    end

    it "Should get 5 connect call and 5 idle call" do
      event = MingEvent::Event.new(1, 1)
      female_users = [1,2,3,4,5]
      male_users = [6,7,8,9,10]
      event.register_users(female_users, male_users)
      event.prepare
      connect_call = 0
      idle_call = 0
      t = Thread.new do
        callbacks = {
          :connect_cb => Proc.new{ connect_call += 1 },
          :idle_cb => Proc.new{ idle_call += 1 }
        }
        event.start(callbacks)
      end
      t.join
      connect_call.should eq(5)
      idle_call.should eq(5)
    end

    it "Should get 2 connect and 2 idle .." do
      event = MingEvent::Event.new(1, 1)
      female_users = [1]
      male_users = [6,7]
      event.register_users(female_users, male_users)
      event.prepare
      connect_call = 0
      idle_call = 0
      t = Thread.new do
        callbacks = {
          :connect_cb => Proc.new{ connect_call += 1 },
          :idle_cb => Proc.new{ idle_call += 1 }
        }
        event.start(callbacks)
      end
      t.join
      connect_call.should eq(2)
      idle_call.should eq(2)
    end

  end
end
