.PHONY: bootstrap
bootstrap:
	@brew install mint
	@mint bootstrap

.PHONY: format
format:
	@swiftformat .

.PHONY: lint
lint:
	@xcrun --sdk macosx mint run swiftformat swiftformat --lint .
	@xcrun --sdk macosx mint run swiftlint swiftlint lint
