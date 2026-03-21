#' Convert Outbreak Data to a ttree Object
#'
#' Transforms an outbreak data frame into a structured \code{ttree} list 
#' suitable for transmission tree plotting.
#'
#' @param outbreak A data frame containing at least: \code{removal_time}, 
#'   \code{infectious_period}, \code{latent_period}, \code{parent_id}, and \code{id}.
#' @param dateLastSample Numeric. The calendar date (e.g., 2024.5) corresponding 
#'   to the maximum removal time in the dataset.
#'
#' @return A list of class \code{ttree} containing:
#' \itemize{
#'   \item \code{ttree}: A matrix with columns for infection time, removal time, and parent ID.
#'   \item \code{nam}: A character vector of individual IDs.
#' }
#' @export
ttree_from_transmission <- function(outbreak, dateLastSample) {
  outbreak$removal_time <- outbreak$removal_time - max(outbreak$removal_time) + dateLastSample
  outbreak$onsite_time <- outbreak$removal_time - outbreak$infectious_period
  outbreak$infection_time <- outbreak$onsite_time - outbreak$latent_period

  ttree <- cbind(outbreak$infection_time, outbreak$removal_time, outbreak$infector)
  ttree[1, 3] <- 0
  name <- as.character(outbreak$infectee)
  tree <- list(ttree = ttree, nam = name)
  class(tree) <- "ttree"
  tree
}
