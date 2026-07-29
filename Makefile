# Fandag — Makefile
# All project commands in one place

# Colors
GREEN  := \033[0;32m
YELLOW := \033[0;33m
CYAN   := \033[0;36m
RESET  := \033[0m

# FVM
FVM := fvm
FLUTTER := $(FVM) flutter
DART := $(FVM) dart

.PHONY: help setup init i gen watch translations run run-mock ios android build-apk build-ios build-ipa test test-coverage analyze format lint clean clean-all generate_env_files theme-gen

## —— Help ——————————————————————————————————————————
help: ## Show all available commands
	@echo "$(CYAN)Fandag — Available commands:$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}'

## —— Setup ————————————————————————————————————————
setup: ## Install FVM and dependencies
	@echo "$(YELLOW)Installing FVM...$(RESET)"
	$(FVM) install
	@echo "$(YELLOW)Getting dependencies...$(RESET)"
	$(FLUTTER) pub get
	@echo "$(GREEN)Setup complete!$(RESET)"

init: ## Full initialization (FVM + deps + codegen)
	@echo "$(YELLOW)Full project initialization...$(RESET)"
	bundle install
	$(FVM) install
	$(FLUTTER) pub get
	$(DART) run build_runner build --delete-conflicting-outputs
	$(DART) run slang
	@echo "$(GREEN)Initialization complete!$(RESET)"

i: ## Alias: flutter pub get
	$(FLUTTER) pub get

## —— Code Generation ——————————————————————————————
gen: ## One-time code generation (build_runner)
	$(DART) run build_runner build --delete-conflicting-outputs

watch: ## Code generation in watch mode
	$(DART) run build_runner watch --delete-conflicting-outputs

translations: ## Generate translations (slang)
	$(DART) run slang

## —— Run ——————————————————————————————————————————
run: ## Run application (dev)
	$(FLUTTER) run --dart-define=mb.isTestBuild=true --dart-define=mb.isInspectorOnDebugMode=true

ios: ## Run on iOS simulator
	$(FLUTTER) run -d iPhone --dart-define=mb.isTestBuild=true --dart-define=mb.isInspectorOnDebugMode=true

android: ## Run on Android emulator
	$(FLUTTER) run -d emulator --dart-define=mb.isTestBuild=true --dart-define=mb.isInspectorOnDebugMode=true

run-mock: ## Run application with mock data (no backend)
	$(FLUTTER) run --dart-define=USE_MOCK=true --dart-define=mb.isTestBuild=true --dart-define=mb.isInspectorOnDebugMode=true

## —— Build ————————————————————————————————————————
build-apk: ## Build release APK
	$(FLUTTER) build apk --release --dart-define=mb.isTestBuild=false --dart-define=mb.isInspectorOnDebugMode=false

build-ios: ## Build iOS (no codesign)
	$(FLUTTER) build ios --no-codesign --dart-define=mb.isTestBuild=false --dart-define=mb.isInspectorOnDebugMode=false

build-ipa: ## Build IPA
	$(FLUTTER) build ipa --dart-define=mb.isTestBuild=false --dart-define=mb.isInspectorOnDebugMode=false

## —— Test —————————————————————————————————————————
test: ## Run all tests
	$(FLUTTER) test

test-unit: ## Run unit tests only
	$(FLUTTER) test --exclude-tags widget,integration

test-widget: ## Run widget tests only
	$(FLUTTER) test --tags widget

test-integration: ## Run integration tests
	$(FLUTTER) test integration_test/

test-coverage: ## Run tests with coverage report
	$(FLUTTER) test --coverage
	@echo "$(GREEN)Coverage report generated at coverage/lcov.info$(RESET)"
	@echo "$(YELLOW)To view HTML report: genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html$(RESET)"

test-watch: ## Run tests in watch mode
	$(FLUTTER) test --watch

## —— Analysis —————————————————————————————————————
analyze: ## Static analysis
	$(FLUTTER) analyze

format: ## Format code
	$(DART) format lib/ test/

lint: analyze format ## Analyze + format

## —— Clean ————————————————————————————————————————
clean: ## Flutter clean
	$(FLUTTER) clean
	$(FLUTTER) pub get

clean-all: ## Clean + delete generated files
	$(FLUTTER) clean
	find lib -name "*.g.dart" -delete
	find lib -name "*.freezed.dart" -delete
	find lib -name "*.drift.dart" -delete
	$(FLUTTER) pub get

## —— Theme Generation —————————————————————————————
theme-gen: ## Generate all theme files (palette, colors, fonts)
	$(DART) run tools/template_scripts/bin/template_scripts.dart generate-all

## —— Environment ——————————————————————————————————
generate_env_files: ## Generate environment from config/
	@echo "$(YELLOW)Generating environment files...$(RESET)"
	$(DART) run mad_env_cli:mad_env_cli generate --env-path config/config.env --secret-path config/secrets.env -c config/env_gen_config.json
	@echo "$(GREEN)Environment files generated!$(RESET)"
