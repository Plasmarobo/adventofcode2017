
class SequenceParser

  NORTH = 1
  SOUTH = 2
  EAST = 4
  WEST = 8

  def initialize
    @sequence = []
    @directions = {}
    @letters = ""
  end

  def parse(filename)
    y = 0
    x = 0
    File.open(filename, "r").read.each_line do |line|
      line.chars.each do |c|
        dir = nil
        case c
        when '|'
          dir = NORTH | SOUTH
        when '-'
          dir = EAST | WEST
        when '+'
          dir = EAST | WEST | NORTH | SOUTH
        else
          if /([a-zA-Z]+)/.match c then
            dir = c
          end
        end
        if dir != nil then
          @directions[[x,y].to_s] = dir
        end
        x += 1
      end
      x = 0
      y += 1
    end
  end

  def move pos, dir
    np = pos.dup
    case dir
    when SOUTH
      np[1] += 1
    when NORTH
      np[1] -= 1
    when EAST
      np[0] += 1
    when WEST
      np[0] -= 1
    end
    return np
  end

  def turn_ccw dir
    case dir
    when SOUTH
      return EAST
    when NORTH
      return WEST
    when EAST
      return NORTH
    when WEST
      return SOUTH
    end
    return nil
  end

  def turn_cw dir
    case dir
    when SOUTH
      return WEST
    when WEST
      return NORTH
    when NORTH
      return EAST
    when EAST
      return SOUTH
    end
    return nil
  end

  def valid_pos? next_pos
    return (next_pos != nil and @directions.include? next_pos.to_s)
  end

  def traverse
    # Find the start point
    y = 0
    x = 0
    start = false
    until start != false do
      if @directions.include? [x,y].to_s and @directions[[x,y].to_s] & SOUTH then
        start = [x,y]
        break
      end
      x += 1
    end
    print "Starting at #{start}\n"
    finish = false
    @sequence.push(start)
    dir = SOUTH
    pos = [x,0]
    until finish != false do
      if @directions.include? pos.to_s and @directions[pos.to_s].is_a? String then
        @letters += @directions[pos.to_s]
      end

      next_pos = move pos, dir
      # Continue straight if we can, if not
      if valid_pos? next_pos then
        pos = next_pos
      else
        new_dir = turn_ccw dir
        next_pos = move pos, new_dir
        if valid_pos? next_pos then
          dir = new_dir
        else
          new_dir = turn_cw dir
          next_pos = move pos, new_dir
          if valid_pos? next_pos then
            dir = new_dir
          else
            finish = pos
          end
        end
      end

    end

    print "Encountered #{@letters}\n"
  end
end

s = SequenceParser.new
s.parse(ARGV[0])
s.traverse
