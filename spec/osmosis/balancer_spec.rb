require 'spec_helper'

describe Osmosis::Balancer do
  let(:equilibrium) { 100 }
  let(:values)      { Osmosis::Balancer.new(elements, equilibrium).balanced }

  # --------------------------------------------------------------------------

  describe 'With (50*, 0, 0)' do
    let(:elements) { [
      { min: 0, max: 100, value: 50, static: true },
      { min: 0, max: 100, value: 0 },
      { min: 0, max: 100, value: 0 }
    ] }

    it 'does not change the constant element' do
      expect(values[0]).to eq(50)
    end

    it 'changes the first variable element from 0->25' do
      expect(values[1]).to eq(25)
    end

    it 'changes the second variable element from 0->25' do
      expect(values[2]).to eq(25)
    end
  end # With (50*, 0, 0)

  describe 'With (50*, 15*, 0)' do
    let(:elements) { [
      { min: 0, max: 100, value: 50, static: true },
      { min: 0, max: 100, value: 15, static: true },
      { min: 0, max: 100, value: 0 }
    ] }

    it 'does not change the constant elements' do
      expect(values[0]).to eq(50)
      expect(values[1]).to eq(15)
    end

    it 'changes the first variable element from 0->35' do
      expect(values[2]).to eq(35)
    end
  end # With (50*, 15*, 0)

  describe 'With (50*, 25*, 25*)' do
    let(:elements) { [
      { min: 0, max: 100, value: 50, static: true },
      { min: 0, max: 100, value: 25, static: true },
      { min: 0, max: 100, value: 25, static: true }
    ] }

    it 'does not change any values' do
      expect(values[0]).to eq(50)
      expect(values[1]).to eq(25)
      expect(values[2]).to eq(25)
    end
  end # With (50*, 25*, 25*)

  describe 'With (50*, 25*, 24*)' do
    let(:elements) { [
      { min: 0, max: 100, value: 50, static: true },
      { min: 0, max: 100, value: 25, static: true },
      { min: 0, max: 100, value: 24, static: true }
    ] }

    it 'raises a NoVariablesError' do
      expect { values }.to raise_error(Osmosis::NoVariablesError)
    end
  end # With (50*, 25*, 24*)

  describe 'With (100*, 0, 0)' do
    let(:elements) { [
      { min: 0, max: 100, value: 100, static: true },
      { min: 0, max: 100, value: 0 },
      { min: 0, max: 100, value: 0 }
    ] }

    it 'does not change any values' do
      expect(values[0]).to eq(100)
      expect(values[1]).to eq(0)
      expect(values[2]).to eq(0)
    end
  end # With (100*, 0, 0)

  describe 'With (110*, 0, 0)' do
    let(:elements) { [
      { min: 0, max: 100, value: 110, static: true },
      { min: 0, max: 100, value: 0 },
      { min: 0, max: 100, value: 0 }
    ] }

    it 'raises a CannotBalanceError' do
      expect { values }.to raise_error(Osmosis::CannotBalanceError)
    end
  end # With (110*, 0, 0)

  describe 'With (-100*, 0, 0)' do
    let(:elements) { [
      { min: -100, max: 100, value: -100, static: true },
      { min: 0, max: 100, value: 0 },
      { min: 0, max: 100, value: 0 }
    ] }

    it 'does not change the constant element' do
      expect(values[0]).to eq(-100)
    end

    it 'changes the first variable from 0->100' do
      expect(values[1]).to eq(100)
    end

    it 'changes the second variable from 0->100' do
      expect(values[2]).to eq(100)
    end
  end # With (-101, 0, 0)

  describe 'With (-101*, 0, 0)' do
    let(:elements) { [
      { min: 0, max: 100, value: -101, static: true },
      { min: 0, max: 100, value: 0 },
      { min: 0, max: 100, value: 0 }
    ] }

    it 'raises a CannotBalanceError' do
      expect { values }.to raise_error(Osmosis::CannotBalanceError)
    end
  end # With (-101, 0, 0)

  describe 'With (20, 50, 0)' do
    let(:elements) { [
      { min: 0, max: 100, value: 20 },
      { min: 0, max: 100, value: 50 },
      { min: 0, max: 100, value: 0 }
    ] }

    it 'changes the first variable from 20->30' do
      expect(values[0]).to eq(30)
    end

    it 'changes the second variable from 50->60' do
      expect(values[1]).to eq(60)
    end

    it 'changes the third variable from 0->10' do
      expect(values[2]).to eq(10)
    end
  end # With (20, 50, 0)

  describe 'With (70*, 30, 20)' do
    let(:elements) { [
      { min: 0, max: 100, value: 70, static: true },
      { min: 0, max: 100, value: 30 },
      { min: 0, max: 100, value: 20 }
    ] }

    it 'does not change the constant' do
      expect(values[0]).to eq(70)
    end

    it 'changes the first variable from 30->20' do
      expect(values[1]).to eq(20)
    end

    it 'changes the second variable from 20->10' do
      expect(values[2]).to eq(10)
    end
  end # With (70*, 30, 20)

  describe 'With (0*, 30, 20)' do
    let(:elements) { [
      { min: 0, max: 100, value: 0, static: true },
      { min: 0, max: 100, value: 30 },
      { min: 0, max: 100, value: 20 }
    ] }

    it 'does not change the constant' do
      expect(values[0]).to eq(0)
    end

    it 'changes the first variable from 30->55' do
      expect(values[1]).to eq(55)
    end

    it 'changes the second variable from 20->45' do
      expect(values[2]).to eq(45)
    end
  end # With (0*, 30, 20)

  # --------------------------------------------------------------------------

  describe 'When a variable has a delta of zero' do
    context 'given values which already balance' do
      let(:elements) { [
        { min: 0, max: 100, value: 96, static: true },
        { min: 0, max: 100, value: 4, static: true },
        { min: 0, max: 0, value: 0 }
      ] }

      it 'does not change any values' do
        expect(values[0]).to eq(96)
        expect(values[1]).to eq(4)
        expect(values[2]).to eq(0)
      end
    end # given values which already balance

    context 'given values which can be balanced' do
      let(:elements) { [
        { min: 0, max: 100, value: 96, static: true },
        { min: 0, max: 100, value: 0 },
        { min: 0, max: 0, value: 0 }
      ] }

      it 'does not change the constant' do
        expect(values[0]).to eq(96)
      end

      it 'uses the variable to balance' do
        expect(values[1]).to eq(4)
      end

      it 'does not change the zero-delta variable' do
        expect(values[2]).to eq(0)
      end
    end # given values which can be balanced

    context 'given values which cannot balance' do
      let(:elements) { [
        { min: 0, max: 100, value: 31, static: true },
        { min: 0, max: 100, value: 62, static: true },
        { min: 0, max: 0, value: 0 }
      ] }

      it 'raises a CannotBalanceError' do
        expect { values }.to raise_error(Osmosis::NoVariablesError)
      end
    end # given values which cannot balance
  end # When a variable has a delta of zero

  # --------------------------------------------------------------------------

  describe 'When each element has min/max of -100/100' do
    context 'given (90*, 40*, 0)' do
      let(:elements) { [
        { min: -100, max: 100, value: 90, static: true },
        { min: -100, max: 100, value: 40, static: true },
        { min: -100, max: 100, value: 0 }
      ] }

      it 'does not change the first constant' do
        expect(values[0]).to eq(90)
      end

      it 'does not change the second constant' do
        expect(values[1]).to eq(40)
      end

      it 'changes the variable from 0->-30' do
        expect(values[2]).to eq(-30)
      end
    end # given (-50*, 0, 0)

    context 'given (0*, -1*, 0)' do
      let(:elements) { [
        { min: -100, max: 100, value: 0, static: true },
        { min: -100, max: 100, value: -1, static: true },
        { min: -100, max: 100, value: 0 }
      ] }

      it 'raises a CannotBalanceError' do
        expect { values }.to raise_error(Osmosis::CannotBalanceError)
      end
    end # given (0*, -1*, 0)
  end # When each element has min/max of -100/100

  # --------------------------------------------------------------------------

  describe 'With an equilibrium of 500' do
    let(:equilibrium) { 500 }

    context 'given (150*, 250, 0)' do
      let(:elements) { [
        { min: 0, max: 300, value: 150, static: true },
        { min: 0, max: 300, value: 250 },
        { min: 0, max: 300, value: 0 }
      ] }

      it 'does not change the constant' do
        expect(values[0]).to eq(150)
      end

      it 'changes the first variable from 250->300' do
        expect(values[1]).to eq(300)
      end

      it 'changes the second variable from 0->50' do
        expect(values[2]).to eq(50)
      end
    end # given (50*, 250, 0)

    context 'given (0*, 300*, 0)' do
      let(:elements) { [
        { min: 0, max: 300, value: 0, static: true },
        { min: 0, max: 300, value: 300, static: true },
        { min: 0, max: 300, value: 0 }
      ] }

      it 'does not change the first constant' do
        expect(values[0]).to eq(0)
      end

      it 'does not change the second constant' do
        expect(values[1]).to eq(300)
      end

      it 'changes the first constant from 0->200' do
        expect(values[2]).to eq(200)
      end
    end # given (0*, 300*, 0)
  end # With an equilibrium of 500

  # --------------------------------------------------------------------------

  describe 'With min/max of 0/100, 0/40, 0/10' do
    context 'given (50*, 0, 0)' do
      let(:elements) { [
        { min: 0, max: 100, value: 50, static: true },
        { min: 0, max: 40, value: 0 },
        { min: 0, max: 10, value: 0 }
      ] }

      it 'does not change the constant' do
        expect(values[0]).to eq(50)
      end

      it 'changes the first variable from 0->40' do
        expect(values[1]).to eq(40)
      end

      it 'changes the second variable from 0->10' do
        expect(values[2]).to eq(10)
      end
    end # given (50*, 0, 0)

    context 'given (80*, 0, 0)' do
      let(:elements) { [
        { min: 0, max: 100, value: 80, static: true },
        { min: 0, max: 40, value: 0 },
        { min: 0, max: 10, value: 0 }
      ] }

      it 'does not change the constant' do
        expect(values[0]).to eq(80)
      end

      it 'changes the first variable from 0->16' do
        expect(values[1]).to eq(16)
      end

      it 'changes the second variable from 0->4' do
        expect(values[2]).to eq(4)
      end
    end # given (80*, 0, 0)

    context 'given (49*, 0, 0)' do
      let(:elements) { [
        { min: 0, max: 100, value: 49, static: true },
        { min: 0, max: 40, value: 0 },
        { min: 0, max: 10, value: 0 }
      ] }

      it 'raises a CannotBalanceError' do
        expect { values }.to raise_error(Osmosis::CannotBalanceError)
      end
    end
  end # With min/max of 0/100, 0/40, 0/10

  # --------------------------------------------------------------------------

  describe 'With min/max of 0/0.001' do
    let(:equilibrium) { 0.001 }

    let(:elements) { [
      { min: 0, max: 0.001, value: 0.0004, static: true },
      { min: 0, max: 0.001, value: 0.0005 },
      { min: 0, max: 0.001, value: 0 }
    ] }

    it 'does not change the constant' do
      expect(values[0]).to eq(0.0004)
    end

    it 'changes the first variable from 0.0005->0.00055' do
      expect(values[1]).to eq(0.00055)
    end

    it 'changes the second variable from 0->0.00005' do
      expect(values[2]).to eq(0.00005)
    end
  end # With min/max of 0/0.001

  # --------------------------------------------------------------------------

  describe 'With min/max of 0/50' do
    # Asserts that elements which have reached their maximum or minimum are
    # excluded from the cumulative delta calculation in future iterations.
    let(:elements) { [
      { min: 0, max: 50, value: 40 },
      { min: 0, max: 50, value:  0 },
      { min: 0, max: 50, value:  0 }
    ] }

    it 'sets the first variable to 50' do
      expect(values[0]).to eq(50)
    end

    it 'sets the second variable to 25' do
      expect(values[1]).to eq(25)
    end

    it 'sets the third variable to 25' do
      expect(values[2]).to eq(25)
    end
  end

  # --------------------------------------------------------------------------

  describe 'With irregular values' do
    let(:elements) { [
      { min: 0, max: 100, value: 89.99, static: true },
      { min: 0, max: 0.000021, value: 0.00001 },
      { min: 0, max: 100, value: 0.045 },
      { min: 0, max: 100, value: 10.005 },
      { min: 0, max: 100, value: 0.04999 }
    ] }

    context 'given (89.88999...*, ...)' do
      let(:elements) do
        super().tap { |e| e[0][:value] = 89.889999999999999999999999 }
      end

      it 'does not raise a CannotBalanceError' do
        expect { values }.to_not raise_error
      end
    end # given (89.88999...*, ...)

    context 'given 89.999...*, ...)' do
      let(:elements) do
        super().tap { |e| e[0][:value] = 89.999999999999999999999999 }
      end

      it 'does not raise a CannotBalanceError' do
        expect { values }.to_not raise_error
      end
    end # given 89.999...*, ...)

    context 'given (99*, ...)' do
      let(:elements) do
        super().tap { |e| e[0][:value] = 99 }
      end

      it 'does not raise a CannotBalanceError' do
        expect { values }.to_not raise_error
      end
    end # given (99*, ...)
  end # With irregular values

end # Osmosis::Balancer
