##########################################################################
### Variables
###

IMAGE_FILES := daikon-logo.gif daikon-logo.png daikon-logo.eps gui-ControlPanel.jpg gui-ControlPanel.eps gui-InvariantsDisplay-small.jpg gui-InvariantsDisplay-small.eps context-gui.jpg context-gui.eps
IMAGE_PARTIAL_PATHS := $(addprefix images/,$(IMAGE_FILES))
DOC_FILES_NO_IMAGES := Makefile daikon.texinfo daikon.ps daikon.pdf daikon.html CHANGES
DOC_FILES := ${DOC_FILES_NO_IMAGES} $(IMAGE_PARTIAL_PATHS)
DOC_PATHS := $(addprefix doc/,$(DOC_FILES))
EMACS_PATHS := emacs/daikon-context-gui.el
README_FILES := README-daikon-java README-dist
README_PATHS := $(addprefix doc/,$(README_FILES))
SCRIPT_FILES := java-cpp.pl daikon.pl lines-from daikon.cshrc daikon.bashrc createspinfo.pl trace-untruncate trace-purge-fns.pl trace-purge-vars.pl
SCRIPT_PATHS := $(addprefix scripts/,$(SCRIPT_FILES))
# This is so toublesome that it isn't used except as a list of dependences for make commands
DAIKON_JAVA_FILES := $(shell find java \( -name '*daikon-java*' -o -name CVS -o -name 'ReturnBytecodes.java' -o -name 'AjaxDecls.java' -o -name '*ajax-ship*' \) -prune -o -name '*.java' -print) $(shell find java/daikon -follow \( -name '*daikon-java*' -o -name CVS -o -name 'ReturnBytecodes.java' -o -name 'AjaxDecls.java' -o -name '*ajax-ship*' \) -prune -o -name '*.java' -print)
DAIKON_RESOURCE_FILES := daikon/config/configurable.txt daikon/config/example-settings.txt daikon/simplify/daikon-background.txt
AJAX_JAVA_FILES := $(shell find java/ajax-ship/ajax \( -name '*daikon-java*' -o -name CVS -o -name 'ReturnBytecodes.java' -o -name 'AjaxDecls.java' \) -prune -o -name '*.java' -print)
# Find might be cleaner, but this works.
# I don't know why, but a "-o name ." clause makes find err, so use grep instead
# WWW_FILES := $(shell cd doc/www; find . \( -name '*~' -o -name '.*~' -o -name CVS -o -name .cvsignore -o -name '.\#*' -o -name '*.bak' -o -name uw -o name . -o name .. \) -prune -o -print)
# WWW_FILES := $(shell cd doc/www; find . \( \( -name '*~' -o -name '.*~' -o -name CVS -o -name .cvsignore -o -name '.\#*' -o -name '*.bak' -o -name uw \) -prune -a -type f \) -o -print | grep -v '^.$$')
WWW_FILES := $(shell cd doc/www; find . -type f -print | egrep -v '~$$|CVS|.cvsignore|/.\#|.bak$$|uw/')
WWW_DIR := /home/httpd/html/daikon/

MERNST_DIR := /g2/users/mernst
# This is the current directory!  Maybe I don't need a variable for it.
INV_DIR := $(MERNST_DIR)/research/invariants

DFEJ_DIR := $(INV_DIR)/dfej
DFEC_DIR := $(INV_DIR)/dfec
C_RUNTIME_PATHS := front-end/c/daikon_runtime.h front-end/c/daikon_runtime.cc
# Old C front end
# EDG_DIR := $(INV_DIR)/edg/dist
# EDG_DIR := $(INV_DIR)/c-front-end
# $(EDG_DIR)/edgcpfe is distributed separately (not in the main tar file)
# EDG_FILES := $(EDG_DIR)/dump_trace.h $(EDG_DIR)/dump_trace.c $(EDG_DIR)/dfec $(EDG_DIR)/dfec.sh

DIST_DIR := /home/httpd/html/daikon/dist
DIST_BIN_DIR := $(DIST_DIR)/binaries
DIST_PAG_BIN_DIR := /g4/projects/invariants/binaries
# Files that appear in the top level of the distribution directory
DIST_DIR_FILES := daikon-source.tar.gz daikon-compiled.tar.gz daikon-logo.gif daikon.jar
DIST_DIR_PATHS := daikon-source.tar.gz daikon-compiled.tar.gz doc/images/daikon-logo.gif daikon.jar
# # Location for NFS-mounted binaries
# NFS_BIN_DIR := /g2/users/mernst/research/invariants/binaries

