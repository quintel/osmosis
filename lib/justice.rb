require 'rational'

require 'justice/balancer'
require 'justice/constant'
require 'justice/errors'
require 'justice/hash_balancer'
require 'justice/variable'
require 'justice/version'

module Justice
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
end
