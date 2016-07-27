## Copyright 2015-2016 Carnë Draug
## Copyright 2015-2016 Oliver Heimlich
##
## Copying and distribution of this file, with or without modification,
## are permitted in any medium without royalty provided the copyright
## notice and this notice are preserved.  This file is offered as-is,
## without any warranty.

PACKAGE := $(shell grep "^Name: " DESCRIPTION | cut -f2 -d" ")
VERSION := $(shell grep "^Version: " DESCRIPTION | cut -f2 -d" ")

TARGET_DIR      := target
RELEASE_DIR     := $(TARGET_DIR)/$(PACKAGE)-$(VERSION)
RELEASE_TARBALL := $(TARGET_DIR)/$(PACKAGE)-$(VERSION).tar.gz
HTML_DIR        := $(TARGET_DIR)/$(PACKAGE)-html
HTML_TARBALL    := $(TARGET_DIR)/$(PACKAGE)-html.tar.gz
SIG_RELEASE_TARBALL:= $(TARGET_DIR)/$(PACKAGE)-$(VERSION).tar.gz.sig
EXPORT_DIR      := ../release

M_SOURCES := $(wildcard inst/*.m)
PKG_ADD   := $(shell grep -Pho '(?<=(\#\#|%%) PKG_ADD: ).*' $(M_SOURCES))

MFILES_SUBDIRS := $(shell find inst/mfiles -maxdepth 1 -type d -print)

OCTAVE ?= octave --no-window-system --silent

.PHONY: help dist html release install all check run clean

help:
	@echo "Targets:"
	@echo "   dist    - Create $(RELEASE_TARBALL) for release from last git commit"
	@echo "   sign    - Create the sign file $(SIG_RELEASE_TARBALL) from $(RELEASE_TARBALL)"
	@echo "   html    - Create $(HTML_TARBALL) for release from last git commit"
	@echo "   release - Create both of the above (dist/html) and make/show md5sum files"
	@echo 
	@echo "   move    - Move the tar.gz and md5sum files reated by release to $(EXPORT_DIR)"
	@echo '   clean   - Remove the "$(TARGET_DIR)/" directory (with releases and html documentation)'
	@echo 
	@echo "Targets (Additionals):"
	@echo "   install - Install the $(PACKAGE) package in GNU Octave (uses first: dist)"
	@echo "   check   - Execute package tests (w/o install)"
	@echo "   run     - Run Octave with development in PATH (no install)"
	@echo


%.tar.gz: %
	tar -c -f - --posix -C "$(TARGET_DIR)/" "$(notdir $<)" | gzip -9n > "$@"

$(RELEASE_DIR): .git/index
	@echo "Creating package version $(VERSION) release ..."
	-$(RM) -r "$@"
	git archive --format=tar --prefix="$@/" HEAD | tar -x
	$(RM) "$@/Makefile"
	$(RM) "$@/.gitignore"
	chmod -R a+rX,u+w,go-w "$@"

$(HTML_DIR): install
	@echo "Generating HTML documentation. This may take a while ..."
	-$(RM) -r "$@"
	$(OCTAVE) --no-window-system --silent \
	  --eval "pkg load generate_html; " \
	  --eval "pkg load $(PACKAGE);" \
	  --eval "options = get_html_options ('octave-forge');" \
	  --eval "options.package_doc = 'overview.texi';" \
	  --eval "options.package_doc_options = [options.package_doc_options,' --css-ref=manual.css ']; "\
	  --eval 'generate_package_html ("${PACKAGE}", "$@", options);'
	chmod -R a+rX,u+w,go-w $@

dist: $(RELEASE_TARBALL)
html: $(HTML_TARBALL)
sign: dist 
	@echo 
	cd $(TARGET_DIR); gpg -b --use-agent  $(notdir $(RELEASE_TARBALL)) 
	cd $(TARGET_DIR); gpg --verify $(notdir $(SIG_RELEASE_TARBALL)) 


release: dist html
	@echo 
	cd $(TARGET_DIR); md5sum $(notdir $(RELEASE_TARBALL)) > $(notdir $(RELEASE_TARBALL).md5)
	cd $(TARGET_DIR); md5sum $(notdir $(HTML_TARBALL))  > $(notdir $(HTML_TARBALL).md5)
	@echo 	
	@echo "====================================================================="
	@echo "Tasks:"
	@echo "1) Upload to https://sourceforge.net/p/octave/package-releases/new/"
	@echo '   all the tar.gz  and md5 files located in "$(TARGET_DIR)/" and post :'
	@echo 	
	@echo "   Please upload the attached:"
	@echo "   "`cat $(RELEASE_TARBALL).md5`
	@echo "   "`cat $(HTML_TARBALL).md5`
	@echo "   to check: "
	@echo "              md5sum -c $(notdir $(RELEASE_TARBALL).md5)"
	@echo "              md5sum -c $(notdir $(HTML_TARBALL).md5)"
	@echo 	
	@echo '2) After being accepted, execute: '
	@echo '            git tag -a ${VERSION} -m "release-${VERSION}"'
	@echo 	
	@echo "   to mark the current version no repository."
	@echo "====================================================================="
	@echo 	

install: $(RELEASE_TARBALL)
	@echo "Installing package locally ..."
	$(OCTAVE) --eval 'pkg ("install", "${RELEASE_TARBALL}")'

check:
	for d in $(MFILES_SUBDIRS); do \
	  $(OCTAVE) --path "inst/" --eval '${PKG_ADD}' \
	    --eval "runtests (\"$$d\");" ; \
	done

run:
	$(OCTAVE) --persist --path "inst/" --eval '${PKG_ADD}'

move: release
	mkdir -p $(EXPORT_DIR)
	cp -v --remove-destination --target-directory=$(EXPORT_DIR) \
	$(RELEASE_TARBALL).md5 $(HTML_TARBALL).md5 $(RELEASE_TARBALL) $(HTML_TARBALL)
clean:
	$(RM) -r $(TARGET_DIR)