CVS_REPOSITORY := /g4/projects/invariants/.CVS/
RTJAR := /g2/users/mernst/java/jdk/jre/lib/rt.jar
TOOLSJAR := /g2/users/mernst/java/jdk/lib/tools.jar

# for "chgrp"
INV_GROUP := invariants

RM_TEMP_FILES := rm -rf `find . \( -name UNUSED -o -name CVS -o -name SCCS -o -name RCS -o -name '*.o' -o -name '*~' -o -name '.*~' -o -name '.cvsignore' -o -name '*.orig' -o -name 'config.log' -o -name '*.java-*' -o -name '*to-do' -o -name 'TAGS' -o -name '.\#*' -o -name '.deps' -o -name jikes -o -name dfej -o -name dfej-linux -o -name dfej-linux-x86 -o -name dfej-solaris -o -name daikon-java -o -name daikon-output -o -name core -o -name '*.bak' -o -name '*.rej' -o -name '*.old' -o -name '.nfs*' -o -name '\#*\#' \) -print`


## Examples of better ways to get the lists:
# PERL_MODULES := $(wildcard *.pm)
# PERL_SCRIPTS := $(wildcard *.pl)
# PERL_SCRIPTS += em_analyze em_reports cppp
# PERL_MODULE_TEXI := $(patsubst %.pm,%.texi,$(PERL_MODULES))
# PERL_MODULE_INFO := $(patsubst %.pm,%.info,$(PERL_MODULES))
# PERL_MODULE_MAN := $(patsubst %.pm,%.man,$(PERL_MODULES))
# PERL_MODULE_HTML := $(patsubst %.pm,%.html,$(PERL_MODULES))


###########################################################################
### Rules
###

### Default tag
help:
	@echo "Targets:"
	@echo " compile compile-java"
	@echo " junit test"
	@echo " tags TAGS"
	@echo "Creating the Daikon distribution:"
	@echo " daikon-compiled.tar daikon-source.tar daikon.jar"
	@echo " dist dist-force"
	@echo " dist-edg dist-edg-solaris"
	@echo " dist-dfej dist-dfej-solaris dist-dfej-linux"
	@echo " examples examples-gries"
	@echo " "
	@echo "This Makefile is for manipulations of the entire invariants module."
	@echo "Daikon proper can be found in the java/daikon subdirectory."

### Compiling the code

compile: compile-java

compile-java:
	cd java/daikon && $(MAKE) all

### Testing the code

test:
	cd tests && $(MAKE) all

junit:
	cd java/daikon && $(MAKE) junit

### Tags

tags: TAGS

TAGS:
	cd java && $(MAKE) tags


###########################################################################
### Test the distribution
###

DISTTESTDIR := /tmp/daikon.dist
DISTTESTDIRJAVA := /tmp/daikon.dist/daikon/java

# Test that the distributed system compiles.
# Don't create any new distribution.
test-the-dist: dist-ensure-directory-exists
	-rm -rf $(DISTTESTDIR)
	mkdir $(DISTTESTDIR)
	(cd $(DISTTESTDIR); tar xzf $(DIST_DIR)/daikon-source.tar.gz)
	## First, test daikon.jar.
	(cd $(DISTTESTDIR)/daikon/java/daikon && $(MAKE) CLASSPATH=$(DISTTESTDIR)/daikon/daikon.jar junit)
	## Second, test the .java files.
	# No need to add to classpath: ":$(DISTTESTDIRJAVA)/lib/jakarta-oro.jar:$(DISTTESTDIRJAVA)/lib/java-getopt.jar:$(DISTTESTDIRJAVA)/lib/junit.jar"
	# Use javac, not jikes; jikes seems to croak on longer-than-0xFFFF
	# method or class.
	(cd $(DISTTESTDIRJAVA)/daikon; touch ../java/ajax; rm `find . -name '*.class'`; make CLASSPATH=$(DISTTESTDIRJAVA):$(DISTTESTDIRJAVA)/lib/log4j.jar:$(RTJAR):$(TOOLSJAR) all_javac)
	(cd $(DISTTESTDIR)/daikon/java/daikon && $(MAKE) CLASSPATH=$(DISTTESTDIRJAVA):$(DISTTESTDIRJAVA)/lib/log4j.jar junit)

