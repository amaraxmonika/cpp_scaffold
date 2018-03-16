## This is my attempt to make a minimal comprehensive makefile
## that could be used to start a large project. This will build
## your project and generate a minimal linux package.

PROJECT_NAME := "your_project"

CC       := g++
SRCDIR   := src
BUILDDIR := build
TARGET   := bin/your_target

# Version: Versioning will inevitably come up before releasing to production
# so we might as well put it in here now
MAJOR_VERSION := "1"
MINOR_VERSION := "0"
MINOR_REVISION := "0"
DISTVERSION := "$(MAJOR_VERSION).$(MINOR_VERSION)-$(MINOR_REVISION)"
DISTNAME    := "$(PROJECT_NAME)_$(DISTVERSION)"

# Here were defining a few variables that will be used for generating 
# our minimal dpkg installer package.
DISTDIR     := "dist"
DISTBINDIR  := $(DISTDIR)/usr/local/bin
DISTOPTDIR  := $(DISTDIR)/opt/$(PROJECT_NAME)
DISTCONFDIR := $(DISTDIR)/etc/$(PROJECT_NAME)

# Assuming this is a c++ project, these next few lines generate a list of
# source files to be compiled into object files.
SRCEXT  := cpp
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))
CFLAGS  := -std=c++11 -DMAJOR_VERSION=$(MAJOR_VERSION) \
		   -DMINOR_VERSION=$(MINOR_VERSION) -DMINOR_REVISION=$(MINOR_REVISION)

EXTERNAL_LIB_DIRS := -L lib    # -L other lib dirs here...
LIB :=  -pthread               # -l other libs here...
LIB := $(EXTERNAL_LIB_DIRS) $(LIB) 

INC := -I include  # -I other include dirs here

## catchall: This will be the target if none is specified
ALL: $(OBJECTS) test

# generic rule for building all object files
$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(BUILDDIR)
	@echo " $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

# clean target to delete all object files and binaries
clean:
	@echo " Cleaning..."; 
	@echo " $(RM) -r $(BUILDDIR) $(TARGET)"; $(RM) -r $(BUILDDIR) $(TARGET)
	@echo " $(RM) -r $(DISTDIR) $(DISTNAME)"; $(RM) -r $(DISTDIR) $(DISTNAME)


# This target is used for generating your debian package
dist:
	if [ -d $(DISTDIR) ]; then rm -rf $(DISTDIR); fi
	mkdir -p $(DISTCONFDIR)
	mkdir -p $(DISTBINDIR)
	mkdir -p $(DISTOPTDIR)
	cp -r templates/* $(DISTDIR)
	cp conf/config.json $(DISTCONFDIR)
	cp bin/* $(DISTBINDIR)
	rm -rf $(DISTNAME)
	cp -r dist $(DISTNAME)
	dpkg-deb --build $(DISTNAME)


## your actual targets go here
test: $(OBJECTS)
	$(CC) $(CFLAGS) src/test.cpp $(INC) -o bin/test

