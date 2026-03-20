# Convert Outbreak Data to a ttree Object

Transforms an outbreak data frame into a structured `ttree` list
suitable for transmission tree plotting.

## Usage

``` r
ttree_from_transmission(outbreak, dateLastSample)
```

## Arguments

- outbreak:

  A data frame containing at least: `removal_time`, `infectious_period`,
  `latent_period`, `parent_id`, and `id`.

- dateLastSample:

  Numeric. The calendar date (e.g., 2024.5) corresponding to the maximum
  removal time in the dataset.

## Value

A list of class `ttree` containing:

- `ttree`: A matrix with columns for infection time, removal time, and
  parent ID.

- `nam`: A character vector of individual IDs.
