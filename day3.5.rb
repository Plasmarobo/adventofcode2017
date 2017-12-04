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
    @stop_value = n
    @cell_values = {}
    @cell_values[[@x, @y].to_s] = 1
  end

  def find_value()
    until sweep_row() do
      STDOUT.write "At #{@cell}\n"
      STDOUT.flush
    end
    STDOUT.write "\nValue is #{@cell_values[[@x,@y].to_s]}\n"
  end

  def read_value(x,y)
    if @cell_values.has_key? [x,y].to_s then
      return @cell_values[[x,y].to_s]
    else
      return 0
    end
  end

  def sweep_row()
    i = 0

    if @state == LEFT or @state == RIGHT then
      @row_len += 1
    end

    while i < @row_len do
      move()
      i += 1
      @cell += 1
      @cell_values[[@x, @y].to_s] = 0

      # Add all adjacent
      (-1..1).each do |x|
        (-1..1).each do |y|
          if x != 0 or y != 0 then
            @cell_values[[@x, @y].to_s] += read_value(@x+x, @y+y)
          end
        end
      end
      if @cell_values[[@x, @y].to_s] > @stop_value then
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
sm.find_value()