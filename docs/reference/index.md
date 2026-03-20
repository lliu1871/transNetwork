# Package index

## Simulation

Functions for generating stochastic outbreaks and trees.

- [`simulate_outbreak()`](https://lliu1871.github.io/transNetwork/reference/simulate_outbreak.md)
  : Simulate a Stochastic Outbreak
- [`build_timetree()`](https://lliu1871.github.io/transNetwork/reference/build_timetree.md)
  : Build a Time Tree via Neighbor-Joining
- [`sim_phytree()`](https://lliu1871.github.io/transNetwork/reference/sim_phytree.md)
  : Simulate a Phylogenetic Tree from a Time Tree
- [`add_coalescent_distance()`](https://lliu1871.github.io/transNetwork/reference/add_coalescent_distance.md)
  : Add Coalescent Lag to Transmission Distances

## Analysis & Metrics

Tools for summarizing MCMC output and calculating distances.

- [`summary_betnet()`](https://lliu1871.github.io/transNetwork/reference/summary_betnet.md)
  : Summary and Parameter Estimation for BetNet Output
- [`find_mrci()`](https://lliu1871.github.io/transNetwork/reference/find_mrci.md)
  : Find the Most Recent Common Infector (MRCI)
- [`find_infectors()`](https://lliu1871.github.io/transNetwork/reference/find_infectors.md)
  : Trace Infection Ancestry
- [`find_all_pairwise_distances()`](https://lliu1871.github.io/transNetwork/reference/find_all_pairwise_distances.md)
  : Compute All Pairwise Transmission Distances

## Data Conversion

Internal utilities for formatting and transforming data.

- [`transmission_edges_matrixwiw()`](https://lliu1871.github.io/transNetwork/reference/transmission_edges_matrixwiw.md)
  : Convert Who-Infected-Who Matrix to Edge List
- [`ttree_from_transmission()`](https://lliu1871.github.io/transNetwork/reference/ttree_from_transmission.md)
  : Convert Outbreak Data to a ttree Object

## Visualization

Plotting transmission networks and timelines.

- [`transplot()`](https://lliu1871.github.io/transNetwork/reference/transplot.md)
  : Plot Transmission Networks
