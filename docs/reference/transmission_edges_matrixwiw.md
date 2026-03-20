# Convert Who-Infected-Who Matrix to Edge List

Takes a posterior probability matrix and identifies the most likely
infector for each case (infectee) based on the highest posterior
probability.

## Usage

``` r
transmission_edges_matrixwiw(matrix_wiw)
```

## Arguments

- matrix_wiw:

  A numeric matrix where `matrix_wiw[i, j]` is the probability that
  individual `i` infected individual `j`. Rows should represent
  potential infectors and columns represent infectees.

## Value

A data frame with three columns:

- `infectee`: Character ID of the case.

- `infector`: Character ID of the most likely infector (NA if
  unknown/zero prob).

- `prob`: The posterior probability associated with that edge.
