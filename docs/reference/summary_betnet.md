# Summary and Parameter Estimation for BetNet Output

Processes MCMC output from BetNet, generates convergence plots,
calculates posterior means for parameters, and reconstructs the most
likely transmission network.

## Usage

``` r
summary_betnet(
  betnet_output_file,
  burnin = 0.1,
  onsite_time,
  removal_time,
  plot = TRUE
)
```

## Arguments

- betnet_output_file:

  String. Path to the CSV output from BetNet.

- burnin:

  Numeric. Proportion of initial iterations to discard (default 0.1).

- onsite_time:

  Numeric vector. Onsite times for cases in the outbreak.

- removal_time:

  Numeric vector. Removal times for cases in the outbreak.

- plot:

  Logical. If TRUE, displays MCMC trace plots.

## Value

A list containing:

- `theta`: Posterior mean of the theta parameter.

- `mu`: Posterior mean of the mutation rate.

- `infrate`: Posterior mean of the infection rate.

- `transmission`: A data frame of the reconstructed transmission
  network.
