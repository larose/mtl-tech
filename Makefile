BUILD_DIR = build
GIT_REMOTE_DEPLOY = git@github.com:larose/mtl-tech.git
PYTHON = python3
STATIC_DIR = static
SRC_DIR = src

.PHONY: all
all: front-end $(BUILD_DIR)/data.js

$(BUILD_DIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)/*
	rm -rf $(BUILD_DIR)/.git

.PHONY: deploy
deploy: clean all
	cd $(BUILD_DIR) && git init && git add . && git commit --allow-empty-message -m "" && git push -f $(GIT_REMOTE_DEPLOY) master:gh-pages

.PHONY: front-end
front-end: $(BUILD_DIR)
	cp -r $(STATIC_DIR)/* $(BUILD_DIR)
	cp -r images $(BUILD_DIR)

.PHONY: run-local-server
run-local-server:
	cd $(BUILD_DIR) && $(PYTHON) -m http.server

$(BUILD_DIR)/data.js: orgs
	$(PYTHON) $(SRC_DIR)/make-data.py orgs > $(BUILD_DIR)/data.js
