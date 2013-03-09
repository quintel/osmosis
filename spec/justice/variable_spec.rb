require 'spec_helper'

describe Justice::Variable do
  include_examples 'a constant'

  describe 'setting a value' do
    context 'when min <= value >= max' do
      before { variable.value = 30 }

      it 'sets the value' do
        expect(variable.value).to eq(30)
      end

      it 'casts the value to a Rational' do
        expect(variable.value).to be_a(Rational)
      end
    end # when min <= value >= max

    context 'when value < min' do
      before { variable.value = -10 }

      it 'sets the value to the minimum' do
        expect(variable.value).to be_zero
      end

      it 'casts the value to a Rational' do
        expect(variable.value).to be_a(Rational)
      end
    end # when value < min

    context 'when value > max' do
      before { variable.value = 60 }

      it 'sets the value to the maximum' do
        expect(variable.value).to eq(50)
      end

      it 'casts the value to a Rational' do
        expect(variable.value).to be_a(Rational)
      end
    end # when value > max
  end # setting a value

  # #headroom / #can_change? -------------------------------------------------

  context 'with min/value/max of 0/25/50' do
    it 'headroom(:up) is 25' do
      expect(variable.headroom(:up)).to eq(25)
    end

    it 'headroom(:down) is 25' do
      expect(variable.headroom(:down)).to eq(25)
    end

    it 'can_change?(:up) is true' do
      expect(variable.can_change?(:up)).to be_true
    end

    it 'can_change?(:down) is true' do
      expect(variable.can_change?(:down)).to be_true
    end
  end # with min/value/max of 0/25/50

  context 'with min/value/max of 0/0/50' do
    before { variable.value = 0 }

    it 'headroom(:up) is 50' do
      expect(variable.headroom(:up)).to eq(50)
    end

    it 'headroom(:down) is 0' do
      expect(variable.headroom(:down)).to be_zero
    end

    it 'can_change?(:up) is true' do
      expect(variable.can_change?(:up)).to be_true
    end

    it 'can_change?(:down) is false' do
      expect(variable.can_change?(:down)).to be_false
    end
  end # with min/value/max of 0/0/50

  context 'with min/value/max of 0/50/50' do
    before { variable.value = 50 }

    it 'headroom(:up) is 0' do
      expect(variable.headroom(:up)).to be_zero
    end

    it 'headroom(:down) is 50' do
      expect(variable.headroom(:down)).to eq(50)
    end

    it 'can_change?(:up) is false' do
      expect(variable.can_change?(:up)).to be_false
    end

    it 'can_change?(:down) is true' do
      expect(variable.can_change?(:down)).to be_true
    end
  end # with min/value/max of 0/50/50

end # Justice::Variable
