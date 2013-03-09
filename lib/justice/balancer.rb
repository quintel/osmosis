module Justice
  # Balances a group of elements so that the sum of their values "balances" to
  # a chosen equilibrium.
  #
  # If you wish to provide a hash as input (to more easily associate each
  # balanced value with the input), use HashBalancer instead.
  class Balancer
    # Public: Creates a new Balancer instance.
    #
    # elements    - An array of hashes, each containing an item which may be
    #               used by the balancer to reach the equilibrium.
    # equilibrium - The value to which you want the elements to sum.
    #
    # Returns a Balancer.
    def initialize(elements, equilibrium = 100)
      @elements = elements.map do |data|
        values = data.values_at(:min, :max, :value)

        if data[:static] || data[:min] == data[:max]
          Constant.new(*values)
        else
          Variable.new(*values)
        end
      end

      @equilibrium = Justice.obj_to_d(equilibrium)
    end

    # Public: A human-readable version of the Balancer.
    #
    # Returns a string.
    def inspect
      "#<#{ self.class.name } equilibrium=#{ '%f' % @equilibrium }>"
    end

    # Public: Balances the elements so that they sum to the equilibrium.
    #
    # For example:
    #
    #   balancer = HashBalancer.new([
    #     { min: 0, max: 100, value: 75, static: true },
    #     { min: 0, max: 100, :value  0 }
    #   ])
    #
    #   balancer.balanced
    #   # => [ 75, 25 ]
    #
    # Returns an array values, in the same order as those given when the
    # balancer was initialized.
    def balanced
      variables, constants = @elements.partition { |el| el.is_a?(Variable) }

      if variables.empty?
        # Having no variables is fine if the values already balance.
        return balances? ? values : raise(NoVariablesError.new(self))
      end

      # Flex is the amount of "value" which needs to be adjusted for. For 
      # example, if a group of element which sum to 100 has one element
      # increased by 20, the new sum is 120. The flex is therefore -20
      # indicating that the group needs to be reduced by 20 to compensate.
      flex = @equilibrium - Justice.sum(values)

      iteration_els = variables.dup

      10.times do |iteration|
        next_els    = []
        start_flex  = flex
        delta       = Justice.sum(variables.map(&:delta))
        brute_force = false

        if start_flex.abs < (delta * 0.0001) || iteration == 9
          # Assign flex first to the element with the most headroom.
          iteration_els.sort_by! do |element|
            -element.headroom(flex < 0 ? :down : :up)
          end

          brute_force = true
        end

        iteration_els.each do |element|
          if brute_force
            # Brute-force balancing: If the flex per element is too small
            # (<0.001% of the delta) we try to assign the full amount to an
            # element. This prevents running out of iterations as we divide into
            # ever smaller flexes.
            flex_per_element = start_flex
          else
            # Fair, round-robin balancing: The amount of flex given to each
            # element is calculated for each one separately, since a previous
            # iteration may have used all all of the flex due to rounding.
            flex_per_element = start_flex * (element.delta / delta)
          end

          prev_value    = element.value
          element.value = prev_value + flex_per_element
          new_value     = element.value

          flex       -= new_value - prev_value
          start_flex -= new_value - prev_value if brute_force

          # Finally, if this element can still be changed further, it may be
          # used again in the next iteration.
          if element.can_change?(flex < 0 ? :down : :up)
            next_els.push(element)
          end
        end # iteration_els.each ...

        # These elements will be used next time around...
        iteration_els = next_els

        # If the flex was all used up, or wasn't changed, don't waste time
        # with more iterations.
        break if flex.zero? || flex == start_flex
      end

      unless flex.zero?
        raise CannotBalanceError.new(self)
      end

      values
    end

    #######
    private
    #######

    # Internal: Do the element values sum to the equilibrium?
    #
    # Returns true or false.
    def balances?
      Justice.sum(values) == @equilibrium
    end

    # Internal: Creates an array containing all the current element values.
    #
    # Returns an array of numerics.
    def values
      @elements.map(&:value)
    end
  end
end # Justice
