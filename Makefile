# ===== Defaults =====
CFG ?= user_data/config.json
STRAT ?= PPOQuick
TF ?= 5m
PAIRS ?= BTC/USDT ETH/USDT

# ===== Git / Submodule =====
init:
	git submodule update --init --recursive

user-data-update:
	git submodule update --remote --merge user_data
	git add user_data
	git commit -m "chore(user_data): bump submodule" || true

# ===== Freqtrade CLI via Docker Compose =====
# Assumes a docker-compose.yml that defines a service named 'freqtrade'.
# If your service/file differs, adjust commands accordingly.

create-userdir:
	docker compose run --rm freqtrade create-userdir --userdir user_data

new-config:
	docker compose run --rm freqtrade new-config --config $(CFG)

data:
	docker compose run --rm freqtrade download-data -c $(CFG) -t $(TF) -p $(PAIRS) --days 180

list:
	docker compose run --rm freqtrade list-strategies -c $(CFG) --strategy-path user_data/strategies

backtest:
	docker compose run --rm freqtrade backtesting -c $(CFG) --strategy $(STRAT) --strategy-path user_data/strategies --timeframe $(TF)

trade-dry:
	docker compose run --rm -p 127.0.0.1:8080:8080 freqtrade trade -c $(CFG) --strategy $(STRAT) --strategy-path user_data/strategies

# ===== Upstream sync (pull from original repository) =====
upstream-add:
	git remote add upstream https://github.com/freqtrade/freqtrade.git || true

upstream-sync: upstream-add
	git fetch upstream
	git merge upstream/stable || true
	git push origin HEAD

# ===== Utilities =====
help:
	@echo "Targets:"
	@echo "  init                - init/update git submodule"
	@echo "  user-data-update    - update private user_data to latest branch commit"
	@echo "  create-userdir      - create user_data structure in container (if needed)"
	@echo "  new-config          - generate base config.json"
	@echo "  data                - download OHLCV data"
	@echo "  list                - list available strategies"
	@echo "  backtest            - run backtesting"
	@echo "  trade-dry           - run paper trading (web UI on 8080)"
	@echo "  upstream-sync       - merge upstream/stable into current branch and push"