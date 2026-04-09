#' Summary and Parameter Estimation for BetNet Output
#'
#' Processes MCMC output from BetNet, generates convergence plots,
#' calculates posterior means for parameters, reconstructs the
#' most likely transmission network, and identifies direct transmission events.
#'
#' @param betnet_output_file String. Path to the CSV output from BetNet.
#' @param snp_file String. Path to the CSV file containing observed SNP differences.
#' @param time_file String. Path to the CSV file containing onsite and removal times.
#' @param burnin Numeric. Proportion of initial iterations to discard (default 0.1).
#' @param genome_size Numeric. Size of the genome in base pairs (default 1,000,000).
#' @param plot Logical. If TRUE, displays MCMC trace plots.
#'
#' @return A list containing:
#' \itemize{
#'   \item \code{theta}: Posterior mean of the theta parameter.
#'   \item \code{mu}: Posterior mean of the mutation rate.
#'   \item \code{infrate}: Posterior mean of the infection rate.
#'   \item \code{transmission}: A data frame of the reconstructed transmission network.
#' }
#' @importFrom utils read.csv
#' @importFrom graphics par plot
#' @export
summary_betnet <- function(betnet_output_file, snp_file, time_file, burnin = 0.1, genome_size = 1000000, plot = TRUE) {
  tempdata <- read.csv(time_file)
  snp <- read.csv(snp_file)
  output <- read.csv(betnet_output_file)
  numcase <- (dim(output)[2] - 6) / 2
  transmission <- data.frame(
    infectee = integer(numcase),
    infector = integer(numcase),
    infection_time = numeric(numcase),
    latent_period = numeric(numcase),
    onsite_time = numeric(numcase),
    infectious_period = numeric(numcase),
    removal_time = numeric(numcase),
    prob = numeric(numcase),
    obs_snp = numeric(numcase),
    threshold = numeric(numcase),
    direct_transmission = logical(numcase),
    stringsAsFactors = FALSE
  )
  transmission$onsite_time <- tempdata$onsite_time
  transmission$removal_time <- tempdata$removal_time

  # convergence plots
  if (plot) {
    par(mfrow = c(2, 2))
    plot(output$logLikelihood, type = "l", xlab = "iteration", ylab = "loglikelihood")
    plot(output$theta, type = "l", xlab = "iteration", ylab = "theta")
    plot(output$mu, type = "l", xlab = "iteration", ylab = "mutation rate")
    plot(output$infection_rate, type = "l", xlab = "iteration", ylab = "infection rate")
    par(mfrow = c(1, 1))
  }

  # parameter estimates
  post_sample <- output[(floor(dim(output)[1] * burnin) + 1):dim(output)[1], ]
  theta_est <- mean(post_sample$theta)
  mu_est <- mean(post_sample$mu)
  infrate_est <- mean(post_sample$infection_rate)

  # infector posterior probabilities
  mat <- matrix(0, numcase, numcase)
  for (i in 2:numcase) {
    x <- table(post_sample[, 6 + i])
    mat[as.numeric(names(x)), i] <- x / sum(x)
  }
  x <- transmission_edges_matrixwiw(mat)
  transmission$infectee <- as.numeric(x[, 1])
  transmission$infector <- as.numeric(x[, 2])
  transmission$prob <- x[, 3]

  inftime <- rep(0, numcase)
  for (j in 2:numcase) {
    infection_time <- post_sample[, 6 + numcase + j]
    infector <- transmission$infector[j]
    index <- which(post_sample[, 6 + j] == infector)
    inftime[j] <- mean(infection_time[index])
  }
  transmission$infection_time <- inftime
  transmission$latent_period <- transmission$onsite_time - transmission$infection_time
  transmission$infectious_period <- transmission$removal_time - transmission$onsite_time

  infectee <- transmission$infectee[-1]
  infector <- transmission$infector[-1]
  
  # maximum divergence time for a direct transmission
  divergence_time <- transmission$removal_time[infector] + transmission$removal_time[infectee] - 2 * transmission$infection_time[infector]
  prob_mutation <- 3 / 4 - 3 / 4 * exp(-mu_est * divergence_time)
  expected_snp <- genome_size * prob_mutation
  transmission$obs_snp[2:numcase] <- snp[cbind(infectee, infector)]
  transmission$threshold[2:numcase] <- qbinom(0.95, size = genome_size, prob = prob_mutation)
  transmission$direct_transmission[2:numcase] <- (transmission$obs_snp[2:numcase] < transmission$threshold[2:numcase])
  transmission$direct_transmission[1] <- NA
  transmission$threshold[1] <- NA
  transmission$obs_snp[1] <- NA
  list(theta = theta_est, mu = mu_est, infrate = infrate_est, transmission = transmission)
}
