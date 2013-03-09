module Justice
  # Error class which serves as a base for all errors which occur in Justice.
  JusticeError = Class.new(StandardError)

  # Internal: Creates a new error class which inherits from JusticeError,
  # whose message is created by evaluating the block you give.
  #
  # For example
  #
  #   MyError = error_class do |weight, limit|
  #     "#{ weight } exceeds #{ limit }"
  #   end
  #
  #   raise MyError.new(5000, 2500)
  #   # => #<Justice::MyError: 5000 exceeds 2500>
  #
  # Returns an exception class.
  def self.error_class(superclass = JusticeError, &block)
    Class.new(superclass) do
      def initialize(*args) ; super(make_message(*args)) ; end
      define_method(:make_message, &block)
    end
  end

  # Raised when the group of elements cannot be balanced.
  CannotBalanceError = error_class do |*|
    "?!"
  end

  # Raised when the group of elements does not balance, and there are no
  # variables which can be changed.
  NoVariablesError = error_class do |*|
    "?!"
  end
end # Justice
