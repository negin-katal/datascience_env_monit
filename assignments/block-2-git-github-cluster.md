# Block 2 Assignment: Git, GitHub and your first cluster job

## Overview

This assignment takes about 2 hours. You practise the Git loop from class, then run your first job on bwUniCluster and write down where your results live and when they expire.

You hand in three things on ILIAS before Block 3: the link to your fork on GitHub, the contents of your job's `.out` file, and your `docs/STORAGE.md`.

| Part | What you do | Time |
| --- | --- | --- |
| A | README, `.gitignore`, pull, history | 40 min |
| B | Connect, workspace, run a job | 50 min |
| C | Storage note and fresh-clone test | 20 min |
| Hand-in | Check the list and submit on ILIAS | 10 min |

**Before you start, you need:**

- Git installed, with your name and email set (`git config --global user.name`, `user.email`).
- A fork of the course repository on your GitHub account, cloned to your laptop. The folder contains `scripts/`, `jobs/` and `docs/`.
- An approved bwUniCluster account and the SSH setup from the course guide: [SSH connection guide](https://negin-katal.github.io/datascience_env_monit/ssh-connection/).

Choose one route and keep it for the whole assignment: **R** (`cluster_hello.R`, `hello_R.sh`) or **Python** (`cluster_hello.py`, `hello_py.sh`). If your cluster account is not approved yet, do Part A and the laptop fallback in Part B, and run the job later.

## Part A: Git and GitHub (40 min)

Work in your cloned folder, in a terminal (Git Bash on Windows). Look at `git status` before and after every step.

### A1. Write a README

1. Open `README.md` in the project folder. It is the course README. In your fork, replace its content with your own project README. Your fork is your own copy, so the course repository is not affected.
2. Answer four questions in it: what is this, how do I run it, what is in the folder, who made it.
3. Stage, commit and push.

```markdown
# Cluster hello

Bootstraps a synthetic GPP series and prints a 95% interval.

## Run
Rscript scripts/cluster_hello.R 200

## Files
scripts/  the analysis code
jobs/     Slurm job scripts
docs/     notes and templates

## Author
Your Name
```

```bash
git status
git add README.md
git commit -m "Add README with run instructions"
git push
```

**Check:** reload your fork on github.com. The README is shown under the file list. Python route: use `python3 scripts/cluster_hello.py 200` in the Run section.

### A2. Add a .gitignore

1. Create a file named exactly `.gitignore` with these lines:

```
.DS_Store
*.tmp
*.out
*.zip
.env
```

2. Create a test file and check that Git ignores it.
3. Commit and push `.gitignore`.

```bash
touch test.tmp
git status
git add .gitignore
git commit -m "Ignore system files and job outputs"
git push
```

**Check:** `git status` does not list `test.tmp`. If it does, check the file name for typos (not `gitignore.txt`). GitHub blocks files over 100 MB, so large data never belongs in the repository.

### A3. Pull changes from GitHub

1. On github.com open `README.md` in your fork and click the pencil icon.
2. Add a line and click **Commit changes**.
3. In the terminal run `git status`. It still says your branch is up to date, because Git only knows what it heard last time.
4. Run `git pull`, then open `README.md` on your laptop.

```bash
git status
git pull
cat README.md
```

**Check:** `git pull` reports a fast-forward and your local README has the new line.

### A4. Write good commit messages

Which message will help you in six months? Pick one and write one sentence why.

- `update`
- `fix`
- `Treat -9999 as missing before monthly means`
- `final version 2`
- `asdf`

Answer: the third. It says what changed and why, so you can find the commit without opening the code. Start with a verb, say what changed, add the reason if it is not obvious.

**If a push is rejected:** the message `! [rejected] main -> main (fetch first)` means GitHub has newer commits. Run `git pull`, then `git push`. If an editor opens, save and leave it (nano: Ctrl+O, Enter, Ctrl+X; vim: Esc, then `:wq`, Enter). If Git says it needs to specify how to reconcile, run `git config --global pull.rebase false` and pull again.

### A5. Look at your history (5 min)

Before you commit, look at what you are about to commit. Add a line with your name and today's date to `README.md`, save it, then run these commands in order:

```bash
git diff
git add README.md
git diff
git diff --staged
git commit -m "Add author and date to README"
```

Now look back through the history:

```bash
git log --oneline --graph
git log README.md
git show HEAD
git blame README.md
```

**Check:** the first `git diff` shows your new line with a `+`. After `git add` the plain `git diff` is empty and `git diff --staged` shows the line instead. `git log README.md` lists only the commits that touched the README, `git show HEAD` opens your newest commit, and `git blame` shows who last changed each line. Question: which commits in `git log README.md` are yours, and which came with the course repository?

## Part B: Run a job on bwUniCluster (50 min)

Code goes to your home directory (`$HOME`, permanent and backed up). Results go to a workspace (temporary, not backed up). Heavy work runs as a job, never on the login node.

### B1. Log in

Follow the [SSH connection guide](https://negin-katal.github.io/datascience_env_monit/ssh-connection/) if you have not connected before.

```bash
ssh bwunicluster
hostname
pwd
echo $HOME
ws_list
```

**Check:** the prompt changed, `hostname` shows a login node, and `ws_list` is empty for now. Type `exit` to come back to your laptop.

### B2. Clone your fork on the cluster

```bash
cd $HOME
git clone https://github.com/YOUR-USER/datascience_env_monit.git
cd datascience_env_monit
git log --oneline
```

Replace `YOUR-USER` with your GitHub name. **Check:** the log shows your commits from Part A.

### B3. Create a workspace

```bash
ws_allocate envmon 60
cd $(ws_find envmon)
pwd
ws_list
```

The workspace `envmon` lives 60 days. Write the expiry date shown by `ws_list` in your calendar now.

### B4. Read your job script

The job script is a normal shell script. Lines starting with `#SBATCH` are requests to the scheduler. Pick your route.

**R route:** `jobs/hello_R.sh`

```bash
#!/bin/bash
#SBATCH --job-name=hello_R
#SBATCH --partition=dev_cpu
#SBATCH --ntasks=1
#SBATCH --time=00:05:00
#SBATCH --output=hello_R_%j.out

module load math/R/4.4.2-openblas
cd "$HOME/datascience_env_monit"
Rscript scripts/cluster_hello.R
```

**Python route:** `jobs/hello_py.sh` has the same header with `hello_py`. If `python3` is missing or too old on the compute node, run `module spider python` on the login node and add the matching `module load` line before the `cd`.

| Line | Meaning |
| --- | --- |
| `--job-name=hello_R` | Name shown in the queue |
| `--partition=dev_cpu` | Short test queue, 30 minutes maximum |
| `--ntasks=1` | One process |
| `--time=00:05:00` | Stop after 5 minutes at most |
| `--output=hello_R_%j.out` | Output file. `%j` becomes the job number |

### B5. Submit and watch

Submit from inside the workspace so the output file lands there.

```bash
cd $(ws_find envmon)
sbatch $HOME/datascience_env_monit/jobs/hello_R.sh
squeue -u $USER
ls
cat hello_R_<jobid>.out
```

`sbatch` prints `Submitted batch job 1234567`. In `squeue`, `PD` means waiting and `R` means running. When the list is empty, the job has finished. Replace `<jobid>` with your job number. Python route: `jobs/hello_py.sh` and `hello_py_<jobid>.out`.

### B6. Check the result

Your `.out` file should look like this. Host name and job number will differ.

```
Host: uc2n123.localdomain
Job ID: 1234567
Resamples: 5000
Mean daily GPP: 3.98 (95% CI 3.83 to 4.14)
```

Python gives about `4.01 (95% CI 3.84 to 4.17)`. The R and Python numbers differ slightly because their random number generators differ. **The Job ID must be a number, not `none`.** A number means it ran as a cluster job.

### B7. Fallback if you cannot connect

Run the script on your laptop with a small number of resamples. `Job ID` shows `none`, which is correct here.

```bash
Rscript scripts/cluster_hello.R 200
python3 scripts/cluster_hello.py 200
```

Use the line for your route. Once your login works, repeat B1 to B6 and hand in the cluster result. You can copy a folder to the cluster with `scp -r ~/Documents/datascience_env_monit bwunicluster:`, but cloning again is better.

## Part C: Storage, backup and a fresh-clone test (20 min)

The cluster is a place to compute, not a place to keep things. Know where each file lives and when it disappears.

| Place | Lifetime | Backup | Use it for |
| --- | --- | --- | --- |
| `$HOME` | Permanent (500 GiB soft quota) | Regular backup | Code, small files |
| Workspace | 60 days, can be extended | None | Results, big data |
| `$TMPDIR` | Deleted when the job ends | None | Scratch during a job |
| GitHub | Permanent | By GitHub | Code and history |

Extend a workspace before it expires with `ws_extend envmon 60`. This works up to three times. Copy results you must keep to your laptop, running this on the laptop:

```bash
scp bwunicluster:<workspace path>/hello_R_<jobid>.out .
```

### C1. Document your storage

1. On the cluster run `ws_list` and note the path and the expiry date.
2. On your laptop copy `docs/STORAGE_TEMPLATE.md` to `docs/STORAGE.md` and fill it in.
3. Commit with the message `Document storage and backup` and push.
4. On the cluster run `cd $HOME/datascience_env_monit`, then `git pull`.
5. Check that `docs/STORAGE.md` is there.

```markdown
# Storage and backup

## Where things live
- Code: GitHub (<your-username>/datascience_env_monit), my laptop, cluster HOME
- Results: cluster workspace `envmon`, path: <from ws_list>

## Expiry
- Workspace `envmon` expires on: <date from ws_list>
- I extend it on: <date>. Calendar reminder set: yes/no

## Backup
- Code: GitHub is the second copy
- Results I must keep: copied to my laptop on <date>
- Raw data: original download source + <university storage>
```

### C2. Does it work from a fresh clone?

If someone else cannot run your project from a fresh clone, it is not reproducible yet. Test it as a stranger would, on your laptop, then delete the copy.

```bash
cd /tmp
git clone https://github.com/YOUR-USER/datascience_env_monit.git test-clone
cd test-clone
Rscript scripts/cluster_hello.R 200
```

Python route: `python3 scripts/cluster_hello.py 200`. On Windows clone into any temporary folder instead of `/tmp`. If it fails, your README is missing something. Fix the README, commit and push.

## Optional extension: branches, conflicts, undo

For those who finish early. Not part of the hand-in.

### Branches

A branch is a parallel line of commits. Experiment on a branch while `main` stays untouched.

```bash
git switch -c faster-test     # new branch, switch to it
# edit scripts/cluster_hello.R, change n_boot to 1000L, then:
git commit -am "Use 1000 resamples for quick tests"
git switch main               # back to the main line
git merge faster-test         # bring the experiment in
```

### A merge conflict

If `main` and the branch both changed the same line, Git stops and marks both versions in the file:

```
<<<<<<< HEAD
n_boot <- 5000L
=======
n_boot <- 1000L
>>>>>>> faster-test
```

Above `=======` is your current branch, below is the branch you merge in. A conflict is not an error, it is a question. Resolve it in four steps:

1. Open the file (`git status` lists it as both modified).
2. Decide which version to keep, or combine them, and delete the three marker lines.
3. Run `git add` on the file to tell Git it is solved.
4. Run `git commit -m "Merge faster-test, keep 5000 resamples"`, then `git push`.

Lost? `git merge --abort` returns to the state before the merge.

### Undoing things

| Situation | What to run |
| --- | --- |
| Edited a file, want the last saved version back | `git restore FILE` |
| Staged a file by mistake | `git restore --staged FILE` |
| Typo in the last commit message, not pushed | `git commit --amend` |
| A pushed commit was wrong | `git revert COMMIT` |
| A password or token was committed | Revoke it first, then clean up |

`git restore FILE` throws away your uncommitted edits for good. `git revert` adds a new commit that cancels the old one and never rewrites shared history.

**More ways to undo** (from the Git cheat sheet):

| Situation | What to run |
| --- | --- |
| Put unfinished work aside, then bring it back | `git stash`, later `git stash pop` |
| Undo the last commit but keep the edits (not pushed yet) | `git reset HEAD^` |
| Get one file back as it was in an older commit | `git restore --source COMMIT FILE` |
| Remove untracked files you do not need | `git clean -n` to preview, then `git clean -f` |

`git reset HEAD^` is only safe before you push. `git clean -f` deletes files for good, so always preview with `-n` first.

## Hand-in and checklist

Submit these three things on ILIAS before Block 3:

1. The link to your fork on GitHub (`https://github.com/YOUR-USER/datascience_env_monit`).
2. The contents of your job's `.out` file, pasted as text. If you could not connect yet, paste the laptop output and say so.
3. A copy of your `docs/STORAGE.md`.

Tick everything before you submit:

- [ ] My fork has my own `README.md` and a `.gitignore`
- [ ] `git log --oneline` shows at least four commits of mine with clear messages
- [ ] `git status` says the working tree is clean and my branch is up to date
- [ ] I logged in to bwUniCluster with `ssh`
- [ ] I cloned my fork into `$HOME` on the cluster
- [ ] I created the workspace `envmon`
- [ ] My job ran and the `.out` file shows a numeric Job ID
- [ ] `docs/STORAGE.md` has my workspace path and expiry date, and the expiry date is in my calendar
- [ ] A fresh clone runs with the commands in my README

Three rules to keep:

- **Commit small, say why.** Small commits with clear messages are a history you can read and undo.
- **Code to Git, data to storage.** Scripts belong in the repository. Big data and results belong in storage, with a backup.
- **Heavy work in a job, not on the login node.** The login node is shared by everyone.

## Command cheat sheet

The commands from this assignment in one place, plus a few from the course cheat sheet.

| Command | What it does |
| --- | --- |
| `git status` | Which files changed, which are staged |
| `git diff` | Exact lines changed, not yet staged |
| `git diff --staged` | What the next commit will contain |
| `git add FILE` | Stage a file for the next commit |
| `git commit -m "message"` | Save a version with a message |
| `git push` / `git pull` | Send your commits to GitHub / bring new ones down |
| `git log --oneline` | One line per commit (add `--graph` for branches) |
| `git log FILE` | Only the commits that touched one file |
| `git show COMMIT` | One commit in detail |
| `git blame FILE` | Who last changed each line |
| `git remote -v` | Where push and pull go (your fork, not the course repo) |
| `git switch -c NAME` / `git switch main` | Create a branch / go back to main |
| `git merge NAME` | Bring a branch into the current one |
| `git restore FILE` | Throw away uncommitted edits to a file |
| `git restore --staged FILE` | Unstage a file, keep the edits |
| `git commit --amend` | Fix the last commit (not pushed yet) |
| `git stash` / `git stash pop` | Put work aside / bring it back |

## Troubleshooting and further learning

Read the last lines of an error message first. Git usually tells you the fix.

| You see | Usually it means |
| --- | --- |
| `not a git repository` | You are in the wrong folder. `cd` into the project. |
| `Unable to read current working directory: Operation not permitted` | Your terminal started in a folder it may not read (macOS). Run `cd ~`, then repeat the command. If it keeps happening, give your terminal access under System Settings, Privacy & Security, Files and Folders. |
| `Invalid username or token` | Passwords no longer work. Use browser sign-in or a token with scope `repo`. |
| `403` on push | Your token lacks scope `repo`, or you pushed to the course repository instead of your fork. Check `git remote -v`. |
| `! [rejected] (fetch first)` | GitHub has newer commits. `git pull`, then `git push`. |
| `Permission denied (publickey)` | SSH key or config problem. Check the SSH guide. |
| `Rscript: command not found` | Load the module in the job script with `module load`. |

Signing in from the terminal: on Windows, Git Credential Manager opens a browser on the first push. On macOS and Linux run `gh auth login` and choose GitHub.com and HTTPS, or use a classic personal access token with scope `repo` as the password. On macOS, `git config --global credential.helper osxkeychain` remembers the login.

Stuck for more than 10 minutes? Post the exact command and the last lines of the error on ILIAS.

**Further learning**

- [Pro Git](https://git-scm.com/book), the free book. Chapters 1 to 3 cover this assignment.
- Try a pull request: change something in your fork and propose it to the course repository.
- [mcp-git-course](https://github.com/gdkrmr/mcp-git-course), an interactive Git course. Use it as a supplement, not a replacement.
