#' Compute All Pairwise Transmission Distances
#'
#' Calculates the temporal distance between every pair of individuals in an 
#' outbreak based on their Most Recent Common Infector (MRCI).
#'
#' @param outbreak A data frame with 'infectee', 'infector', 'infection_time', and 'removal_time'.
#' @param return_matrix Logical. If TRUE (default), returns a symmetric $nxn$ 
#'   numeric matrix. If FALSE, returns a long-format data frame.
#'
#' @return If \code{return_matrix} is TRUE, a symmetric \code{matrix}. 
#'   Otherwise, a \code{data.frame} containing columns for both IDs, the shared 
#'   infector, the infector's infection time, and the calculated distance.
#' 
#' @importFrom stats setNames
#' @export
find_all_pairwise_distances <- function(outbreak, return_matrix = TRUE) {
  if (!is.data.frame(outbreak) || !all(c("infectee", "infector", "infection_time", "removal_time") %in% names(outbreak))) {
    stop("outbreak must be a data.frame with columns 'infectee','infector','infection_time','removal_time'")
  }

  ids <- outbreak$id
  n <- length(ids)

  # maps for quick lookup
  inf_time <- stats::setNames(as.numeric(outbreak$infection_time), as.character(outbreak$id))
  rem_time <- stats::setNames(as.numeric(outbreak$removal_time), as.character(outbreak$id))

  # build ancestor chains for each id (include self so MRCA can be one of the ids)
  chains <- lapply(ids, function(x) find_infectors(outbreak, x, include_self = TRUE))
  names(chains) <- as.character(ids)

  # helper to compute MRCA (infector) and p_inf per pair using ancestor positions (minimize sum of positions)
  compute_mrca_and_pinf <- function(a, b) {
    ca <- chains[[as.character(a)]]
    cb <- chains[[as.character(b)]]
    if (length(ca) == 0 || length(cb) == 0) {
      return(list(mrca = NA_integer_, p_inf = NA_real_, distance = NA_real_))
    }
    common <- intersect(ca, cb)
    if (length(common) == 0) {
      return(list(mrca = NA_integer_, p_inf = NA_real_, distance = NA_real_))
    }
    # compute positions
    pos_a <- match(common, ca)
    pos_b <- match(common, cb)
    sums <- pos_a + pos_b
    best <- which.min(sums)[1]
    infector <- as.integer(common[best])
    position1 <- pos_a[best]
    position2 <- pos_b[best]

    # determine p_inf like find_mrci
    if (position1 == 1 && position2 == 1) {
      # same id
      p_inf <- inf_time[as.character(infector)]
      distance <- 0.0
    } else if (position1 == 1) {
      # infector is id a; use previous ancestor in b
      prev_b <- cb[position2 - 1]
      p_inf <- inf_time[as.character(prev_b)]
      distance <- if (is.na(p_inf)) NA_real_ else rem_time[as.character(a)] + rem_time[as.character(b)] - 2 * p_inf
    } else if (position2 == 1) {
      prev_a <- ca[position1 - 1]
      p_inf <- inf_time[as.character(prev_a)]
      distance <- if (is.na(p_inf)) NA_real_ else rem_time[as.character(a)] + rem_time[as.character(b)] - 2 * p_inf
    } else {
      prev_a <- ca[position1 - 1]
      prev_b <- cb[position2 - 1]
      p_inf <- min(inf_time[as.character(prev_a)], inf_time[as.character(prev_b)], na.rm = TRUE)
      if (is.infinite(p_inf)) p_inf <- NA_real_
      distance <- if (is.na(p_inf)) NA_real_ else rem_time[as.character(a)] + rem_time[as.character(b)] - 2 * p_inf
    }
    list(mrca = infector, p_inf = p_inf, distance = distance)
  }

  if (return_matrix) {
    mat <- matrix(NA_real_, nrow = n, ncol = n)
    rownames(mat) <- colnames(mat) <- as.character(ids)
    for (i in seq_len(n)) {
      for (j in seq.int(i, n)) {
        id1 <- ids[i]
        id2 <- ids[j]
        tmp <- compute_mrca_and_pinf(id1, id2)
        d <- tmp$distance
        mat[i, j] <- mat[j, i] <- d
      }
    }
    return(mat)
  } else {
    rows <- vector("list", n * (n - 1) / 2)
    k <- 1L
    for (i in seq_len(n)) {
      for (j in seq.int(i + 1L, n)) {
        id1 <- ids[i]
        id2 <- ids[j]
        tmp <- compute_mrca_and_pinf(id1, id2)
        rows[[k]] <- data.frame(id1 = id1, id2 = id2, common_parent = tmp$mrca, parent_infection_time = tmp$p_inf, distance = tmp$distance)
        k <- k + 1L
      }
    }
    df <- do.call(rbind, rows)
    return(df)
  }
}

