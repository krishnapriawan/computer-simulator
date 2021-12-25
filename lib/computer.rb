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
    validate_address(addr)
    @current_pointer = addr
    self
  end

  def insert(argc, argv = nil)
    validate_insert(argc, argv)
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
        validate_address(pc)
        next
      when 'RET'
        pc = pop
        validate_address(pc)
        next
      end
      pc += 1
    end
  end

  def size
    @pc_stack.length
  end

  def print_stack
    @pc_stack.to_s
  end

  private

  def has_data?(data)
    data && data.to_s != 'STOP'
  end

  def push(n)
    @pc_stack[@stack_pointer] = n.to_i
    @stack_pointer += 1
  end

  def pop
    num = @pc_stack[@stack_pointer - 1]
    validate_integer_data(num, EmptyDataStackError.new('Unable to pop data in empty stack'))
    @pc_stack[@stack_pointer - 1] = nil
    @stack_pointer -= 1
    num
  end

  def validate_address(addr)
    validate_integer_data(addr, InvalidValueError.new('Argument value for address should be a number'))
    case addr
    when String
      raise InvalidValueError.new('Argument value for address should be a number')
    when -Float::INFINITY..-1
      raise InvalidNumberError.new('Argument value for address should be a positive number')
    when @pc_stack.length..Float::INFINITY
      raise StackOutOfBoundError.new('Address out of bounds')
    end
  end

  def validate_insert(argc, argv)
    case argc
    when 'PUSH'
      raise InvalidValueError.new('Missing argument value in PUSH command') if argv.nil?
      raise InvalidValueError.new('Argument value in PUSH command should be a number') unless argv.is_a? Integer
    when 'CALL'
      raise InvalidValueError.new('Missing argument value in CALL command') if argv.nil?
      raise InvalidValueError.new('Argument value in CALL command should be a number') unless argv.is_a? Integer
    else
      raise InvalidValueError.new("Unknown insert command: #{argc}") unless %w[MULT PUSH CALL PRINT RET STOP].include? argc
    end
    raise InvalidValueError.new('Failed to insert. Address out of bounds') if @current_pointer >= @pc_stack.length
  end

  def validate_integer_data(data, exception)
    begin
      Integer(data)
    rescue
      raise exception
    end
  end
end
