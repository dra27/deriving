include Makefile.config

all: META
	${MAKE} -C syntax
	${MAKE} -C lib

byte: META
	${MAKE} -C syntax byte
	${MAKE} -C lib byte

opt: META
	${MAKE} -C syntax opt
	${MAKE} -C lib opt

META: META.in
	sed s/%%NAME%%/${PROJECTNAME}/ META.in > META

clean: clean.local
	${MAKE} -C syntax clean DEPEND=no
	${MAKE} -C lib clean DEPEND=no
	${MAKE} -C tests clean
clean.local:
	-rm -f META

distclean: clean.local
	${MAKE} -C syntax distclean DEPEND=no
	${MAKE} -C lib distclean DEPEND=no
	${MAKE} -C tests distclean
	-rm -f *~ \#* .\#*

.PHONY: tests
tests:
	${MAKE} -C tests
	./tests/tests

include Makefile.filelist
VERSION := $(shell head -n 1 VERSION)

install:
	${OCAMLFIND} install ${PROJECTNAME} \
	  -patch-version ${VERSION} \
	  META ${SYNTAX_INTF} ${INTF} ${IMPL} ${NATIMPL} ${DOC}

install-byte:
	${OCAMLFIND} install ${PROJECTNAME} \
	  -patch-version ${VERSION} \
	  META ${SYNTAX_INTF} ${INTF} ${IMPL} ${DOC}

install-opt:
	${OCAMLFIND} install ${PROJECTNAME} \
	  -patch-version ${VERSION} \
	  META ${SYNTAX_INTF} ${INTF} ${NATIMPL} ${DOC}

uninstall:
	${OCAMLFIND} remove ${PROJECTNAME}

reinstall: uninstall install
reinstall-byte: uninstall install-byte
reinstall-opt: uninstall install-opt