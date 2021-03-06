class SpiralMap
  RIGHT = 0
  UP = 1
  LEFT = 2
  DOWN = 3

  def initialize(n)
    @x = 0
    @y = 0
    @state = RIGHT
    @row_len = 0
    @cell = 1
    @stop_cell = n
    @distance = 0
  end

  def find_distance()
    until sweep_row() do
      STDOUT.write "\r#{@cell}/#{@stop_cell}"
      STDOUT.flush
    end
    STDOUT.write "\nTarget is #{@x}, #{@y}(#{@distance})\n"
  end

  def sweep_row()
    i = 0

    if @stop_cell == 1 then
      @distance = 0
      return true
    end

    if @state == LEFT or @state == RIGHT then
      @row_len += 1
    end

    while i < @row_len do
      move()
      i += 1
      @cell += 1
      if @cell == @stop_cell then
        @distance = @x.abs + @y.abs
        return true
      end
    end

    @state += 1

    if @state > DOWN then
      @state = 0
    end
    return false
  end

  def move()
    case @state
    when RIGHT
      @x += 1
    when UP
      @y += 1
    when LEFT
      @x -= 1
    when DOWN
      @y -= 1
    end
  end
end

sm = SpiralMap.new(ARGV[0].to_i)
sm.find_distance()