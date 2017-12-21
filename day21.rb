def print_grid(cells)
  pitch = Math.sqrt(cells.length).to_i
  x = 0
  y = 0
  while y < pitch do
    while x < pitch do
      print cells[(y*pitch)+x]
      x += 1
    end
    print "\n"
    x = 0
    y += 1
  end
  print "\n"
end

class EnhancementRule
  attr_accessor :size
  def initialize(line)
    line = line.chomp.gsub("\/","")
    parts = line.split(" => ")
    @pattern = parts[0].chars.to_a
    @size = Math.sqrt(@pattern.length)
    @output = parts[1].chars.to_a
  end

  def search(cell)
    pattern = @pattern
    if cell != pattern
      pattern = @pattern
      3.times do
        pattern = rotate(pattern)
        if cell == pattern
          return @output
        end
      end
      pattern = @pattern
      pattern = flip
      if cell != pattern
        3.times do
          pattern = rotate(pattern)
          if cell == pattern
            return @output
          end
        end
      else
        return @output
      end
    else
      return @output
    end
    return nil
  end

  def rotate(pattern)
    rotator = []
    x = 0
    y = 0
    while y < @size do
      rotator.push([])
      while x <  @size do
        rotator[y][x] = pattern[(@size * y) + x]
        x += 1
      end
      x = 0
      y += 1
    end
    rotator = rotator.reverse.transpose.flatten
    return rotator
  end

  def flip()
    x = 0
    y = 0
    flipped = Array.new(@pattern.length)
    while y < @size do
      while x < @size do
        flipped[(y * @size) + (@size - x - 1)] = @pattern[(y * @size) + x]
        x += 1
      end
      x = 0
      y += 1
    end
    return flipped
  end
end

class Enhancer

  def initialize(rulefile)
    @grid = ".#...####".chars.to_a
    @rules = {}
    @rules[2] = []
    @rules[3] = []
    File.open(rulefile, "r").read.each_line do |line|
      rule = EnhancementRule.new(line)
      @rules[rule.size.to_i].push(rule)
    end
  end

  def enhance(n)
    n.times do
      if Math.sqrt(@grid.length) % 2 == 0 then
        size = 2
      elsif Math.sqrt(@grid.length) % 3 == 0 then
        size = 3
      else
        print "Bad state\n"
      end
      rules = @rules[size]

      pitch = Math.sqrt(@grid.length).to_i
      squares = (@grid.length/ (size ** 2))
      side_len = Math.sqrt(squares)

      output = Array.new(squares * ((size+1) ** 2))
      outpitch = Math.sqrt(output.length).to_i
      # Chunk the current grid and apply rules
      i = 0
      j = 0
      while j < side_len do
        while i < side_len do
          cells = Array.new(size ** 2)
          x = 0
          y = 0
          while y < size
            while x < size
              yp = (j * size) + y
              xp = (i * size) + x
              cells[(y * size) + x] = @grid[(yp * pitch) + xp]
              x += 1
            end
            x = 0
            y += 1
          end
          no_rule = true
          rules.each do |rule|
            res = rule.search(cells)
            next if res == nil
            sz = Math.sqrt(res.size)
            x = 0
            y = 0
            while y < sz do
              while x < sz do
                inp = (sz * i) + x + (outpitch * (y + (j * sz)))
                oup = (y*sz)+x
                output[inp] = res[oup]
                x += 1
              end
              x = 0
              y += 1
            end
            no_rule = false
            break
          end
          if no_rule then
            print "NO RULE ERROR:\n"
            print_grid cells
            exit
          end
          i += 1
        end
        i = 0
        j += 1
      end
      @grid = output
    end
  end

  def count_on
    print @grid.count {|x| x == '#'}, " pixels on\n"
  end
end

e = Enhancer.new(ARGV[0])
e.enhance(ARGV[1].to_i)
e.count_on
