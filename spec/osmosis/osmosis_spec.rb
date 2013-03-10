require 'spec_helper'

describe Osmosis do
  describe '.balance' do
    context 'given an array of values' do
      let(:values) do
        Osmosis.balance([
          { min: 0, max: 100, value: 50, static: true },
          { min: 0, max: 100, value: 0 }
        ])
      end

      it 'returns an array' do
        expect(values).to be_an(Array)
      end

      it 'balances the values' do
        expect(values).to eq([50, 50])
      end
    end # given an array of values

    context 'given a hash of values' do
      let(:values) do
        Osmosis.balance({
          a: { min: 0, max: 100, value: 50, static: true },
          b: { min: 0, max: 100, value: 0 }
        })
      end

      it 'returns a hash' do
        expect(values).to be_a(Hash)
      end

      it 'balances the values' do
        expect(values).to eq(a: 50, b: 50)
      end
    end # given an array of values
  end # .balance
end # Osmosis
