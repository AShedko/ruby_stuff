# French natural numbers (including 0)
class FrNat
  DEF_MAX = 20

  def initialize(max = DEF_MAX)
    @num = 0
    @max = max
    empty
  end

  def add(val)
    raise 'Max value error' if val > @max
    @num |= 1 << val
  end

  def remove(val)
    @num &= ~(1 << val)
  end

  def find(val)
    @num & (1 << val) == 1 << val
  end

  def empty; @num = 0; end

  def empty?; @num == 0; end
end