# I would rather define this inside the cvs-test rule.  (In that case I
# must use "$$FOO", not $(FOO), to refer to it.)
TESTCVS=/scratch/$(USER)/daikon.cvs
TESTCVSJAVA=$(TESTCVS)/invariants/java

cvs-test:
	-rm -rf $(TESTCVS)
	mkdir -p $(TESTCVS)
	cd $(TESTCVS) && cvs -Q -d $(CVS_REPOSITORY) co invariants
	cd $(TESTCVSJAVA)/daikon && make CLASSPATH=$(TESTCVSJAVA):$(TESTCVSJAVA)/lib/jakarta-oro.jar:$(TESTCVSJAVA)/lib/log4j.jar:$(TESTCVSJAVA)/lib/java-getopt.jar:$(TESTCVSJAVA)/lib/junit.jar:.:$(RTJAR):$(TOOLSJAR)


###########################################################################
### Distribution
###

## The update-link-dates script appears in ~mernst/bin/share/.

# Main distribution

# The "dist" target not only creates .tar files, but also installs a new
# distribution on the website, updates webpages, tests the distribution,
# etc.  If you only want to make a new .tar file, do "make
# daikon-source.tar".
# The "MAKEFLAGS=" argument discards any "-k" argument.  (It doesn't seem
# to work, so supply explicit "-S" flag instead.)
dist: 
	$(MAKE) -S dist-and-test

# Both make and test the distribution.
# (Must make it first in order to test it!)
dist-and-test: dist-notest test-the-dist

dist-ensure-directory-exists: $(DIST_DIR)

# Create the distribution, but don't test it.
dist-notest: dist-ensure-directory-exists $(DIST_DIR_PATHS)
	$(MAKE) update-dist-dir
	$(MAKE) -n dist-dfej

doc/CHANGES: doc/daikon.texinfo
	@echo "** doc/CHANGES file is not up-to-date with respect to doc/daikon.texinfo"
	@echo "** doc/CHANGES must be modified by hand:  try"
	@echo "**   diff -u /home/httpd/html/daikon/dist/doc/daikon.texinfo doc/daikon.texinfo"
	@echo "** (or maybe  touch doc/CHANGES )."
	@exit 1

# Is this the right way to do this?
dist-force:
	-rm -f daikon-source.tar.gz daikon-compiled.tar.gz
	$(MAKE) dist

# 	echo CLASSPATH: $(CLASSPATH)
# 	# echo DAIKON_JAVA_FILES: ${DAIKON_JAVA_FILES}
# 	# Because full distribution has full source, shouldn't need: CLASSPATH=$(DISTTESTDIRJAVA):$(DISTTESTDIRJAVA)/lib/jakarta-oro.jar:$(DISTTESTDIRJAVA)/lib/java-getopt.jar:$(DISTTESTDIRJAVA)/lib/junit.jar:$(RTJAR):$(TOOLSJAR)

# Given up-to-date .tar files, copies them (and documentation) to
# distribution directory (ie, webpage).
update-dist-dir: dist-ensure-directory-exists
	$(MAKE) update-doc-dist-date
	$(MAKE) update-doc-dist-version
	# Would be clever to call "cvs examine" and warn if not up-to-date.
	# Jikes 1.14 doesn't seem to work here; it apparently tries to build
	# a method or class with more than 0xFFFF bytecodes.
	cd java/daikon && $(MAKE) all_via_javac 
	cd java/daikon && $(MAKE) junit
	$(MAKE) update-dist-doc
	$(MAKE) www
	$(MAKE) update-dist-version-file

update-dist-doc:
	# "make" in doc directory will fail the first time, but show output.
	-cd doc && $(MAKE) all
	cd doc && $(MAKE) all
	-cd $(DIST_DIR) && rm -rf $(DIST_DIR_FILES) doc daikon_manual_html
	cp -pf $(DIST_DIR_PATHS) $(DIST_DIR)
	# This isn't quite right:  $(DIST_DIR) should hold the
	# daikon.html from daikon-source.tar.gz, not the current version.
	mkdir $(DIST_DIR)/doc
	cd doc && cp -pf $(DOC_FILES_NO_IMAGES) $(DIST_DIR)/doc
	cp -pR doc/images $(DIST_DIR)/doc
	cp -pR doc/daikon_manual_html $(DIST_DIR)/doc
	# Don't modify files in the distribution directory
	cd $(DIST_DIR) && chmod -R ogu-w $(DIST_DIR_FILES)
	update-link-dates $(DIST_DIR)/index.html

