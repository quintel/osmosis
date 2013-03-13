require 'spec_helper'
require 'bigdecimal'

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

  describe '.rational' do
    it 'returns a rational given an Integer' do
      expect(Osmosis.rational(1)).to be_a(Rational)
    end

    it 'returns a rational given a Float' do
      expect(Osmosis.rational(1.0)).to be_a(Rational)
    end

    it 'returns a rational given a BigDecimal' do
      expect(Osmosis.rational(BigDecimal.new('1.0'))).to be_a(Rational)
    end

    it 'returns a rational given a Rational' do
      expect(Osmosis.rational(Rational(1))).to be_a(Rational)
    end

    it 'raises Osmosis::InvalidValue when given a string' do
      expect { Osmosis.rational('') }.
        to raise_error(Osmosis::InvalidValueError)
    end

    it 'raises Osmosis::InvalidValue when given nil' do
      expect { Osmosis.rational(nil) }.
        to raise_error(Osmosis::InvalidValueError)
    end
  end # .rational
end # Osmosis
