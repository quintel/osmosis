require 'spec_helper'

describe Justice::Variable do
  let(:variable) { Justice::Variable.new(0, 50, 25) }

  describe 'min' do
    it 'returns the minimum value of the variable' do
      expect(variable.min).to eq(0)
    end

    it 'casts to a BigDecimal when possible' do
      expect(variable.min).to be_a(BigDecimal)
    end
  end # min

  describe 'max' do
    it 'returns the maximum value of the variable' do
      expect(variable.max).to eq(50)
    end

    it 'casts to a BigDecimal when possible' do
      expect(variable.max).to be_a(BigDecimal)
    end
  end # max

  describe 'delta' do
    it 'is the difference between the maximum and minimum' do
      expect(variable.delta).to eq(50)
    end
  end # delta

  describe 'to_s' do
    it 'is a numeric representation of the value' do
      expect(variable.to_s).to eql('25.0')
    end
  end # to_s

  describe 'inspect' do
    let(:inspected) { variable.inspect }

    it 'includes the minimum value' do
      expect(inspected).to include('min=0.0')
    end

    it 'includes the maximum value' do
      expect(inspected).to include('max=50.0')
    end

    it 'includes the current value' do
      expect(inspected).to include('value=25.0')
    end
  end # inspect

  describe 'setting a value' do
    context 'when min <= value >= max' do
      before { variable.value = 30 }

      it 'sets the value' do
        expect(variable.value).to eq(30)
      end

      it 'casts the value to a BigDecimal' do
        expect(variable.value).to be_a(BigDecimal)
      end
    end # when min <= value >= max

    context 'when value < min' do
      before { variable.value = -10 }

      it 'sets the value to the minimum' do
        expect(variable.value).to be_zero
      end

      it 'casts the value to a BigDecimal' do
        expect(variable.value).to be_a(BigDecimal)
      end
    end # when value < min

    context 'when value > max' do
      before { variable.value = 60 }

      it 'sets the value to the maximum' do
        expect(variable.value).to eq(50)
      end

      it 'casts the value to a BigDecimal' do
        expect(variable.value).to be_a(BigDecimal)
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
