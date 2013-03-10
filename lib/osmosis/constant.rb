module Osmosis
  class Constant
    # Public: The minimum value to which the variable may be set.
    #
    # Returns a numeric.
    attr_reader :min

    # Public: The maximum value to which the variable may be set.
    #
    # Returns a numeric.
    attr_reader :max

    # Public: The current value of the variable.
    #
    # Returns a numeric.
    attr_reader :value

    # Public: Creates a new Variable.
    #
    # min   - The minimum value to which the variable may be set.
    # max   - The maximum value to which the variable may be set.
    # value - The starting value of the variable.
    #
    # Returns a Variable.
    def initialize(min, max, value)
      @min   = Osmosis.obj_to_d(min)
      @max   = Osmosis.obj_to_d(max)
      @value = Osmosis.obj_to_d(value)
    end

    # Public: The difference between the minimum and maximum values.
    #
    # Returns a numeric.
    def delta
      @delta ||= @max - @min
    end

    # Public: Does this object have a fixed value which may not be changed?
    #
    # Returns true or false.
    def constant?
      true
    end

    # Public: Is the balancer permitted to change the value of this object?
    #
    # Returns true or false.
    def variable?
      not constant?
    end

    # Public: A human-readable version of the variable.
    #
    # Returns a string.
    def inspect
      attributes = [ :min, :max, :value ].map do |attribute|
        "#{ attribute }=#{ '%f' % public_send(attribute) }"
      end

      "#<#{ self.class.name } #{ attributes.join(' ' ) }>"
    end

    # Public: A string version of the variable.
    #
    # Returns a string.
    def to_s
      @value.to_f.to_s
    end

    #######
    private
    #######

    # Public: Sets the value of the variable.
    #
    # If the value is less than the minimum, the minimum is used. Likewise,
    # if the value exceeds the maximum, the maximum will be used instead.
    #
    # value - The value to set.
    #
    # Returns the value you gave (even if a different one was set).
    def value=(new_value)
      if new_value > @max
        @value = @max
      elsif new_value < @min
        @value = @min
      else
        @value = Osmosis.obj_to_d(new_value)
      end
    end
  end # Constant
end # Osmosis
