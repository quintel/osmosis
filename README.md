# Osmosis [![Build Status](https://travis-ci.org/quintel/osmosis.png?branch=master)](https://travis-ci.org/quintel/osmosis)

Osmosis is a small Ruby library which, given a set of values, adjusts these
values so that they sum to a chosen "equilibrium". This allows you to balance
your set of numbers by redistributing any excess or deficit.

```ruby
Osmosis.balance([
  { min: 0, max: 100, value: 25 },
  { min: 0, max: 100, value: 25 }
], 100.0)

# => [ 50, 50 ]
```

This is a simple example, but Osmosis provides support for a number of
additional features which can make your life easier.

Osmosis uses Ruby's "Rational" library to eliminate floating point errors in
its calculations.

### Static values

You can instruct Osmosis that it may not alter one or more of the values you
provide:

```ruby
Osmosis.balance([
  { min: 0, max: 100, value: 50, static: true },
  { min: 0, max: 100, value: 15, static: true }
  { min: 0, max: 100, value:  0 }
], 100.0)

# => [ 50, 15, 35 ]
```

### Minimum and maximum values

Each value you want to be "balanced" by Osmosis has a minimum and maximum;
these indicate the range of acceptable values which Osmosis may assign. The
example above was simplistic because we only had to assign 25 to each value
for the group to balance. What if the initial values were such that Osmosis
couldn't assign 25 to one of them?

```ruby
Osmosis.balance([
  { min: 0, max: 50, value: 40 },
  { min: 0, max: 50, value:  0 },
  { min: 0, max: 50, value:  0 },
], 100.0).inspect

# => [ 50, 25, 25 ]
```

The initial values here sum to 40, and we direct Osmosis to balance the group
at the equilibrium 100. To assign fairly, each value would be assigned an
additional 20, but the first element will only accept an additional 10.
Therefore 10 is added to the first value, and the remaining amount, 50, is
split equally between the remaining elements.

Excesses or deficits are assigned to each element fairly based on the
difference the minimum and maximum:

```ruby
Osmosis.balance([
  { min: 0, max: 100, value: 80, static: true },
  { min: 0, max:  40, value:  0 },
  { min: 0, max:  10, value:  0 }
], 100.0)

# => [ 80, 16, 4 ]
```

### Associating values with a key

Rather than associating the balanced values by index, you can supply a hash
when balancing and a hash of new values will be returned using the same keys:

```ruby
Osmosis.balance({
  first:  { min: 0.0, max: 100.0, value: 50.0, static: true },
  second: { min: 0.0, max: 100.0, value: 20.0 },
  third:  { min: 0.0, max: 100.0, value: 40.0 }
}, 100.0)

# => { first: 50.0, second: 15.0, third: 35.0 }
```

[rdd]: http://tom.preston-werner.com/2010/08/23/readme-driven-development.html
