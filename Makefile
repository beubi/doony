clean:
	rm -rf venv node_modules

venv:
	virtualenv venv

install: venv
	. venv/bin/activate; pip install flask
	npm install .
	gem install observr

	@echo "\033[95m\n\nDone. To install the Doony theme in your local Jenkins, \
follow the 'Installation' instructions in README.md\033[0m"

serve:
	. venv/bin/activate; python run.py

# Run this command to update AUTHORS.md with the latest contributors.
authors:
	echo "Authors\n=======\n" > AUTHORS.md
	git log --raw | grep "^Author: " | sort | uniq | cut -d ' ' -f2- | sed 's/^/- /' >> AUTHORS.md

watch:
	./observr.rb

css:
	scss --style expanded src/doony.scss > doony.css
	scss --style compressed src/doony.scss > doony.min.css

jshint:
	# Checking the file with jshint
	./node_modules/jshint/bin/jshint --verbose src/ProgressCircle.js src/theme.js

js: jshint
	# Concatenating JS files...
	@cat src/ProgressCircle.js > doony.js && \
	cat src/theme.js >> doony.js
	
	# Minifying Javascript...
	./node_modules/uglify-js/bin/uglifyjs --preamble "/* Doony v`cat VERSION` | (c) `date +%Y` Kevin Burke | License: MIT */" --source-map doony.js.map --compress --lint --verbose doony.js > doony.min.js
