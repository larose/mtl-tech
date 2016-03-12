BUILD_DIR = build
GIT_REMOTE_DEPLOY = git@github.com:larose/mtl-tech.git
PYTHON = python3
STATIC_DIR = static
SRC_DIR = src

.PHONY: all
all: front-end orgs keywords partial-keywords

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

.PHONY: keywords
keywords:
	rm -rf $(BUILD_DIR)/filters
	mkdir -p $(BUILD_DIR)/filters
	cat $(BUILD_DIR)/orgs.json | $(PYTHON) $(SRC_DIR)/make-keywords.py $(BUILD_DIR)/filters

.PHONY: orgs
orgs: $(BUILD_DIR)
	$(PYTHON) $(SRC_DIR)/make-orgs-json.py orgs $(BUILD_DIR)/orgs.json

.PHONY: partial-keywords
partial-keywords:
	rm -rf $(BUILD_DIR)/partial-keywords
	mkdir -p $(BUILD_DIR)/partial-keywords
	$(PYTHON) $(SRC_DIR)/make-partial-keywords.py $(BUILD_DIR)/filters $(BUILD_DIR)/partial-keywords

.PHONY: run-local-server
run-local-server:
	cd $(BUILD_DIR) && $(PYTHON) -m http.server
