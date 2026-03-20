# transNetwork \<img src=“man/figures/logo.png” align=“right” height=“139” /\>

Since your package is now passing all checks, a solid **README.md** is
the final step to make it accessible to your collaborators and the wider
research community. This file will serve as the “front door” of your
project on GitHub.

Create a file named `README.md` in your package’s root directory and
paste the following content:

------------------------------------------------------------------------

[](https://www.google.com/search?q=https://github.com/lliu1871/transNetwork/actions)
The goal of **transNetwork** is to provide a unified framework for
simulating, reconstructing, and visualizing infectious disease
transmission networks using genomic and epidemiological data.

## Features

- **Simulation**: Generate stochastic outbreaks with custom latent and
  infectious periods.
- **Reconstruction**: Build transmission trees from MCMC output
  (BetNet).
- **Phylogenetics**: Convert transmission histories into phylogenetic
  “gene trees” using the multispecies coalescent.
- **Metrics**: Calculate pairwise transmission distances and Most Recent
  Common Infectors (MRCI).
- **Visualization**: High-level plotting functions for networks,
  timelines, and trees.

## Installation

You can install the development version of **transNetwork** from
[GitHub](https://www.google.com/search?q=https://github.com/lliu1871/transNetwork)
with:

``` r
# install.packages("devtools")
devtools::install_github("lliu1871/transNetwork")
```

*Note: This will automatically install the necessary dependencies,
including `ape`, `igraph`, and `phybase`.*

## Quick Start

Here is a basic example of how to simulate an outbreak and visualize the
transmission network:

``` r
library(transNetwork)

# 1. Simulate an outbreak of 50 individuals
outbreak_data <- simulate_outbreak(target_size = 50, infection_rate = 1.5)

# 2. Build a time tree from the transmission distances
time_tree <- build_timetree(outbreak_data, plot = TRUE)

# 3. Plot the detailed transmission network
transplot(outbreak_data, style = 1)
```

## Research Context

This package was developed for academic researchers in **evolutionary
genomics** and **phylogenetics**. It specifically addresses the
“coalescent lag” between transmission events and genetic divergence,
allowing for more accurate benchmarking of molecular clock models in
outbreak settings.

------------------------------------------------------------------------
