PREFIX ?= /usr/local
PWD = `pwd`
JSCOV = support/jscoverage/node-jscoverage
JS_FILES = $(shell find ./lib | grep index.js && find lib | awk '!/index.js/ && /.js/' )
BENCHMARKS = `find benchmark -name *.benchmark.js `
DOC_COMMAND=java -jar ./support/jsdoc/jsrun.jar ./support/jsdoc/app/run.js -t=./support/jsdoc/templates/CoolTemplate -d=./docs -D="github:Pollenware/comb"

test:
	export NODE_PATH=$NODE_PATH:lib && ./node_modules/it/bin/it -r dotmatrix

test-coverage:
	rm -rf ./lib-cov && node-jscoverage ./lib ./lib-cov && export NODE_PATH=$NODE_PATH:lib-cov && ./node_modules/it/bin/it -r dotmatrix

docs: docclean
	$(DOC_COMMAND) $(JS_FILES)

docclean :
	rm -rf docs

benchmarks:
	for file in $(BENCHMARKS) ; do \
		node $$file ; \
	done

install: install-jscov

install-jscov: $(JSCOV)
	install $(JSCOV) $(PREFIX)/bin

$(JSCOV):
	cd support/jscoverage && ./configure && make && mv jscoverage node-jscoverage

uninstall:
	rm -f $(PREFIX)/bin/node-jscoverage

.PHONY: install install-jscov test docs docclean uninstall



