#' Trace Infection Ancestry
#'
#' Traverses the transmission chain upwards from a specific individual to 
#' identify all direct and indirect infectors (ancestors).
#'
#' @param outbreak A data frame containing at least \code{id} and \code{parent_id}.
#' @param id Integer. The ID of the individual to trace.
#' @param include_self Logical. If TRUE, the returned vector starts with \code{id}.
#'
#' @return An integer vector of IDs representing the ancestry chain, 
#'   ordered from the individual/parent up to the index case (root).
#' 
#' @importFrom stats setNames
#' @export
find_infectors <- function(outbreak, id, include_self = TRUE) {
  if (!is.data.frame(outbreak) || !all(c("id", "parent_id") %in% names(outbreak))) stop("outbreak must be a data.frame with 'id' and 'parent_id'")
  id <- as.integer(id)
  if (!(id %in% outbreak$id)) {
    warning("id not found in outbreak")
    return(integer(0))
  }
  parent_map <- stats::setNames(as.integer(outbreak$infector), as.character(outbreak$infectee))
  res <- integer(0)
  cur <- id
  if (include_self) res <- c(res, cur)
  visited <- character(0)
  while (TRUE) {
    cur_chr <- as.character(cur)
    if (!cur_chr %in% names(parent_map)) break
    p <- parent_map[cur_chr]
    if (is.na(p)) break
    # cycle detection
    if (cur_chr %in% visited) {
      warning("cycle detected while walking infectors")
      break
    }
    visited <- c(visited, cur_chr)
    res <- c(res, as.integer(p))
    cur <- as.integer(p)
  }
  unique(res)
}

