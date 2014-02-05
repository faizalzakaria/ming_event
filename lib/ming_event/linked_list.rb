
module MingEvent

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

      def empty?
        return @size == 0
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
end
