# itsa flippin` deck innit.
class Deck

  DEF_SIZE = 10

  def initialize(size = DEF_SIZE)
    @array = Array.new(size)
    empty
  end

  def empty; @size = @head = 0; @tail = @array.size - 1 end

  def empty?; @size == 0 end

  def push_back(elem)
    raise 'Deck is full' if @size >= @array.size
    @array[@tail] = elem
    @size += 1
    @tail = backward(@tail)
  end

  def push_front(elem)
    raise 'Deck is full' if @size >= @array.size
    @array[@head] = elem
    @size += 1
    @head = forward(@head)
  end

  def pop_back
    raise 'Deck is empty' if @size <= 0
    @size -= 1
    @tail = forward(@tail)
    @array[@tail]
  end

  def pop_front
    raise 'Deck is empty' if @size <= 0
    @size -= 1
    @head = backward(@head)
    @array[@head]
  end

  def front
    raise 'Deck is empty' if @size <= 0
    @array[backward(@head)]
  end

  def back
    raise 'Deck is empty' if @size <= 0
    @array[forward(@tail)]
  end

private
  def forward(index)
    index == @array.size - 1 ? 0 : index + 1
  end

  def backward(index)
    index == 0 ? @array.size - 1 : index - 1
  end
end
