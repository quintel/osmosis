module Justice
  # Represents a element whose value may be altered by the Balancer in order
  # to reach an equilibrium.
  class Variable
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
      @min = obj_to_d(min)
      @max = obj_to_d(max)

      self.value = value
    end

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
        @value = obj_to_d(new_value)
      end
    end

    # Public: Determines if the variable value can be changed.
    #
    # direction - The direction in which you want to change the variable. :up
    #             or :down.
    #
    # Returns true or false.
    def can_change?(direction)
      not headroom(direction).zero?
    end

    # Public: The amount by which the variable value can be changed in the
    # given +direction+.
    #
    # direction - The direction in which you want to change the variable. :up
    #             or :down.
    #
    # For example:
    #
    #   # We want to move the input up; current value of 48, maximum of 50.
    #   variable.headroom(:up) # => 2.0
    #
    #   # We want to move the input down; current value of 2, minimum of -100.
    #   variable.headroom(:down) # => 102.0
    #
    # Returns a numeric.
    def headroom(direction)
      ((direction == :up ? @max : @min) - @value).abs
    end

    # Public: The difference between the minimum and maximum values.
    #
    # Returns a numeric.
    def delta
      @delta ||= @max - @min
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

    # Internal: Given an object, tries to convert it to a BigDecimal.
    #
    # Returns a BigDecimal, or the +object+ if it could not be coerced.
    def obj_to_d(object)
      object.respond_to?(:to_d) ? object.to_d : object
    end
  end # Variable
end # Justice
