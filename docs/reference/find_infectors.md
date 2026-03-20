# Trace Infection Ancestry

Traverses the transmission chain upwards from a specific individual to
identify all direct and indirect infectors (ancestors).

## Usage

``` r
find_infectors(outbreak, id, include_self = TRUE)
```

## Arguments

- outbreak:

  A data frame containing at least `id` and `parent_id`.

- id:

  Integer. The ID of the individual to trace.

- include_self:

  Logical. If TRUE, the returned vector starts with `id`.

## Value

An integer vector of IDs representing the ancestry chain, ordered from
the individual/parent up to the index case (root).
