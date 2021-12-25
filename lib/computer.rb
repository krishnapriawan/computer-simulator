require 'exceptions'

class Computer

  attr_reader :stack_pointer
  attr_reader :current_pointer

  def initialize(n)
    @pc_stack = Array.new(n)
    @stack_pointer = 0
    @current_pointer = 0
  rescue ArgumentError => e
    raise e
  rescue TypeError => e
    raise e
  end

  def set_address(addr)
    @current_pointer = addr
    self
  end

  def insert(argc, argv = nil)
    value_param = " #{argv}" unless argv.nil?
    @pc_stack[@current_pointer] = "#{argc}#{value_param}"
    @current_pointer += 1
    @stack_pointer = @current_pointer if @current_pointer > @stack_pointer
    self
  end

  def execute
    pc = @current_pointer
    while has_data?(@pc_stack[pc])
      instructions = @pc_stack[pc].split(' ')
      case instructions[0]
      when 'PRINT'
        puts pop
      when 'PUSH'
        push(instructions[1].to_i)
      when 'MULT'
        push(pop * pop)
      when 'CALL'
        pc = instructions[1].to_i
        # puts "CALL pc: #{pc}"
        next
      when 'RET'
        pc = pop
        # puts "RET pc: #{pc}"
        next
      end
      pc += 1
    end
  end


  private

  def has_data?(data)
    data && data.to_s != 'STOP'
  end

  def push(n)
    # puts "PUSH stack_pointer: #{@stack_pointer}, n: #{n.to_i}"
    @pc_stack[@stack_pointer] = n.to_i
    @stack_pointer += 1
  end

  def pop
    num = @pc_stack[@stack_pointer - 1]
    # puts "POP stack_pointer: #{stack_pointer}, num: #{num}"
    @pc_stack[@stack_pointer - 1] = nil
    @stack_pointer -= 1
    num
  end

end
