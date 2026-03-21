#' Plot Transmission Networks
#'
#' Visualizes a transmission matrix as a network graph, a rooted tree, 
#' or a timeline, depending on the chosen style.
#'
#' @param transmission A data frame representing the transmission matrix. 
#'   Must contain 'infector', 'infectee', and 'prob'.
#' @param style Integer. 1 for standard network, 2 for rooted tree, 
#'   3 for timeline, 4 for detailed transmission plot.
#' @param vcolor node color.
#' @param vsize node size.
#' @param label.cex node label scaling.
#' @param showlabel Logical. If TRUE, displays probability weights on edges.
#' @param dateLastSample Numeric. The reference year/date for timeline styles.
#'
#' @return The function primarily produces a plot to the active graphics device. 
#'   It returns \code{NULL} invisibly.
#' 
#' @importFrom igraph graph_from_data_frame V E V<- E<- layout_as_tree vcount
#' @importFrom graphics plot legend
#' @export

transplot <- function(transmission, style = 1, vcolor = "lightblue", vsize = 12, label.cex = 1.5, showlabel = FALSE, dateLastSample = 2008) {
  # Filter out NA infectors and edges with prob<0.1
  edges_plot <- transmission
  edges_plot <- edges_plot[!is.na(edges_plot$infector),]
  edges_plot <- edges_plot[which(edges_plot$prob>0.1),]
  
  # Create the graph first
  g <- graph_from_data_frame(edges_plot[, c("infector", "infectee")], directed = TRUE)
  V(g)$name <- as.character(V(g)$name)
  
  # Use vcount(g) to get the correct number of unique individuals
  n_unique_vertices <- vcount(g)
  
  # Initialize attributes using the correct length
  vertex_colors    <- rep(vcolor, n_unique_vertices)
  vertex_sizes     <- rep(vsize, n_unique_vertices)
  vertex_label_cex <- rep(label.cex, n_unique_vertices)
  
  # Find the root of the network
  root_name <- V(g)$name[is.na(match(V(g)$name,as.character(edges_plot$infectee)))]
  target_idx <- which(V(g)$name == root_name)
  if (length(root_name) == 1) {
    vertex_colors[target_idx] <- "grey"
    vertex_sizes[target_idx]  <- vertex_sizes[target_idx] + 2
    vertex_label_cex[target_idx] <- vertex_label_cex[target_idx] + 0.2
  }
  
  # add color and label
  E(g)$color <- ifelse(edges_plot$prob < 0.5, "pink",
                       ifelse(edges_plot$prob < 0.75, "#a1a112", "#6b1a1a")
  )
  if (showlabel) {
    E(g)$label <- as.character(round(edges_plot$prob,2))
  } else {
    E(g)$label <- ""
  }
  
  if (style == 1) { # network style plot
    plot(
      g,
      vertex.size = vertex_sizes,
      vertex.color = vertex_colors,
      vertex.label.cex = vertex_label_cex,
      edge.label = E(g)$label, # show edge attribute
      # edge.width = E(g)$weight, # edge width proportional to weight
      # edge.label.cex = 1.5,
      edge.color = E(g)$color
    )
    legend("topright", legend = c("< 0.5", "0.5 - 0.75", "> 0.75"), col = c("pink", "#a1a112", "#6b1a1a"), pch = 19, bty = "n", cex = 1.0)
  } else if (style == 2) { # rooted-tree-style plot
    layout <- layout_as_tree(g, root = which(V(g)$name == root_name))
    plot(
      g,
      layout = layout,
      #edge.lty = edge_type,
      vertex.size = vertex_sizes,
      vertex.color = vertex_colors,
      vertex.label.cex = vertex_label_cex,
      edge.color = E(g)$color
    )
    legend("topright", legend = c("< 0.5", "0.5 - 0.75", "> 0.75"), col = c("pink", "#a1a112", "#6b1a1a"), pch = 19, bty = "n", cex = 1.0)
  } else if (style == 3) { # timeline style plot
    ttree <- ttree_from_transmission(transmission, dateLastSample = dateLastSample)
    plot(ttree)
  } else if (style == 4) { # transmission style plot
    ttree <- ttree_from_transmission(transmission, dateLastSample = dateLastSample)
    plot(ttree, type = "detailed", w.shape = 10, w.scale = 0.1)
  }
}

