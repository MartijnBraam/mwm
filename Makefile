# mwm - mobile window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = mwm.c
OBJ = ${SRC:.c=.o}

all: options mwm

options:
	@echo dwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

mwm: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f mwm ${OBJ} mwm-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p mwm-${VERSION}
	@cp -R LICENSE Makefile README config.def.h config.mk \
		mwm.1 ${SRC} mwm-${VERSION}
	@tar -cf mwm-${VERSION}.tar mwm-${VERSION}
	@gzip mwm-${VERSION}.tar
	@rm -rf mwm-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f mwm ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/mwm
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < mwm.1 > ${DESTDIR}${MANPREFIX}/man1/mwm.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/mwm
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/mwm.1

.PHONY: all options clean dist install uninstall
