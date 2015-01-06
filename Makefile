BUILDDIR=build
SRCDIR=main src test

CC=gcc -std=c99
#CFLAGS=-W -Wall -O2
CFLAGS=-W -Wall -pedantic -O0 -g -fmax-errors=2
INCLUDES=-Iinclude

LEXSRC=$(shell find lex -type f -name \*.l)
ALLSRC=$(shell find $(SRCDIR) -type f -name \*.c) $(LEXSRC:.l=.c)
OBJ=$(patsubst %.c, $(BUILDDIR)/%.o, $(filter src/% lex/%, $(ALLSRC)))
TESTS=$(patsubst %.c, $(BUILDDIR)/%, $(filter test/%, $(ALLSRC)))
DEPENDS=$(ALLSRC:%.c=$(BUILDDIR)/%.d)
#BUILDSUBDIR=$(shell find $(SRCDIR) -type d | sed s:^:$(BUILDDIR)/:)
MAIN=main/main

hashlife: $(BUILDDIR)/hashlife

$(BUILDDIR)/hashlife: $(BUILDDIR)/$(MAIN)
	ln -f $< $@

$(BUILDDIR)/%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(BUILDDIR)/%.d: %.c
	@mkdir -p $(@D)
	@$(CC) $(INCLUDES) -MM $< -MT $(@:.d=.o) -MF $@

#tests and stuff
$(BUILDDIR)/%: $(BUILDDIR)/%.o $(OBJ)
	$(CC) $(CFLAGS) $(INCLUDES) $(OBJ) $< -o $@

tests: $(TESTS)

clean:
	rm -rf $(BUILDDIR)
	rm -f lex/*.c

.PHONY: builddir clean tests
.SECONDARY:

ifneq ($(MAKECMDGOALS), clean)
-include $(DEPENDS)
endif