TODAY := $(shell date "+%B %e, %Y")

# Update the documentation with a new distribution date (today).
# This is done immediately before releasing a new distribution.
update-doc-dist-date:
	perl -wpi -e 'BEGIN { $$/="\n\n"; } s/(\@c Daikon version .* date\n\@center ).*(\n)/$$1${TODAY}$$2/;' doc/daikon.texinfo
	perl -wpi -e 's/(version .*, released ).*(\.)$$/$$1${TODAY}$$2/' doc/README-dist doc/www/download/index.html doc/daikon.texinfo
	perl -wpi -e 's/(public final static String release_date = ").*(";)$$/$$1${TODAY}$$2/' java/daikon/Daikon.java
	touch doc/CHANGES

# Update the documentation according to the version number.
# This isn't done as part of "make dist" because then subsequent "make www"
# would show the new version.
# I removed the dependence on "update-dist-version-file" because this rule
# is invoked at the beginning of a make.
update-doc-dist-version:
	perl -wpi -e 'BEGIN { $$/="\n\n"; } s/(Daikon version )[0-9]+(\.[0-9]+)*/$$1 . "$(shell cat doc/VERSION)"/e;' doc/daikon.texinfo doc/README-dist doc/www/download/index.html
	perl -wpi -e 's/(public final static String release_version = ")[0-9]+(\.[0-9]+)*(";)$$/$$1 . "$(shell cat doc/VERSION)" . $$3/e;' java/daikon/Daikon.java
	touch doc/CHANGES

# Update the version number.
# This is done immediately after releasing a new version; thus, VERSION
# refers to the next version to be released, not the previously-released one.
# This isn't a part of the "update-dist-version" target because if it is,
# the "shell cat" command gets the old VERSION file.
# (Note that the last element of VERSION may be negative, such as "-1".
# This is useful in order to make the next version end with ".0".)
update-dist-version-file:
	perl -wpi -e 's/\.(-?[0-9]+)$$/"." . ($$1+1)/e' doc/VERSION

www:
	html-update-toc doc/www/index.html doc/www/mit/index.html
	# "-P" keeps the directory structure in place
	cd doc/www && cp -pfP $(WWW_FILES) $(WWW_DIR)
	cd $(WWW_DIR) && chmod -w $(WWW_FILES)
	update-link-dates $(DIST_DIR)/index.html

.PHONY: www

daikon.jar: java/lib/ajax.jar $(DAIKON_JAVA_FILES) $(patsubst %,java/%,$(DAIKON_RESOURCE_FILES))
	-rm -rf $@ /tmp/daikon-jar
	mkdir /tmp/daikon-jar
	cd java/daikon && $(MAKE) JAVAC='javac -g -d /tmp/daikon-jar -classpath ${INV_DIR}/java:${INV_DIR}/java/lib/jakarta-oro.jar:${INV_DIR}/java/lib/log4j.jar:${INV_DIR}/java/lib/java-getopt.jar:${INV_DIR}/java/lib/junit.jar:$(TOOLSJAR)' all_directly
	cd java/utilMDE && $(MAKE) JAVAC='javac -g -d /tmp/daikon-jar -classpath .:${INV_DIR}/java/lib/junit.jar' all_notest
	## Old untarring code:
	#  tar xzf java/lib/java-getopt-1.0.8.tar.gz -C /tmp/daikon-jar
	#  tar xzf java/lib/OROMatcher-1.1.tar.gz -C /tmp/daikon-jar
	#  mv /tmp/daikon-jar/OROMatcher-1.1.0a/com /tmp/daikon-jar
	#  rm -rf /tmp/daikon-jar/OROMatcher-1.1.0a
	# jar does not seem to accept the -C argument.  MDE 6/14/2001
	# jar xf java/lib/jakarta-oro.jar -C /tmp/daikon-jar
	# jar xf java/lib/java-getopt.jar -C /tmp/daikon-jar
	# jar xf java/lib/junit.jar -C /tmp/daikon-jar
	(cd /tmp/daikon-jar; jar xf $(INV_DIR)/java/lib/jakarta-oro.jar)
	(cd /tmp/daikon-jar; jar xf $(INV_DIR)/java/lib/java-getopt.jar)
	# (cd /tmp/daikon-jar; jar xf $(INV_DIR)/java/lib/jtb-1.1.jar)
	(cd /tmp/daikon-jar; jar xf $(INV_DIR)/java/lib/ajax.jar)
	(cd /tmp/daikon-jar; jar xf $(INV_DIR)/java/lib/junit.jar)
	(cd /tmp/daikon-jar; jar xf $(INV_DIR)/java/lib/log4j.jar)
	(cd java; cp -fP --target-directory=/tmp/daikon-jar $(DAIKON_RESOURCE_FILES))
	cd /tmp/daikon-jar && jar cf $@ *
	mv /tmp/daikon-jar/$@ $@
	rm -rf /tmp/daikon-jar

