default:
	mkdir -p build	
	perl src/sprite.pl

test:
	prove t

fetch:
	perl6 src/fetch.pl > data/iso_3166_1.txt

release:
	git tag RELEASE_${VERSION}
	git push --tags
	zip -j famflags-${VERSION}.zip build/*
	echo "upload https://github.com/coke/famflags/downloads"

clean:
	rm -rf build famflags*.zip
