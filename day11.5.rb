
class HexMap

  def initialize()
    @x = 0
    @y = 0
    @z = 0
    @max_dist = 0
  end

  def translate_step(dir)
    case dir
    when "ne"
      @x += 1
      @z -= 1
    when "n"
      @y += 1
      @z -= 1
    when "nw"
      @x -= 1
      @y += 1
    when "sw"
      @x -= 1
      @z += 1
    when "s"
      @y -= 1
      @z += 1
    when "se"
      @x += 1
      @y -= 1
    end
    if [@x,@y,@z].max > @max_dist then
      @max_dist = [@x,@y,@z].max
    end
  end

  def print_position()
    print "At #{@x},#{@y}\n"
    print "#{[@x,@y,@z].max} from 0,0\n"
    print "Max dist was #{@max_dist}\n"
  end
end

File.open(ARGV[0], "r").read.each_line do |line|
  moves = line.chomp.split(",")
  map = HexMap.new
  moves.each {|move| map.translate_step(move)}
  map.print_position()
end
