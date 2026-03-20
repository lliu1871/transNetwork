#' Simulate a Phylogenetic Tree from a Time Tree
#'
#' Converts an epidemiological time tree into a phylogenetic tree by scaling 
#' branch lengths by a mutation rate and optionally simulating the coalescent 
#' process using the multispecies coalescent framework.
#'
#' @param timetree An object of class \code{phylo} (from the \code{ape} package).
#' @param murate Numeric. Mutation rate used to scale the time tree branch lengths.
#' @param theta Numeric. Population size parameter for the coalescent simulation. 
#'   If 0, a simple scaling is performed.
#'
#' @return An object of class \code{phylo} representing the simulated gene tree.
#' 
#' @importFrom phybase read.tree.nodes sim.coaltree.sp
#' @importFrom ape read.tree write.tree dist.nodes
#' @export

sim_phytree <- function(timetree, murate = 0.0, theta = 0.0) {
    # add mutations
    phytree <- timetree
    if(murate > 0.0){
	    phytree$edge.length <- phytree$edge.length * murate
    }

    if(theta > 0.0){
      # calculate tip-root distances
      spname <- phytree$tip.label
      nspecies <- length(spname)
      root <- nspecies + 1
      root_to_tip <- dist.nodes(phytree)[1:nspecies, root]
      diff_tip_length <- max(root_to_tip) - root_to_tip
  
      # convert to a clock tree by adding to tips
      clocktree <- phytree
      index <- match(spname, clocktree$tip.label)
      tip_index <- order(clocktree$edge[, 2])[index]
      clocktree$edge.length[tip_index] <- clocktree$edge.length[tip_index] + diff_tip_length
      
      # use clocktree to simulate coalescent tree
      sptree <- read.tree.nodes(write.tree(clocktree), name = spname)
      nodematrix <- sptree$nodes
      nodematrix[, 5] <- theta
      genetree <- sim.coaltree.sp(dim(nodematrix)[1], nodematrix, nspecies, seq = rep(1, nspecies), name = spname)$gt
      coaltree <- read.tree(text = genetree)
  
      # convert back to original branch lengths by subtracting from tips
      index <- match(spname, coaltree$tip.label)
      tip_index <- order(coaltree$edge[, 2])[index]    
      coaltree$edge.length[tip_index] <- coaltree$edge.length[tip_index] - diff_tip_length
      phytree <- coaltree
    }

    return(phytree)
}

