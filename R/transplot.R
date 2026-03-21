#' Plot Transmission Networks
#'
#' Visualizes a transmission matrix as a network graph, a rooted tree, 
#' or a timeline, depending on the chosen style.
#'
#' @param transmission A data frame representing the transmission matrix. 
#'   Must contain 'infector', 'infectee', and 'prob'.
#' @param style Integer. 1 for standard network, 2 for rooted tree, 
#'   3 for timeline, 4 for detailed transmission plot.
#' @param vertex_colors Character vector of colors for the nodes.
#' @param vertex_sizes Numeric vector of node sizes.
#' @param vertex_label_cex Numeric vector for vertex label scaling.
#' @param showlabel Logical. If TRUE, displays probability weights on edges.
#' @param dateLastSample Numeric. The reference year/date for timeline styles.
#'
#' @return The function primarily produces a plot to the active graphics device. 
#'   It returns \code{NULL} invisibly.
#' 
#' @importFrom igraph graph_from_data_frame V E V<- E<- layout_as_tree
#' @importFrom graphics plot legend
#' @export

transplot <- function(transmission, style = 1, vertex_colors = rep("lightblue", length(transmission[, 1])), vertex_sizes = rep(12, length(transmission[, 1])), vertex_label_cex = rep(1.5, length(transmission[, 1])), showlabel = TRUE, dateLastSample = 2008) {
  # Filter out zero-probability (and missing) edges for plotting only
  edges_plot <- transmission
  # treat NA as zero for plotting purposes
  edges_plot$prob[is.na(edges_plot$prob)] <- 0
  edges_plot <- edges_plot[edges_plot$prob > 0, , drop = FALSE]
  if (nrow(edges_plot) == 0) {
    stop("No edges with prob > 0 to plot; skipping plotting.")
  }
  # convert NA infector (external) to "source"
  edges_plot$infector[is.na(edges_plot$infector)] <- "source"
  # create a graph
  g <- graph_from_data_frame(edges_plot[, c("infector", "infectee")], directed = TRUE)
  V(g)$name <- as.character(V(g)$name)
  target_idx <- which(V(g)$name == "1")
  if (length(target_idx) == 1) {
    vertex_colors[target_idx] <- "grey"
    vertex_sizes[target_idx] <- vertex_sizes[target_idx] + 2
    vertex_label_cex[target_idx] <- vertex_label_cex[target_idx] + 0.2
  }
  E(g)$weight <- round(edges_plot$prob, digits = 2)
  E(g)$color <- ifelse(edges_plot$prob < 0.5, "pink",
    ifelse(edges_plot$prob < 0.75, "#a1a112", "#6b1a1a")
  )
  if (showlabel) {
    E(g)$label <- as.character(E(g)$weight)
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
    legend("topright", legend = c("< 0.5", "0.5 - 0.75", "> 0.75"), col = c("pink", "#a1a112", "#6b1a1a"), pch = 19, bty = "n", cex = 1.5)
  } else if (style == 2) { # rooted-tree-style plot
    root_name <- if ("source" %in% V(g)$name) "source" else V(g)$name[1]
    layout <- layout_as_tree(g, root = which(V(g)$name == root_name))
    plot(
      g,
      layout = layout,
      vertex.size = vertex_sizes,
      vertex.color = vertex_colors,
      vertex.label.cex = vertex_label_cex,
      edge.color = E(g)$color
    )
    legend("topright", legend = c("< 0.5", "0.5 - 0.75", "> 0.75"), col = c("pink", "#a1a112", "#6b1a1a"), pch = 19, bty = "n", cex = 1.5)
  } else if (style == 3) { # timeline style plot
    ttree <- ttree_from_transmission(transmission, dateLastSample = dateLastSample)
    plot(ttree)
  } else if (style == 4) { # transmission style plot
    ttree <- ttree_from_transmission(transmission, dateLastSample = dateLastSample)
    plot(ttree, type = "detailed", w.shape = 10, w.scale = 0.1)
  }
}

