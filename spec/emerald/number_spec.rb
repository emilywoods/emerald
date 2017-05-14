require 'spec_helper'

require 'emerald/number'

RSpec.describe Emerald::Number do
  describe '#==' do
    it 'can be equal' do
      num1 = Emerald::Number.new(1)
      num2 = Emerald::Number.new(1)
      expect(num1).to eq(num2)
    end

    it 'can be equal with floats' do
      num1 = Emerald::Number.new(1.25)
      num2 = Emerald::Number.new(1.25)
      expect(num1).to eq(num2)
    end

    it 'can be unequal with the same class' do
      num1 = Emerald::Number.new(1)
      num2 = Emerald::Number.new(2)
      expect(num1).not_to eq(num2)
    end

    it 'can be unequal with a different class' do
      num1 = Emerald::Number.new(1)
      num2 = Emerald::Atom.new(1)
      expect(num1).not_to eq(num2)
    end
  end
end
