require 'computer'

describe Computer do
  context '.initialize' do
    it 'should return valid size' do
      computer = Computer.new(100)
      expect(computer.size).to eql(100)
    end

    it 'should raise error for negative number' do
      expect { Computer.new(-99) }.to raise_error ArgumentError
    end

    it 'should raise error for string' do
      expect { Computer.new('100') }.to raise_error TypeError
    end
  end

  context '.set_address' do
    computer = Computer.new(1000)

    it 'should succeed' do
      expect(computer.set_address(2)).to eql(computer)
    end

    it 'should succeed at last index of stack' do
      expect(computer.set_address(999)).to eql(computer)
    end

    it 'should raise an error for out of bound address' do
      expect { computer.set_address(1000) }.to raise_error StackOutOfBoundError
    end

    it 'should raise an error for negative number' do
      expect { computer.set_address(-2) }.to raise_error InvalidNumberError
    end

    it 'should raise an error for string' do
      expect { computer.set_address('2') }.to raise_error InvalidValueError
    end

    it 'should raise an error for nil' do
      expect { computer.set_address(nil) }.to raise_error InvalidValueError
    end
  end

  context '.insert' do
    computer = Computer.new(1000)

    it 'should insert valid instructions' do
      expect(computer.set_address(0).insert('PUSH', 5).insert('PRINT').insert('CALL', 45)).to eql(computer)
      expect(computer.set_address(10).insert('PUSH', 10).insert('PUSH', 9).insert('MULT')).to eql(computer)
      expect(computer.set_address(10).insert('RET', 10).insert('PUSH', 9).insert('STOP')).to eql(computer)
    end

    it 'should raise an error for unknown instructions' do
      expect { computer.set_address(0).insert('ADD').insert('PRINT') }.to raise_error InvalidValueError
    end

    it 'should raise an error for inserting PUSH without value parameter' do
      expect { computer.set_address(0).insert('PUSH').insert('PRINT') }.to raise_error InvalidValueError
    end

    it 'should raise an error for inserting PUSH with non-numeric value' do
      expect { computer.set_address(0).insert('PUSH', '5').insert('PRINT') }.to raise_error InvalidValueError
    end

    it 'should raise an error for inserting CALL without value parameter' do
      expect { computer.set_address(0).insert('CALL').insert('PRINT') }.to raise_error InvalidValueError
    end

    it 'should raise an error for inserting CALL with non-numeric value' do
      expect { computer.set_address(0).insert('CALL', '5').insert('PRINT') }.to raise_error InvalidValueError
    end

    it 'should raise an error for inserting at out of bound address' do
      expect { computer.set_address(999).insert('PUSH', 999).insert('PUSH', 1000) }.to raise_error InvalidValueError
    end
  end

  context '.execute' do
    PRINT_TENTEN_BEGIN = 50
    MAIN_BEGIN = 0
    it 'should execute sample test' do
      computer = Computer.new(100)

      computer.set_address(PRINT_TENTEN_BEGIN).insert('MULT').insert('PRINT').insert('RET')
      computer.set_address(MAIN_BEGIN).insert('PUSH', 1009).insert('PRINT')
      computer.insert('PUSH', 6)
      computer.insert('PUSH', 101).insert('PUSH', 10).insert('CALL', PRINT_TENTEN_BEGIN)
      computer.insert('STOP')

      expect(computer.stack_pointer).to eql(53)
      expect(computer.current_pointer).to eql(7)
      expect { computer.set_address(MAIN_BEGIN).execute }.to output("1009\n1010\n").to_stdout
    end

    it 'should raise an error when data stack is empty' do
      computer = Computer.new(3)

      computer.set_address(0).insert('PUSH', 2).insert('RET').insert('PRINT')
      expect { computer.set_address(0).execute }.to raise_error EmptyDataStackError
    end

    it 'should terminate when data in address is nil' do
      computer = Computer.new(20)

      computer.set_address(0).insert('PUSH', 10).insert('PRINT')
      computer.set_address(0).insert('PUSH', 20).insert('CALL', 15)

      expect { computer.set_address(0).execute }.to output('').to_stdout
    end

    it 'should raise an error when empty stack' do
      computer = Computer.new(1)
      computer.insert('PRINT')

      expect { computer.set_address(0).execute }.to raise_error EmptyDataStackError
    end

    it 'should raise an error when execution starts at out of bound address' do
      computer = Computer.new(1)
      computer.insert('PRINT')

      expect { computer.execute }.to raise_error StackOutOfBoundError
    end

    it 'should raise an error for infinite loop / cyclic instructions' do
      computer = Computer.new(2)
      computer.insert('PUSH', 0).insert('RET')

      expect { computer.set_address(0).execute }.to raise_error InfiniteExecutionError
    end
  end
end
