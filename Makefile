.PHONY: all test clean webclient

COFFEE = node_modules/.bin/coffee
UGLIFY = node_modules/.bin/uglifyjs

CLIENT = \
	web-prelude.coffee \
	microevent.coffee \
	doc.coffee \
	connection.coffee \
	index.coffee \
	textarea.coffee

BUNDLED_TYPES = \
	node_modules/ot-types/webclient/text.js \
	src/types/text-api.coffee \
#	node_modules/ot-types/webclient/json0.js

CLIENT_SRCS = $(addprefix src/client/, $(CLIENT))

all: webclient

clean:
	rm -rf lib
	rm -rf webclient

test:
	node_modules/.bin/mocha

webclient/share.uncompressed.js: $(CLIENT_SRCS) $(BUNDLED_TYPES)
	mkdir -p webclient
	echo '(function(){' > $@
	cat $(filter %.js,$^) >> $@
	coffee -bpc $(filter %.coffee,$^) >> $@
	echo '})();' >> $@


# Uglify.
webclient/%.js: webclient/%.uncompressed.js
	$(UGLIFY) $< -cmo $@

# Compile the types for a browser.
webclient: webclient/share.js
	cp node_modules/ot-types/webclient/text.js webclient/
	cp node_modules/ot-types/webclient/json0.js webclient/
	cp node_modules/ot-types/webclient/json0.uncompressed.js webclient/

