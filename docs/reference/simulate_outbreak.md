# Simulate a Stochastic Outbreak

Simulates an infectious disease outbreak using a branching process. Each
individual has a latent period, an onsite time, and an infectious period
followed by removal.

## Usage

``` r
simulate_outbreak(
  initial_infection_time = 0,
  infection_rate = 2,
  removal_rate = 2,
  latent_mean = 0.2,
  target_size = 50
)
```

## Arguments

- initial_infection_time:

  Numeric. The time the first case is infected (default 0).

- infection_rate:

  Numeric. The rate of secondary infections per unit of time.

- removal_rate:

  Numeric. The rate of removal from the infectious state.

- latent_mean:

  Numeric. The degrees of freedom for the chi-square distribution of the
  latent period.

- target_size:

  Integer. The minimum number of cases required for a successful
  simulation.

## Value

A data frame (outbreak matrix) with `target_size` rows and columns for
IDs, times (infection, onsite, removal), and periods (latent,
infectious).
