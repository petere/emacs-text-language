EMACS = emacs

OBJS = text-language.elc

all: $(OBJS)

clean:
	$(RM) $(OBJS)

%.elc: %.el
	$(EMACS) -Q --batch -f batch-byte-compile $<

.PHONY: all clean
