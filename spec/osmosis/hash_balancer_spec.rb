require 'spec_helper'

describe Osmosis::HashBalancer do
  let(:values) { Osmosis::HashBalancer.new(elements).balanced }

  describe 'With { a: 50*, b: 0, c: 0 }' do
    let(:elements) { {
      a: { min: 0, max: 100, value: 50, static: true },
      b: { min: 0, max: 100, value: 0 },
      c: { min: 0, max: 100, value: 0 }
    } }

    it 'returns a Hash' do
      expect(values).to be_a(Hash)
    end

    it 'has the same keys as the original' do
      expect(values.keys).to eql(elements.keys)
    end

    it 'does not change the constant element' do
      expect(values[:a]).to eq(50)
    end

    it 'changes the first variable element from 0->25' do
      expect(values[:b]).to eq(25)
    end

    it 'changes the second variable element from 0->25' do
      expect(values[:c]).to eq(25)
    end
  end # With { a: 50*, b: 0, c: 0 }
end # Osmosis::HashBalancer
