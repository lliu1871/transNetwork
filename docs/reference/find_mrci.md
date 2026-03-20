# Find the Most Recent Common Infector (MRCI)

Identifies the shared infector between two individuals in an outbreak
and calculates the transmission distance between them.

## Usage

``` r
find_mrci(outbreak, id1, id2, include_self = TRUE)
```

## Arguments

- outbreak:

  A data frame containing 'id', 'parent_id', 'infection_time', and
  'removal_time'.

- id1:

  Integer/Character ID of the first individual.

- id2:

  Integer/Character ID of the second individual.

- include_self:

  Logical. If TRUE, the search for a common infector includes the
  individuals themselves.

## Value

A list containing:

- `mrci`: The ID of the most recent common infector (NA if no shared
  infector exists).

- `distance`: The calculated temporal distance between the two
  individuals.
