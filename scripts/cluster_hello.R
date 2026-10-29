# scripts/cluster_hello.R: bootstrap a synthetic GPP series
args <- commandArgs(trailingOnly = TRUE)
n_boot <- 5000L
if (length(args) > 0) n_boot <- as.integer(args[1])

set.seed(42)
day <- 0:729
gpp <- 4 + 3 * sin(2 * pi * day / 365 - 1.5) +
  rnorm(730, 0, 0.5)

means <- replicate(
  n_boot, mean(sample(gpp, replace = TRUE)))
ci <- quantile(means, c(0.025, 0.975))

cat("Host:", Sys.info()[["nodename"]], "\n")
cat("Job ID:", Sys.getenv("SLURM_JOB_ID", "none"), "\n")
cat("Resamples:", n_boot, "\n")
cat(sprintf("Mean daily GPP: %.2f (95%% CI %.2f to %.2f)\n",
            mean(gpp), ci[1], ci[2]))
