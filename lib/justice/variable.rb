module Justice
  # Represents a element whose value may be altered by the Balancer in order
  # to reach an equilibrium.
  class Variable < Constant
    # Public: Sets the value of the variable.
    #
    # See Constant#value=
    public :value=

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
  end # Variable
end # Justice
