# Compute All Pairwise Transmission Distances

Calculates the temporal distance between every pair of individuals in an
outbreak based on their Most Recent Common Infector (MRCI).

## Usage

``` r
find_all_pairwise_distances(outbreak, return_matrix = TRUE)
```

## Arguments

- outbreak:

  A data frame with 'infectee', 'infector', 'infection_time', and
  'removal_time'.

- return_matrix:

  Logical. If TRUE (default), returns a symmetric \$nxn\$ numeric
  matrix. If FALSE, returns a long-format data frame.

## Value

If `return_matrix` is TRUE, a symmetric `matrix`. Otherwise, a
`data.frame` containing columns for both IDs, the shared infector, the
infector's infection time, and the calculated distance.
