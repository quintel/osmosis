require 'spec_helper'

describe Justice::Constant do
  include_examples 'a constant'

  describe 'setting a new value' do
    it 'is not allowed' do
      expect { described_class.new(0, 50, 25).value = 40 }.to raise_error
    end
  end # setting a new value
end # Justice::Constant
