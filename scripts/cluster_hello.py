# scripts/cluster_hello.py: bootstrap a synthetic GPP series
import math, os, random, socket, sys

n_boot = int(sys.argv[1]) if len(sys.argv) > 1 else 5000

random.seed(42)
gpp = [4 + 3 * math.sin(2 * math.pi * d / 365 - 1.5)
       + random.gauss(0, 0.5) for d in range(730)]

means = sorted(sum(random.choices(gpp, k=730)) / 730
               for _ in range(n_boot))
lo = means[int(0.025 * n_boot)]
hi = means[int(0.975 * n_boot)]

print("Host:", socket.gethostname())
print("Job ID:", os.environ.get("SLURM_JOB_ID", "none"))
print("Resamples:", n_boot)
print(f"Mean daily GPP: {sum(gpp) / 730:.2f} "
      f"(95% CI {lo:.2f} to {hi:.2f})")
