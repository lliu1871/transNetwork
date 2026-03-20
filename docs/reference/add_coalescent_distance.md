# Add Coalescent Lag to Transmission Distances

Augments a transmission distance matrix with stochastic coalescent
distances to simulate the divergence between a transmission tree and a
gene tree.

## Usage

``` r
add_coalescent_distance(pairwise_dist, theta)
```

## Arguments

- pairwise_dist:

  A symmetric numeric matrix of transmission distances.

- theta:

  Numeric. The population size parameter (mean of the coalescent
  distance).

## Value

A symmetric numeric matrix where each entry \$(i, j)\$ is the sum of the
transmission distance and a simulated coalescent lag.