java/lib/ajax.jar: $(AJAX_JAVA_FILES)
	-rm -rf $@ /tmp/ajax-jar
	mkdir /tmp/ajax-jar
	javac -g -d /tmp/ajax-jar $(AJAX_JAVA_FILES)
	cd /tmp/ajax-jar && jar cf ajax.jar *
	mv /tmp/ajax-jar/ajax.jar $@
	rm -rf /tmp/ajax-jar

# Use this ordering because daikon-compiled is made before daikon-source

DAIKONBUILD=/tmp/daikon.build

# This rule creates the files that comprise the distribution, but does
# not copy them anywhere.
# This rule could be changed to check out a fresh version of the
# repository, then tar from there.  Then there would be no need to be so
# careful about not including extraneous files in the distribution, and one
# could make a distribution even if there were diffs in the current
# checkout.
daikon-compiled.tar daikon-source.tar: $(DOC_PATHS) $(EDG_FILES) $(README_PATHS) $(DAIKON_JAVA_FILES) daikon.jar
	# html-update-toc daikon.html

	-rm -rf /tmp/daikon
	mkdir /tmp/daikon

	mkdir /tmp/daikon/doc
	cp -p doc/README-dist /tmp/daikon/README
	cd doc && cp -p $(DOC_FILES_NO_IMAGES) /tmp/daikon/doc
	mkdir /tmp/daikon/doc/images
	cd doc && cp -p $(IMAGE_PARTIAL_PATHS) /tmp/daikon/doc/images
	cp -pR doc/daikon_manual_html /tmp/daikon/doc

	# Emacs
	mkdir /tmp/daikon/emacs
	cp -p $(EMACS_PATHS) /tmp/daikon/emacs

	# Auxiliary programs
	mkdir /tmp/daikon/bin
	cp -p $(SCRIPT_PATHS) /tmp/daikon/bin

	# Java example files
	cp -pR examples /tmp/daikon
	# Keep .java files, delete everything else
	cd /tmp/daikon && find examples \( -name '*.java' \) -prune -o \( -type f -o -name CVS -o -name daikon-output -o -name daikon-java -o -name daikon-instrumented \) -print | xargs rm -rf
	# C example files
	cp examples/c-examples.tar.gz /tmp/daikon/examples
	cd /tmp/daikon/examples && tar zxf c-examples.tar.gz
	rm /tmp/daikon/examples/c-examples.tar.gz

	chgrp -R $(INV_GROUP) /tmp/daikon

	# Now we are ready to make the daikon-compiled distribution
	cp -p daikon.jar /tmp/daikon
	(cd /tmp; tar cf daikon-compiled.tar daikon)
	cp -pf /tmp/daikon-compiled.tar .

	## Now make the daikon-source distribution
	# First add some more files to the distribution

	# Daikon itself
	(cd java; tar chf /tmp/daikon-java.tar --exclude daikon-java --exclude daikon-output --exclude Makefile.user daikon)
	(mkdir /tmp/daikon/java; cd /tmp/daikon/java; tar xf /tmp/daikon-java.tar; rm /tmp/daikon-java.tar)
	cp -p doc/README-daikon-java /tmp/daikon/java/README
	cp -p java/Makefile /tmp/daikon/java/Makefile
	# Maybe I should do  $(MAKE) doc
	# Don't do  $(MAKE) clean  which deletes .class files
	(cd /tmp/daikon/java; $(RM_TEMP_FILES))

	# Java support files
	## utilMDE
	(cd java/utilMDE; $(MAKE) utilMDE.tar.gz)
	cd java && tar zxf utilMDE/utilMDE.tar.gz -C /tmp/daikon/java
	rm -rf /tmp/daikon/java/utilMDE/doc
	## getopt
	tar zxf java/lib/java-getopt-1.0.8.tar.gz -C /tmp/daikon/java
	## Apache packages
	mkdir /tmp/daikon/java/org
	mkdir /tmp/daikon/java/org/apache
	## OROMatcher
	# Old version:
	#   tar zxf java/lib/OROMatcher-1.1.tar.gz -C /tmp/daikon/java
	#   (cd /tmp/daikon/java; ln -s OROMatcher-1.1.0a/com .)
	tar zxf java/lib/jakarta-oro-2.0.6.tar.gz -C /tmp/daikon/java
	(cd /tmp/daikon/java; mv jakarta-oro-2.0.6/src/java/org/apache/oro org/apache/oro)
	# Making a link causes duplicate-class-def compilation problems,
	# so just create a README file instead.
	(cd /tmp/daikon/java/jakarta-oro-2.0.6/src/java/org/apache; echo "oro directory has been moved to ../../../../../org/apache/oro" > README-oro)
	# ORO distribution .class files are in docs/classes; this is an obscure
	# location, and (more importantly) it also makes too-long file names in
	# the tar file, which causes trouble for some tar programs.
	(cd /tmp/daikon/java/jakarta-oro-2.0.6/docs/classes/org/apache; cp -p --parents `find oro -name '*.class' -print` /tmp/daikon/java/org/apache/)
	rm -rf /tmp/daikon/java/jakarta-oro-2.0.6/docs/classes/org/apache/oro
	(cd /tmp/daikon/java/jakarta-oro-2.0.6/docs/classes/org/apache; echo "oro directory has been moved to ../../../../../org/apache/oro" > README-oro)
	## JTB
	cp -pR java/jtb /tmp/daikon/java/
	## Ajax
	cp -pR java/ajax-ship /tmp/daikon/java
	rm -rf /tmp/daikon/java/ajax-ship/ajax
	cp -pf java/lib/ajax.jar /tmp/daikon/java/ajax-ship/

	## JUnit
	# This is wrong:
	#   unzip java/lib/junit3.7.zip -d /tmp/daikon/java
	#   (cd /tmp/daikon/java; ln -s junit3.7/junit .)
	# Need to extract a jar file in the zip file, then unjar that.
	# (src.jar only contains .java files, not .class files.)
	mkdir /tmp/daikon/tmp-junit
	unzip java/lib/junit3.7.zip junit3.7/src.jar -d /tmp/daikon/tmp-junit
	(cd /tmp/daikon/tmp-junit; unzip junit3.7/src.jar; rm -f junit3.7/src.jar; rmdir junit3.7; chmod -R +x *; find . -type f -print | xargs chmod -x; rm -rf META-INF TMP; mv junit /tmp/daikon/java/)
	rm -rf /tmp/daikon/tmp-junit
	(cd /tmp/daikon/java/junit; javac -g `find . -name '*.java'`)

	## Log4j is a loss; can't include source because its build 
	## configuration is so weird that it cannot be easily integrated.
	mkdir /tmp/daikon/java/lib
	cp -p java/lib/log4j.jar /tmp/daikon/java/lib

	## Front ends
	mkdir /tmp/daikon/front-end

	# # C/C++ instrumenter
	# mkdir /tmp/daikon/front-end/c
	# cp -p $(C_RUNTIME_PATHS) /tmp/daikon/front-end/c

	# Java instrumenter
	# The -h option saves symbolic links as real files, to avoid problem 
	# with the fact that I've made dfej into a symbolic link.
	(cd $(DFEJ_DIR)/..; tar chf /tmp/dfej.tar --exclude '*.o' --exclude 'src/dfej' --exclude 'src.tar' dfej)
	# (cd /tmp/daikon; tar xf /tmp/dfej.tar; mv dfej front-end/java; rm /tmp/dfej.tar)
	# For debugging
	(cd /tmp/daikon; tar xf /tmp/dfej.tar; mv dfej front-end/java)
	# the subsequence rm -rf shouldn't be necessary one day, 
	# but for the time being (and just in case)...
	# (cd /tmp/daikon/java-front-end; $(MAKE) distclean; (cd src; $(MAKE) distclean); $(RM_TEMP_FILES))
	(cd /tmp/daikon/front-end/java; $(MAKE) distclean; $(RM_TEMP_FILES); rm -rf )

	# Make the source distribution proper
	rm -rf `find /tmp/daikon -name CVS`
	(cd /tmp; tar cf daikon-source.tar daikon)
	cp -pf /tmp/daikon-source.tar .

