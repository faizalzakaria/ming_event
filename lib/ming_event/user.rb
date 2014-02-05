
module MingEvent
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
end
