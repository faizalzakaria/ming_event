require "ming_event/version"

# Register all users, group1 group2

# AI to get next

# Settings 5 minutes, then 30 seconds then 5 minutes

# Every 5 minutes fire =>
# data : { command: connect (arg: partner_id), disconnect }

# 5 minutes connect(partner_id)
# disconnect

# 2 groups, bidirectional

module MingEvent

  # Timer class
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

  class Gender
    class << self
      def male
        "MALE"
      end

      def female
        "FEMALE"
      end
    end
  end # End class Gender

  class User
    # Connections, conencted to ith when its true
    attr_reader :gender, :user_id
    attr_accessor :next_partner

    def initialize(user_id, gender)
      @user_id = user_id
      @connections = Hash.new
      # Todo check gender class
      @gender = gender
      @next_partner = nil
    end

    def is_same_gender?(to_user)
      return @gender == to_user.gender
    end
  end # End class User

  module LinkedList
    class Node
      attr_accessor :next, :obj

      def initialize(obj)
        @next = nil
        @obj = obj
      end
    end

    class List
      attr_reader :head, :size

      def initialize
        @head = nil
        @size = 0
      end

      def add(obj)
        new_node = Node.new(obj)
        if @head.nil?
          @head = new_node
        else
          temp_node = @head
          while !temp_node.next.nil?
            temp_node = temp_node.next
          end
          temp_node.next = new_node
        end
        @size += 1
      end

      def remove(node)
        if node.eql? @head
          @head = node.next
        else
          temp_node = @head
          prev = nil
          while !temp_node.nil?
            if temp_node.eql?(node)
              prev.next = node.next
              break
            end
            prev = temp_node
            temp_node = temp_node.next
          end
        end
        node.next = nil
        @size -= 1
        GC.start
      end
    end
  end

  class Event
    attr_reader :male_list, :female_list
    attr_accessor :delay_chat, :delay_idle

    def initialize(delay_chat = 300, delay_idle = 30)
      @delay_chat = delay_chat
      @delay_idle = delay_idle
      @male_list = LinkedList::List.new
      @female_list = LinkedList::List.new
      @prepared = false
    end

    # Register all the observers def register(observers, interval)
    # TODO : rename
    def register_users(female_users, male_users)
      fail if @prepared

      if !female_users.nil?
        female_users.each do |user_id|
          register_user user_id, Gender.female
        end
      end

      if !male_users.nil?
        male_users.each do |user_id|
          register_user user_id, Gender.male
        end
      end
    end

    def register_user(user_id, gender)
      fail if @prepared

      if gender == Gender.male
        @male_list.add User.new(user_id, gender)
      elsif gender == Gender.female
        @female_list.add User.new(user_id, gender)
      else
        false
      end
    end

    def prepare
      while @male_list.size < @female_list.size do
        @male_list.add User.new(-1, Gender.male)
      end

      while @female_list.size < @male_list.size do
        @female_list.add User.new(-1, Gender.female)
      end

      male = @male_list.head
      female = @female_list.head
      while !male.nil?
        male.obj.next_partner = female
        female.obj.next_partner = male
        male = male.next
        female = female.next
      end
      @prepared = true
    end

    def start(procs)
      fail if !@prepared

      @thread = Timer.new(@delay_idle, &procs[:connect_cb])
      @thread.wait

      (2..@male_list.size).each do
        @thread = Timer.new(@delay_chat, &procs[:idle_cb])
        @thread.wait
        @thread = Timer.new(@delay_idle, &procs[:connect_cb])
        @thread.wait
      end

      @thread = Timer.new(@delay_idle, &procs[:idle_cb])
      @thread.wait
    end

    def stop
      fail if !@prepared
      @thread.kill
    end

    def next_partners
      fail if !@prepared
      male = @male_list.head
      while !male.nil?
        next_partner male
        male = male.next
      end
    end

    def next_partner(male)
      if (male.obj.gender == Gender.female)
        # Do nothing, only move male
        p "Should only handle Male"
      elsif (male.obj.gender == Gender.male)
        next_female = male.obj.next_partner.next || @female_list.head
        male.obj.next_partner = next_female
        next_female.obj.next_partner = male
      else
        p "Raise error!"
      end
    end

    def command_to_connect
      puts "Command to connect"
    end

    def command_to_idle
      puts "Command to idle"
    end
  end # End class Event
end
