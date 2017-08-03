.PHONY: build release install uninstall clean test doc reindent

build:
	jbuilder build @install --dev -j $$(getconf _NPROCESSORS_ONLN)

release:
	jbuilder build @install

install:
	jbuilder install

uninstall:
	jbuilder uninstall

clean:
	jbuilder clean

test:
	jbuilder runtest --dev

# requires odoc
doc:
	jbuilder build @doc

reindent:
	find lib* -name *.ml -o -name *.mli | xargs ocp-indent --syntax cstruct -i
