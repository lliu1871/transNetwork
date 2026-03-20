#' Find the Most Recent Common Infector (MRCI)
#'
#' Identifies the shared infector between two individuals in an outbreak and 
#' calculates the transmission distance between them.
#'
#' @param outbreak A data frame containing 'id', 'parent_id', 'infection_time', and 'removal_time'.
#' @param id1 Integer/Character ID of the first individual.
#' @param id2 Integer/Character ID of the second individual.
#' @param include_self Logical. If TRUE, the search for a common infector includes the individuals themselves.
#'
#' @return A list containing:
#' \itemize{
#'   \item \code{mrci}: The ID of the most recent common infector (NA if no shared infector exists).
#'   \item \code{distance}: The calculated temporal distance between the two individuals.
#' }
#' @export
find_mrci <- function(outbreak, id1, id2, include_self = TRUE) {
  inf1 <- find_infectors(outbreak, id1, include_self)
  inf2 <- find_infectors(outbreak, id2, include_self)
  infector <- intersect(inf1, inf2)[1]
  position1 <- which(inf1 == infector)
  position2 <- which(inf2 == infector)
  if (position1 == 1 && position2 == 1) {
    distance <- 0 # same ids
  } else if (position1 == 1) {
    infection_time <- outbreak[inf2[position2 - 1], ]$infection_time
    distance <- outbreak[id1, ]$removal_time + outbreak[id2, ]$removal_time - 2 * infection_time
  } else if (position2 == 1) {
    infection_time <- outbreak[inf1[position1 - 1], ]$infection_time
    distance <- outbreak[id1, ]$removal_time + outbreak[id2, ]$removal_time - 2 * infection_time
  } else {
    infection_time <- min(outbreak[inf1[position1 - 1], ]$infection_time, outbreak[inf2[position2 - 1], ]$infection_time)
    distance <- outbreak[id1, ]$removal_time + outbreak[id2, ]$removal_time - 2 * infection_time
  }
  list(mrci = infector, distance = ifelse(is.na(infector), NA, distance))
}

