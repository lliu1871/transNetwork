# Summary and Parameter Estimation for BetNet Output

Processes MCMC output from BetNet, generates convergence plots,
calculates posterior means for parameters, reconstructs the most likely
transmission network, and identifies direct transmission events.

## Usage

``` r
summary_betnet(
  betnet_output_file,
  snp_file,
  time_file,
  burnin = 0.1,
  genome_size = 1e+06,
  plot = TRUE
)
```

## Arguments

- betnet_output_file:

  String. Path to the CSV output from BetNet.

- snp_file:

  String. Path to the CSV file containing observed SNP differences.

- time_file:

  String. Path to the CSV file containing onsite and removal times.

- burnin:

  Numeric. Proportion of initial iterations to discard (default 0.1).

- genome_size:

  Numeric. Size of the genome in base pairs (default 1,000,000).

- plot:

  Logical. If TRUE, displays MCMC trace plots.

## Value

A list containing:

- `theta`: Posterior mean of the theta parameter.

- `mu`: Posterior mean of the mutation rate.

- `infrate`: Posterior mean of the infection rate.

- `transmission`: A data frame of the reconstructed transmission
  network.
