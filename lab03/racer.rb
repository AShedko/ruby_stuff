
class Racer
  attr_reader :pos
  START, FINISH = 0, 70

  def initialize
    @pos = START
  end

  def step
    @pos = START if @pos < START
    @pos = FINISH if @pos > FINISH
  end

  def finish?
    @pos >= FINISH
  end

  def win
    "Победил"
  end
end

class Turtle < Racer
  def to_s; "T" end

  def step
    @pos += case rand(10)
      when 0..4
        3
      when 5..6
        -6
      when 7..9
        1
      end
    super
  end

  def win
    super + "а черепаха!!!"
  end

end

class Turtle < Racer
  def to_s; "T" end

  def step
    @pos += case rand(10)
      when 0..4
        3
      when 5..6
        -6
      when 7..9
        1
      end
    super
  end

  def win
    super + "а черепаха!!!"
  end

end

class MyRacer < Racer
    def to_s; "\\" end

    def step
      @pos += case rand(10)
        when 0..1
          0
        when 2..4
          20
        when 5
          -1
        when 5..8
          -20
        when 9
          1
        end
      super
    end

    def win
      super + " слеш"
    end
end

class Dog < Racer
  def to_s; "D" end

  def step
    @pos +=1
  end

  def win
    super + "а хромая  собака"
  end
end

class Rabbit < Racer
  def to_s; "R" end

  def step
    @pos += case rand(10)
      when 0..1
        0
      when 2..3
        9
      when 4
        -12
      when 5..7
        1
      when 8..9
        -2
      end
    super
  end

  def win
    super + " кролик :("
  end
end

class Race
   TSLEEP=0.2

  def initialize(*racers)
    @racers = racers
    @track = '.'*Racer::FINISH + '|'
  end

  def run
    begin
      while true
        @racers.each do |racer|
          racer.step
          @track[racer.pos,1] = racer.to_s
        end
        

        draw
        @racers.each do |racer|
          raise racer.win if racer.finish?
          @track[racer.pos,1] = '.'
        end
        sleep TSLEEP
      end
    rescue
      puts $!
    end
  end
  private
  def draw
    system('clear')
    puts @track
  end
end

r = Race.new Rabbit.new,Turtle.new,Dog.new,MyRacer.new
r.run
