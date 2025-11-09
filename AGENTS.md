# AGENTS — Working Rules for This Fork

**Goal:** Keep this public fork of `freqtrade` clean (no framework changes). All strategy code, notebooks, configs, and helper scripts live in a **private** repository mounted here as a git submodule at `user_data/`.

## Allowed edit areas
- `user_data/**` — the **only** place for strategies, configs, notebooks, and scripts.
- Repository meta files:
  - `AGENTS.md`, `.gitmodules`, `README.fork.md`, `Makefile`
  - CI workflows in `.github/workflows/**`

## Forbidden edit areas
- Any core framework code (e.g., `freqtrade/**`, `plugins/**`, `docs/**`, etc.).
- If the framework must change, do it upstream (not in this fork).

## Handy commands
- Initialize submodule:  
  `git submodule update --init --recursive`
- Update `user_data` to the latest commit on its branch:  
  `git submodule update --remote --merge user_data && git add user_data && git commit -m "chore(user_data): bump" || true`
- List strategies:  
  `docker compose run --rm freqtrade list-strategies -c user_data/config.json --strategy-path user_data/strategies`
- Backtest:  
  `docker compose run --rm freqtrade backtesting -c user_data/config.json --strategy-path user_data/strategies --strategy MyStrategy`
- Paper trading (dry-run):  
  `docker compose run --rm -p 127.0.0.1:8080:8080 freqtrade trade -c user_data/config.json --strategy MyStrategy --strategy-path user_data/strategies`

## CI / private submodule
- GitHub Actions uses `actions/checkout@v4` with `submodules: true`.
- Provide a secret `PAT` with read access to the private `user_data` repository (or use an SSH deploy key).

## Keeping this fork up to date with upstream
```bash
git remote add upstream https://github.com/freqtrade/freqtrade.git
git fetch upstream
git checkout stable               # or whichever base branch you use
git merge upstream/stable         # or: git rebase upstream/stable
git push origin stable
