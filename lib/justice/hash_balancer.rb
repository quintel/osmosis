module Justice
  # Balances a group of elements so that the sum of their values "balances" to
  # a chosen equilibrium.
  #
  # Takes a hash as input, whereas Balancer takes an array.
  class HashBalancer
    # Public: Creates a new HashBalancer instance.
    #
    # elements    - A hash of hashes, each containing an item which may be
    #               used by the balancer to reach the equilibrium.
    # equilibrium - The value to which you want the elements to sum.
    #
    # Returns a Balancer.
    def initialize(elements, equilibrium = 100)
      @elements    = elements
      @equilibrium = equilibrium
    end

    # Public: Balances the elements so that they sum to the equilibrium.
    #
    # For example:
    #
    #   balancer = HashBalancer.new({
    #     a: { min: 0, max: 100, value: 75, static: true },
    #     b: { min: 0, max: 100, :value  0 }
    #   })
    #
    #   balancer.balanced
    #   # => { a: 75, b: 25 }
    #
    # Returns a hash of values, each one corresponding to the same key given
    # to HashBalancer when initialized.
    def balanced
      Hash[ @elements.keys.zip(
        Balancer.new(@elements.values, @equilibrium).balanced
      ) ]
    end

    # Public: A human-readable version of the Balancer.
    #
    # Returns a string.
    def inspect
      "#<#{ self.class.name } equilibrium=#{ '%f' % @equilibrium }>"
    end
  end # HashBalancer
end # Justice
