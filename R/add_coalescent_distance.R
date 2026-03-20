#' Add Coalescent Lag to Transmission Distances
#'
#' Augments a transmission distance matrix with stochastic coalescent distances 
#' to simulate the divergence between a transmission tree and a gene tree.
#'
#' @param pairwise_dist A symmetric numeric matrix of transmission distances.
#' @param theta Numeric. The population size parameter (mean of the coalescent distance).
#'
#' @return A symmetric numeric matrix where each entry $(i, j)$ is the sum of 
#'   the transmission distance and a simulated coalescent lag.
#' 
#' @importFrom stats rexp
#' @export
add_coalescent_distance <- function(pairwise_dist, theta) {
  ncase <- dim(pairwise_dist)[1]
  coal_distance <- matrix(rexp(ncase * ncase, 1 / theta), nrow = ncase, ncol = ncase)
  coal_distance <- coal_distance + t(coal_distance)
  distance <- pairwise_dist + coal_distance
  diag(distance) <- 0.0
  distance
}
