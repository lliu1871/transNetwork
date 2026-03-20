# Plot Transmission Networks

Visualizes a transmission matrix as a network graph, a rooted tree, or a
timeline, depending on the chosen style.

## Usage

``` r
transplot(
  transmission,
  style = 1,
  vertex_colors = rep("lightblue", length(transmission[, 1])),
  vertex_sizes = rep(12, length(transmission[, 1])),
  vertex_label_cex = rep(1.5, length(transmission[, 1])),
  showlabel = TRUE,
  dateLastSample = 2008
)
```

## Arguments

- transmission:

  A data frame representing the transmission matrix. Must contain
  'parent_id', 'id', and 'infector_post_probability'.

- style:

  Integer. 1 for standard network, 2 for rooted tree, 3 for timeline, 4
  for detailed transmission plot.

- vertex_colors:

  Character vector of colors for the nodes.

- vertex_sizes:

  Numeric vector of node sizes.

- vertex_label_cex:

  Numeric vector for vertex label scaling.

- showlabel:

  Logical. If TRUE, displays probability weights on edges.

- dateLastSample:

  Numeric. The reference year/date for timeline styles.

## Value

The function primarily produces a plot to the active graphics device. It
returns `NULL` invisibly.
