.PHONY: bootstrap
bootstrap:
	@mint bootstrap

.PHONY: format
format:
	@xcrun --sdk macosx mint run swiftformat swiftformat .

.PHONY: lint
lint:
	@xcrun --sdk macosx mint run swiftformat swiftformat --lint .
	@xcrun --sdk macosx mint run swiftlint swiftlint lint
