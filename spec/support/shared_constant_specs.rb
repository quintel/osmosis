shared_examples 'a constant' do
  let(:variable) { described_class.new(0, 50, 25) }

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
end # a constant
