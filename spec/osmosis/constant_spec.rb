require 'spec_helper'

describe Osmosis::Constant do
  include_examples 'a constant'

  describe 'setting a new value' do
    it 'is not allowed' do
      expect { described_class.new(0, 50, 25).value = 40 }.to raise_error
    end
  end # setting a new value

  it 'is a constant' do
    expect(described_class.new(0, 50, 20)).to be_constant
  end

  it 'is not variable' do
    expect(described_class.new(0, 50, 20)).to_not be_variable
  end
end # Osmosis::Constant
