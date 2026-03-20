#' Convert Who-Infected-Who Matrix to Edge List
#'
#' Takes a posterior probability matrix and identifies the most likely infector 
#' for each case (infectee) based on the highest posterior probability.
#'
#' @param matrix_wiw A numeric matrix where \code{matrix_wiw[i, j]} is the 
#'   probability that individual \code{i} infected individual \code{j}. 
#'   Rows should represent potential infectors and columns represent infectees.
#'
#' @return A data frame with three columns:
#' \itemize{
#'   \item \code{infectee}: Character ID of the case.
#'   \item \code{infector}: Character ID of the most likely infector (NA if unknown/zero prob).
#'   \item \code{prob}: The posterior probability associated with that edge.
#' }
#' @export
transmission_edges_matrixwiw <- function(matrix_wiw) {
  mat <- matrix_wiw
  # rows correspond to possible infectors; ensure rownames/colnames exist
  infector_ids <- rownames(mat)
  infectee_ids <- colnames(mat)

  # If rownames/colnames are missing, create numeric ids with 0 allowed
  if (is.null(infector_ids)) infector_ids <- as.character(seq_len(nrow(mat)))
  if (is.null(infectee_ids)) infectee_ids <- as.character(seq_len(ncol(mat)))

  edges <- data.frame(infector = character(0), infectee = character(0), prob = numeric(0), stringsAsFactors = FALSE)

  for (j in seq_len(ncol(mat))) {
    col_probs <- mat[, j]
    # pick the index of the maximum posterior probability; if all NA, set NA
    if (all(is.na(col_probs))) {
      best_idx <- NA
      best_prob <- NA
    } else {
      best_idx <- which(col_probs == max(col_probs, na.rm = TRUE))
      # tie-break by smallest index
      best_idx <- best_idx[1]
      best_prob <- col_probs[best_idx]
    }

    infectee <- infectee_ids[j]
    if (is.na(best_idx) || best_prob == 0.0) {
      infector <- NA
    } else {
      infector <- infector_ids[best_idx]
    }

    edges <- rbind(edges, data.frame(infectee = infectee, infector = infector, prob = best_prob, stringsAsFactors = FALSE))
  }

  # Normalize types
  edges$infector <- as.character(edges$infector)
  edges$infectee <- as.character(edges$infectee)
  rownames(edges) <- NULL
  edges
}

