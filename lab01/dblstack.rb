# Два стека, ограниченные в совокупности
class DblStack
  DEF_SIZE = 7

  def initialize(size = DEF_SIZE)
    @array = Array.new(size)
    empty
  end

  def empty(stack = nil)
    case stack
    when nil
      @head0 = @head1 = 0
    when 0
      @head0 = 0
    when 1
      @head1 = 0
    else
      raise 'Wrong stack'
    end
  end

  def empty?(stack = nil)
    case stack
    when nil
      @head0 == 0 and @head1 == 0
    when 0
      @head0 == 0
    when 1
      @head1 == 0
    else
      raise 'Wrong stack'
    end
  end

  def push(stack, val)
    raise 'Stacks are full' if @head0 + @head1 >= @array.size
    case stack
    when 0
      @array[@head0] = val; @head0 += 1
    when 1
      @array[@array.size - @head1 - 1] = val; @head1 += 1
    else
      raise 'Wrong stack'
    end
  end

  def pop(stack)
    case stack
    when 0
      raise 'Stack is empty' if @head0 <= 0
      @head0 -= 1; @array[@head0]
    when 1
      raise 'Stack is empty' if @head1 <= 0
      @head1 -= 1; @array[@array.size - @head1 - 1]
    else
      raise 'Wrong stack'
    end
  end

  def top(stack)
    case stack
    when 0
      raise 'Stack is empty' if @head0 <= 0
      @array[@head0 - 1]
    when 1
      raise 'Stack is empty' if @head1 <= 0
      @array[@array.size - @head1]
    else
      raise 'Wrong stack'
    end
  end
end