## This apparently does not work
# %.tar.gz : %.tar
# 	-rm -rf $@
# 	gzip -c $< > $@

daikon-source.tar.gz: daikon-source.tar
	-rm -rf $@
	gzip -c $< > $@

daikon-compiled.tar.gz: daikon-compiled.tar
	-rm -rf $@
	gzip -c $< > $@



### Front end binaries

## C/C++ front end

dist-dfec: dist-dfec-linux

dist-dfec-linux:
	cd $(DFEC_DIR) && $(MAKE) dfec dfec-static
	cp -pf $(DFEC_DIR)/src/dfec-static $(DIST_BIN_DIR)/dfec-linux-x86
	cp -pf $(DFEC_DIR)/src/dfec $(DIST_BIN_DIR)/dfec-linux-x86-dynamic
	update-link-dates $(DIST_DIR)/index.html
	# cp -pf $(DFEC_DIR)/src/dfec $(NFS_BIN_DIR)


## Old version
# dist-edg: dist-edg-solaris
# 
# dist-edg-solaris: $(DIST_DIR)/edgcpfe-solaris
# 
# $(DIST_DIR)/edgcpfe-solaris: $(EDG_DIR)/edgcpfe
# 	cp -pf $< $@
# 	update-link-dates $(DIST_DIR)/index.html
# 
# # This is an attempt to indicate that it is not rebuilt from dfec.sh.
# # I seem to have to have a body in the rule.
# $(EDG_DIR)/dfec: $(EDG_DIR)/dfec.sh
# 	@echo

