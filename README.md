# Osmosis [![Build Status](https://travis-ci.org/quintel/osmosis.png?branch=master)](https://travis-ci.org/quintel/osmosis)

Full README coming soon; for the moment this is mostly [readme-driven
development][rdd]. Osmosis is an extraction of the ETengine balancer so that
it may be used in other Ruby applications.

```ruby
# The equilibrium is 100, while the values sum to 110. Therefore the excess
# is 10. The first input (with value=50) is static so, Osmosis is disallowed
# from changing its value.
Osmosis.balance([
  { min: 0.0, max: 100.0, value: 50.0, static: true },
  { min: 0.0, max: 100.0, value: 20.0 },
  { min: 0.0, max: 100.0, value: 40.0 }
], 100.0)

# => [ 50.0, 15.0, 35.0 ]
```

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
