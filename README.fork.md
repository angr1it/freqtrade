# Public fork of Freqtrade + private `user_data` (git submodule)

This repository is a **public fork** of `freqtrade/freqtrade`. It mounts a **private** repository at `user_data/` via a git submodule. All strategy code, configs, notebooks, and helper scripts live in that private repo. The public fork stays clean and easy to sync with upstream.

## Why this layout?
- **Clean fork:** No framework changes here → painless upstream syncs.
- **Privacy:** Strategies/configs/notebooks remain in a separate private repo.
- **Reproducibility:** The submodule points to an exact `user_data` commit.
- **Agent-friendly:** Tools like Cursor/Copilot are constrained to `user_data/**`.

---

## Prerequisites
- Docker and Docker Compose
- Access to the private `user_data` repository (via SSH key or HTTPS token)
- A `docker-compose.yml` that defines a service named `freqtrade` (use the one from upstream or your own)

---

## Clone & initialize submodule

```bash
# Clone the public fork with submodules
git clone --recurse-submodules git@github.com:YOUR-ORG/freqtrade.git
cd freqtrade

# (If you forgot --recurse-submodules)
git submodule update --init --recursive
