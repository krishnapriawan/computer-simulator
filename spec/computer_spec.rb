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

end
