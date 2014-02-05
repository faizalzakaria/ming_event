
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
        "M"
      end

      def female
        "F"
      end
    end
  end # End class Gender

end
