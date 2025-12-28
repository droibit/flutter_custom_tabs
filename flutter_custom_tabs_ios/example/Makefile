TEST_SCHEME := Runner
TEST_PROJECT := ios/Runner.xcworkspace
TEST_SDK := iphonesimulator
TEST_DESTINATION := 'platform=iOS Simulator,OS=latest,name=iPhone 17'

.PHONY: test
test:
	set -o pipefail && \
	xcodebuild test \
	-workspace $(TEST_PROJECT) \
	-configuration Debug \
	-scheme $(TEST_SCHEME) \
	-sdk $(TEST_SDK) \
	-destination $(TEST_DESTINATION) \
	CODE_SIGNING_ALLOWED='NO' \
	| xcbeautify
