.PHONY: ff dart-fix-format dart-analyze dart-fix-format-analyze pub-get run-staging build-apk-release build-apk-staging build-apk-debug build-ipa-staging build-ipa-prod build-appbundle clean clean-get runner-clean runner-build runner-watch clean-runner-watch clean-runner-build pub-get-runner-build clean-build-apk pod-install pod-update ios-precache amplify-prod amplify-staging deploy-ipa build-ipa-staging-deploy build-ipa-prod-deploy

FVM_CMD := fvm flutter

ff:
	$(FVM_CMD)

dart-fix-format:
	fvm dart fix --apply . &&\
	fvm dart format .

dart-analyze:
	fvm dart analyze . || echo "Complete analyze with warning"

dart-fix-format-analyze:
	make dart-fix && make dart-analyze

pub-get:
	$(FVM_CMD) pub get

run-staging:
	$(FVM_CMD) run --flavor dev --dart-define-from-file=config.json

build-apk-release:
	$(FVM_CMD) build apk --flavor prod --release --dart-define-from-file=config.json

build-apk-staging:
	$(FVM_CMD) build apk --flavor dev --release --dart-define-from-file=config.json 

build-apk-debug:
	$(FVM_CMD) build apk --debug --flavor dev --dart-define-from-file=config.json

build-ipa-staging:
	$(FVM_CMD) build ipa --flavor dev --release --dart-define-from-file=config_ios.json

build-ipa-prod:
	$(FVM_CMD) build ipa --flavor prod --release --dart-define-from-file=config_ios.json

build-appbundle:
	$(FVM_CMD) build appbundle --flavor prod --dart-define-from-file=config.json

clean:
	rm -f pubspec.lock \
	&& $(FVM_CMD) clean

clean-get:
	make clean && make pub-get

runner-clean:
	$(FVM_CMD) pub run build_runner clean

runner-build:
	make runner-clean && $(FVM_CMD) pub run build_runner build -d \
	&& make dart-fix-format

runner-watch:
	make runner-clean && $(FVM_CMD) pub run build_runner watch -d

clean-runner-watch:
	make clean-get && make runner-watch

clean-runner-build:
	make clean-get && make runner-build

pub-get-runner-build:
	make pub-get && make runner-build

clean-build-apk:
	make clean-get && make build-apk-release

pod-install:
	make clean-get && cd ios && pod install && cd ..

pod-update:
	make clean-get \
	&& cd ios \
	&& rm -f Podfile.lock \
	&& pod install --repo-update \
	&& cd ..

ios-precache:
	$(FVM_CMD) precache --ios

amplify-prod:
	amplify pull --appId d16y08i2zlapy3 --envName prod -y

amplify-staging:
	amplify pull --appId d16y08i2zlapy3 --envName staging -y

deploy-ipa:
	xcrun altool --upload-app --type ios -f build/ios/ipa/Findit.ipa --apiKey 62FDTTR46D --apiIssuer 1e6dd427-2604-4f24-a389-a6c736f2d28b

build-ipa-staging-deploy:
	make build-ipa-staging && make deploy-ipa

build-ipa-prod-deploy:
	make build-ipa-prod && make deploy-ipa