## Java front end

$(DFEJ_DIR)/src/dfej:
	cd $(DFEJ_DIR) && $(MAKE)

## Don't distribute executables for now

# Make the current dfej the one used by the PAG group
# (Warning:  As of 7/3/2002 the DIST_PAG_BIN_DIR version is not used by
# $inv/tests/Makefile.common!)
dist-dfej-pag: $(DFEJ_DIR)/src/dfej
	cp -pf $< $(DIST_PAG_BIN_DIR)

# Make the current dfej the one distributed to the world
dist-dfej: dist-dfej-linux-x86 dist-dfej-windows

dist-dfej-solaris: $(DIST_BIN_DIR)/dfej-solaris

$(DIST_BIN_DIR)/dfej-solaris: $(DFEJ_DIR)/src/dfej-solaris
	cp -pf $< $@
	# strip $@
	chmod +r $@
	update-link-dates $(DIST_DIR)/index.html
	# cat /dev/null | mail -s "make dist-dfej   has been run" kataoka@cs.washington.edu mernst@lcs.mit.edu

dist-dfej-linux-x86: $(DFEJ_DIR)/src/dfej
	# First remake
	-mv -f $(DFEJ_DIR)/src/dfej $(DFEJ_DIR)/src/dfej-dynamic
	-mv -f $(DFEJ_DIR)/src/dfej-linux-x86 $(DFEJ_DIR)/src/dfej
	cd $(DFEJ_DIR)/src && $(MAKE) LDFLAGS=-static
	mv -f $(DFEJ_DIR)/src/dfej $(DFEJ_DIR)/src/dfej-linux-x86
	mv -f $(DFEJ_DIR)/src/dfej-dynamic $(DFEJ_DIR)/src/dfej

	# Now copy it over
	cp -pf $(DFEJ_DIR)/src/dfej-linux-x86 $(DIST_BIN_DIR)/dfej-linux-x86
	cp -pf $(DFEJ_DIR)/src/dfej $(DIST_BIN_DIR)/dfej-linux-x86-dynamic
	strip $(DIST_BIN_DIR)/dfej-linux-x86 $(DIST_BIN_DIR)/dfej-linux-x86-dynamic
	chmod +r $(DIST_BIN_DIR)/dfej-linux-x86 $(DIST_BIN_DIR)/dfej-linux-x86-dynamic
	update-link-dates $(DIST_DIR)/index.html
	# # Unstripped, to permit better debugging
	# cp -pf $(DFEJ_DIR)/src/dfej $(NFS_BIN_DIR)
	# cat /dev/null | mail -s "make dist-dfej   has been run" kataoka@cs.washington.edu mernst@lcs.mit.edu

