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

end
