FVM_CMD := fvm flutter

dart-fix-format:
	fvm dart fix --apply . &&\
	fvm dart format .

pub-get:
	$(FVM_CMD) pub get

clean:
	rm -f pubspec.lock \
	&& $(FVM_CMD) clean

clean-get:
	make clean && make pub-get

runner-build:
	 $(FVM_CMD) pub run build_runner build -d \
	&& make dart-fix-format