TEST_SCHEME := Runner
TEST_PROJECT := ios/Runner.xcworkspace
TEST_SDK := iphonesimulator
TESET_DESTINATION := 'platform=iOS Simulator,OS=latest,name=iPhone 16'

.PHONY: test
test:
	set -o pipefail && \
	xcodebuild test \
	-workspace $(TEST_PROJECT) \
	-configuration Debug \
	-scheme $(TEST_SCHEME) \
	-sdk $(TEST_SDK) \
	-destination $(TESET_DESTINATION) \
	CODE_SIGNING_ALLOWED='NO' \
	| xcbeautify