# Creates the build_mingw_dfej directory.  This probably needs to be redone
# when dfej is changed to include new object files or other Makefile changes.
# Path must include /g2/users/mernst/bin/src/mingw32-linux-x86-glibc-2.1/cross-tools/bin
dfej-src/build_mingw_dfej:
	cd dfej && $(MAKE) distclean
	mkdir dfej-src/build_mingw_dfej
	(setenv PATH /g2/users/mernst/bin/src/mingw32-linux-x86-glibc-2.1/cross-tools/bin:$PATH; cd dfej-src/build_mingw_dfej; ~mernst/research/invariants/dfej/configure --prefix=/tmp/dfej_Xmingw --host=i386-mingw32msvc)
	cd dfej && ./configure

# dfej-src/build_mingw_dfej/src/dfej.exe:
# 	cd dfej-src/build_mingw_dfej; setenv PATH /g2/users/mernst/bin/src/mingw32-linux-x86-glibc-2.1/cross-tools/bin:$(PATH); $(MAKE)

mingw_exe: dfej-src/build_mingw_dfej/src/dfej.exe

## Problem:  I seem to need to move away the .o files in the source
## directory.  If they exist, then no attempt is made to build locally.
## So as a hack, move them aside and then replace them.

dfej-src/build_mingw_dfej/src/dfej.exe: dfej-src/dfej/src/*.cpp dfej-src/dfej/src/*.h
	-rename .o .mingw-saved.o dfej-src/dfej/src/*.o
	(cd dfej-src/build_mingw_dfej; export PATH=/g2/users/mernst/bin/src/mingw32-linux-x86-glibc-2.1/cross-tools/bin:${PATH}; $(MAKE))
	-rename .mingw-saved.o .o dfej-src/dfej/src/*.mingw-saved.o

dist-dfej-windows: dfej-src/build_mingw_dfej/src/dfej.exe
	cp -pf dfej-src/build_mingw_dfej/src/dfej.exe $(DIST_BIN_DIR)/dfej.exe
	chmod +r $(DIST_BIN_DIR)/dfej.exe
	update-link-dates $(DIST_DIR)/index.html

## Cross-compiling DFEJ to create a Windows executable (instructions by
## Michael Harder <mharder@MIT.EDU>):
# 1.  Get the mingw32 cross-compiler for Linux.  Details are avaliable at: 
# http://www.mingw.org/mingwfaq.shtml#faq-cross.  A pre-built version for 
# Linux is available at: 
# http://www.devolution.com/~slouken/SDL/Xmingw32/mingw32-linux-x86-glibc-2.1.tar.gz
# 
# 2.  Extract mingw32-linux-x86-glibc-2.1.tar.gz.  The cross compiler tools 
# are in cross-tools/bin.  The tools start with "i386-mingw32msvc-".  These 
# tools need to be in your path when you build the Windows binary (including
# when you configure the Windows binary).
# 
# 
# The following instructions are adapted from daikon/java-front-end/INSTALL
# 
# 3.  Make a separate directory to build the Windows executable.
# 
# mkdir build_mingw; cd build_mingw
# 
# 4.  Run the dfej configure script, with a target platform of 
# "i386-mingw32msvc".  Assume the dfej source is at ~/daikon/java-front-end.
# 
# ~/daikon/java-front-end/configure --prefix=/tmp/dfej_Xmingw 
# --host=i386-mingw32msvc
# 
# Add additional arguments to configure as desired.  I don't know what the 
# "--prefix" flag is for, but they use it in the jikes INSTALL instructions.
# 
# 5.  Run "make".  This should make the Windows binary at 
# build_mingw/src/dfej.exe.  Copy this file to a Windows machine, and run 
# it.  You should at least get the Daikon usage message.


###########################################################################
### Utilities
###

showvars:
	@echo "DAIKON_JAVA_FILES = " $(DAIKON_JAVA_FILES)
	@echo "AJAX_JAVA_FILES = " $(AJAX_JAVA_FILES)
	@echo "WWW_FILES = " $(WWW_FILES)
