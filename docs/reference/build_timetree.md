# Build a Time Tree via Neighbor-Joining

Constructs a phylogenetic time tree from an outbreak matrix by
calculating pairwise transmission distances and applying the
Neighbor-Joining algorithm.

## Usage

``` r
build_timetree(outbreak, root = 1, plot = FALSE, ...)
```

## Arguments

- outbreak:

  A data frame with 'id', 'parent_id', 'infection_time', and
  'removal_time'.

- root:

  Integer or Character. The ID of the node to use as the root (usually
  the index case).

- plot:

  Logical. If TRUE, plots the resulting phylogeny.

- ...:

  Additional arguments passed to
  [`ape::plot.phylo`](https://rdrr.io/pkg/ape/man/plot.phylo.html).

## Value

An object of class `phylo` (invisibly).
