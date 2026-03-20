#' Build a Time Tree via Neighbor-Joining
#'
#' Constructs a phylogenetic time tree from an outbreak matrix by calculating 
#' pairwise transmission distances and applying the Neighbor-Joining algorithm.
#'
#' @param outbreak A data frame with 'id', 'parent_id', 'infection_time', and 'removal_time'.
#' @param root Integer or Character. The ID of the node to use as the root (usually the index case).
#' @param plot Logical. If TRUE, plots the resulting phylogeny.
#' @param ... Additional arguments passed to \code{ape::plot.phylo}.
#'
#' @return An object of class \code{phylo} (invisibly).
#' 
#' @importFrom stats as.dist
#' @importFrom ape nj root plot.phylo cophenetic.phylo
#' @export
build_timetree <- function(outbreak, root = 1, plot = FALSE, ...) {
  if (!requireNamespace("ape", quietly = TRUE)) {
    stop("Package 'ape' is required for build_nj_tree. Please install it with install.packages('ape').")
  }
  pairwise_dist <- find_all_pairwise_distances(outbreak, return_matrix = TRUE)

  # convert to 'dist' object (rownames are ids)
  d <- stats::as.dist(pairwise_dist)
  tree <- ape::nj(d)
  tree <- ape::root(tree, root, resolve.root = TRUE)
  tree$edge.length[1] <- tree$edge.length[length(tree$edge.length)] * 0.2
  tree$edge.length[length(tree$edge.length)] <- tree$edge.length[length(tree$edge.length)] * 0.8
  if (plot) {
    ape::plot.phylo(tree, ...)
  }

  # check if the nj tree is correct
  node_dist <- ape::cophenetic.phylo(tree)
  if (max(abs(node_dist - pairwise_dist)) > 10^-10) {
    stop("pairwise distances are not consistent with the tip distances in the nj tree")
  }

  invisible(tree)
}

