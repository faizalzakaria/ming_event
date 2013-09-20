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
  end

  class User

	# Connection, conencted to ith when its true
	attr_reader :gender, :user_id, :connection

	def initialize(user_id, gender)
	  @user_id = user_id
	  @connection = Hash.new
	  # Todo check gender class
	  @gender = gender
	end

	def is_same_gender?(to_user)
	  return @gender == to_user.gender
	end

	def is_connected?(to_user)
	  return true if is_same_gender?(to_user)
	  return @connection[:connected] || false
	end

	def connect_to(user)
	  @connection[:connected] = true
	end

  end

  class Event

	def initialize
	end

	# Register all the observers def register(observers, interval)
	def register(female_users, male_users)
	  if !female_users.nil?
		female_users.each do |user_id|
		  register_user user_id Gender.female
		end
	  end

	  if !male_users.nil?
		male_users.each do |user_id|
		  register_user user_id Gender.male
		end
	  end
	end

	def register_user(user_id, gender)
	  @male_users << User.new(user_id, gender)
	end

	# TODO
	def start
	  Timer.new(interval, &method(:fire_observers))
	end

	# TODO
	def get_next_pair(user)

	end

	def fire_observers
	  puts "Done ..."
	end
  end
end
