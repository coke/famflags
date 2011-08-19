default:
	mkdir -p build	
	perl src/sprite.pl

test:
	prove t

fetch:
	perl src/fetch.pl > data/iso_3166_1.txt

clean:
	rm -rf build
