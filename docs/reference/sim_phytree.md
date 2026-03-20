# Simulate a Phylogenetic Tree from a Time Tree

Converts an epidemiological time tree into a phylogenetic tree by
scaling branch lengths by a mutation rate and optionally simulating the
coalescent process using the multispecies coalescent framework.

## Usage

``` r
sim_phytree(timetree, murate = 0, theta = 0)
```

## Arguments

- timetree:

  An object of class `phylo` (from the `ape` package).

- murate:

  Numeric. Mutation rate used to scale the time tree branch lengths.

- theta:

  Numeric. Population size parameter for the coalescent simulation. If
  0, a simple scaling is performed.

## Value

An object of class `phylo` representing the simulated gene tree.
