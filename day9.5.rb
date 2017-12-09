
class StreamParser

  TOKEN_GARBAGE_OPEN = '<'
  TOKEN_GARBAGE_CLOSE = '>'
  TOKEN_IGNORE = '!'
  TOKEN_GROUP_OPEN = '{'
  TOKEN_GROUP_CLOSE = '}'
  TOKEN_GROUP_ITEM = ','

  STATE_GROUP = 0
  STATE_GARBAGE = 1
  STATE_IGNORE = 2

  def initialize()
    @state_stack = [STATE_GROUP]
    @content_stack = [[]]
    @group_depth = 0
    @group = ->(depth) {}
    @group_item = ->(content) {}
    @ignore = ->(char) {}
    @garbage = ->(garbage) {}
  end

  #group(depth)
  def on_group callback
    @group = callback
  end

  #group_item([content])
  def on_group_item callback
    @group_item = callback
  end
    
  #ignore(char)
  def on_ignore callback
    @group_content = callback
  end
    
  #garbage([garbage])
  def on_garbage callback
    @garbage = callback
  end

  def parse(char)
    case @state_stack.last
    when STATE_GROUP
      case char
      when TOKEN_GROUP_OPEN
        @group_depth += 1
        push_state(STATE_GROUP)
      when TOKEN_GROUP_CLOSE
        @group_item.call(@content_stack.last)
        @group.call(@group_depth)
        @group_depth -= 1
        pop_state()
      when TOKEN_IGNORE
        push_state(STATE_IGNORE)
      when TOKEN_GARBAGE_OPEN
        push_state(STATE_GARBAGE)
      when TOKEN_GROUP_ITEM
        @group_item.call(@content_stack.last)
      else
        @content_stack.last.push(char)
      end

    when STATE_GARBAGE
      case char
      when TOKEN_GARBAGE_CLOSE
        @garbage.call(@content_stack.last)
        pop_state()
      when TOKEN_IGNORE
        push_state(STATE_IGNORE)
      else
        @content_stack.last.push(char)
      end
    when STATE_IGNORE
      @ignore.call(char)
      pop_state()
    end
  end

  def pop_state
    @state_stack.pop
    @content_stack.pop
  end

  def push_state(state)
    @state_stack.push(state)
    @content_stack.push([])
  end

  def parse_file(filename) 
    File.open(filename, "r").read.each_line do |line|
      line.each_char do |char|
        parse(char)
      end
    end
  end
end

parser = StreamParser.new

garbage_score = 0
parser.on_garbage(->(garbage) { garbage_score += garbage.length; print "GARBAGE #{garbage.join("")}\n" })

parser.parse_file(ARGV[0])
print "Got score of #{garbage_score}\n"
