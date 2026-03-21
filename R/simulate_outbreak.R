#' Simulate a Stochastic Outbreak
#'
#' Simulates an infectious disease outbreak using a branching process. Each individual 
#' has a latent period, an onsite time, and an infectious period followed by removal.
#'
#' @param initial_infection_time Numeric. The time the first case is infected (default 0).
#' @param infection_rate Numeric. The rate of secondary infections per unit of time.
#' @param removal_rate Numeric. The rate of removal from the infectious state.
#' @param latent_mean Numeric. The degrees of freedom for the chi-square distribution of the latent period.
#' @param target_size Integer. The minimum number of cases required for a successful simulation.
#'
#' @return A data frame (outbreak matrix) with \code{target_size} rows and columns for IDs, 
#'   times (infection, onsite, removal), and periods (latent, infectious).
#' 
#' @importFrom stats rchisq rexp rpois runif setNames
#' @export

simulate_outbreak <- function(initial_infection_time = 0, infection_rate = 2.0, removal_rate = 2.0, latent_mean = 0.2, target_size = 50) {
  repeat {
    outbreak <- data.frame(
      infectee = integer(),
      infector = integer(),
      infection_time = numeric(),
      latent_period = numeric(),
      onsite_time = numeric(),
      infectious_period = numeric(),
      removal_time = numeric(),
      num_infections = integer(),
      stringsAsFactors = FALSE
    )
    # queue of individuals to simulate
    queue <- data.frame(
      infectee = 1,
      infector = NA,
      infection_time = initial_infection_time
    )

    next_id <- 2

    while (nrow(queue) > 0) {
      # take the first individual
      person <- queue[1, ]
      queue <- queue[-1, ]

      # Step 1: latent period
      latent_period <- rchisq(1, df = latent_mean)

      # Step 2: on-site time
      onsite_time <- person$infection_time + latent_period

      # Step 3: infectious period
      infectious_period <- rexp(1, rate = removal_rate)

      # Step 4: removal time
      removal_time <- onsite_time + infectious_period

      # Step 5: number of infections
      num_infections <- rpois(1, lambda = infection_rate * infectious_period)

      # Step 6: secondary infection times only if less than 2*target_size
      if (num_infections > 0 && next_id < 2 * target_size) {
        secondary_times <- onsite_time + runif(num_infections, min = 0, max = infectious_period)
        new_infections <- data.frame(
          infectee = next_id:(next_id + num_infections - 1),
          infector = person$infectee,
          infection_time = secondary_times
        )
        queue <- rbind(queue, new_infections)
        next_id <- next_id + num_infections
      }

      # save this individual
      outbreak <- rbind(
        outbreak,
        data.frame(
          infectee = person$infectee,
          infector = person$infector,
          infection_time = person$infection_time,
          latent_period = latent_period,
          onsite_time = onsite_time,
          infectious_period = infectious_period,
          removal_time = removal_time,
          num_infections = num_infections
        )
      )
    }

    # check outbreak size
    if (nrow(outbreak) >= target_size) {
      # sort by onsite_time (ascending) before returning
      outbreak <- outbreak[order(outbreak$onsite_time), ]
      # keep a copy of old ids so we can remap parent_id after reindexing
      old_id <- outbreak$infectee
      # reset row names to be sequential
      rownames(outbreak) <- NULL
      # replace id with row numbers (1..n) and remap parent_id accordingly
      outbreak$infectee <- seq_len(nrow(outbreak))
      parent_old <- outbreak$infector
      # create lookup from old id -> new id (names are characters)
      lookup <- setNames(outbreak$infectee, as.character(old_id))
      # map parent_old to new ids; keep NA where parent_old is NA or not found
      outbreak$infector <- ifelse(is.na(parent_old), NA_integer_, as.integer(lookup[as.character(parent_old)]))
      # warn if any non-NA parent_old could not be remapped
      missing_parents <- !is.na(parent_old) & is.na(outbreak$infector)
      if (any(missing_parents)) {
        warning(sprintf("%d parent_id(s) were not found in outbreak after reindexing and were set to NA.", sum(missing_parents)))
      }

      # reset infection_time
      outbreak$infection_time <- outbreak$infection_time - outbreak$onsite_time[1]
      outbreak$removal_time <- outbreak$removal_time - outbreak$onsite_time[1]
      outbreak$onsite_time <- outbreak$onsite_time - outbreak$onsite_time[1]
      return(outbreak[1:target_size, ])
    }
    # else, repeat simulation until size ≥ target_size
  }
}

