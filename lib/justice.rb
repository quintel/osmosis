require 'rational'

require 'justice/balancer'
require 'justice/constant'
require 'justice/errors'
require 'justice/hash_balancer'
require 'justice/variable'
require 'justice/version'

module Justice
  # Public: Balances the given values.
  #
  # elements    - An array or hash containing hashes, each of which is item to
  #               be used by the balancer to reach the equilibrium.
  # equilibrium - The value to which you want the elements to sum.
  #
  # For example, with an array:
  #
  #   balancer = HashBalancer.new([
  #     { min: 0, max: 100, value: 75, static: true },
  #     { min: 0, max: 100, :value  0 }
  #   ])
  #
  #   balancer.balanced
  #   # => [ 75, 25 ]
  #
  # Or with a hash:
  #
  #   balancer = HashBalancer.new({
  #     a: { min: 0, max: 100, value: 75, static: true },
  #     b: { min: 0, max: 100, :value  0 }
  #   })
  #
  #   balancer.balanced
  #   # => { a: 75, b: 25 }
  #
  # Returns an array or hash, depending on what you provided.
  def self.balance(values, equilibrium = 100)
    klass = values.is_a?(Hash) ? HashBalancer : Balancer
    klass.new(values, equilibrium).balanced
  end

  # Internal: Given an object, tries to convert it to a BigDecimal.
  #
  # Returns a BigDecimal, or the +object+ if it could not be coerced.
  def self.obj_to_d(object)
    Rational(object.to_s)
  end

  # Internal: Sums an array of numerics.
  #
  # Returns a numeric.
  def self.sum(values)
    values.inject(Justice.obj_to_d(0)) { |sum, value| sum + value }
  end
end # Justice
