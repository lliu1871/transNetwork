#' Summary and Parameter Estimation for BetNet Output
#'
#' Processes MCMC output from BetNet, generates convergence plots, 
#' calculates posterior means for parameters, and reconstructs the 
#' most likely transmission network.
#'
#' @param betnet_output_file String. Path to the CSV output from BetNet.
#' @param burnin Numeric. Proportion of initial iterations to discard (default 0.1).
#' @param onsite_time Numeric vector. Onsite times for cases in the outbreak.
#' @param removal_time Numeric vector. Removal times for cases in the outbreak.
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
summary_betnet <- function(betnet_output_file, burnin = 0.1, onsite_time, removal_time, plot = TRUE) {
  output <- read.csv(betnet_output_file)
  numcase <- (dim(output)[2] - 6) / 2
  transmission <- data.frame(
    id = integer(numcase),
    parent_id = integer(numcase),
    infection_time = numeric(numcase),
    latent_period = numeric(numcase),
    onsite_time = numeric(numcase),
    infectious_period = numeric(numcase),
    removal_time = numeric(numcase),
    infector_post_probability = numeric(numcase),
    stringsAsFactors = FALSE
  )
  transmission$onsite_time <- onsite_time
  transmission$removal_time <- removal_time

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
  transmission$id <- as.numeric(x[, 1])
  transmission$parent_id <- as.numeric(x[, 2])
  transmission$infector_post_probability <- x[, 3]

  inftime <- rep(0, numcase)
  for (j in 2:numcase) {
    infection_time <- post_sample[, 6 + numcase + j]
    infector <- transmission$parent_id[j]
    index <- which(post_sample[, 6 + j] == infector)
    inftime[j] <- mean(infection_time[index])
  }
  transmission$infection_time <- inftime
  transmission$latent_period <- transmission$onsite_time - transmission$infection_time
  transmission$infectious_period <- transmission$removal_time - transmission$onsite_time
  list(theta = theta_est, mu = mu_est, infrate = infrate_est, transmission = transmission)
}

