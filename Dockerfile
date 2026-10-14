ARG DEBIAN_DIST=trixie
FROM debian:$DEBIAN_DIST

ARG DEBIAN_DIST
ARG tldr_VERSION
ARG BUILD_VERSION
ARG FULL_VERSION
ARG ARCH
ARG TLRC_RELEASE

RUN mkdir -p /output/usr/bin
RUN mkdir -p /output/usr/share/doc/tldr
RUN mkdir -p /output/usr/share/man/man1
RUN mkdir -p /output/usr/share/bash-completion/completions
RUN mkdir -p /output/usr/share/fish/vendor_completions.d
RUN mkdir -p /output/usr/share/zsh/vendor-completions
RUN mkdir -p /output/DEBIAN

COPY ${TLRC_RELEASE}/tldr /output/usr/bin/
COPY ${TLRC_RELEASE}/tldr.1 /output/usr/share/man/man1/
COPY ${TLRC_RELEASE}/completions/tldr.bash /output/usr/share/bash-completion/completions/tldr
COPY ${TLRC_RELEASE}/completions/tldr.fish /output/usr/share/fish/vendor_completions.d/
COPY ${TLRC_RELEASE}/completions/_tldr /output/usr/share/zsh/vendor-completions/
RUN gzip -9n /output/usr/share/man/man1/*.1
COPY output/DEBIAN/control /output/DEBIAN/
COPY output/DEBIAN/postinst /output/DEBIAN/postinst
RUN chmod 755 /output/DEBIAN/postinst
COPY output/copyright /output/usr/share/doc/tldr/
COPY output/changelog.Debian /output/usr/share/doc/tldr/
COPY output/README.md /output/usr/share/doc/tldr/

RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/usr/share/doc/tldr/changelog.Debian
RUN sed -i "s/FULL_VERSION/$FULL_VERSION/" /output/usr/share/doc/tldr/changelog.Debian
RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/DEBIAN/control
RUN sed -i "s/tldr_VERSION/$tldr_VERSION/" /output/DEBIAN/control
RUN sed -i "s/BUILD_VERSION/$BUILD_VERSION/" /output/DEBIAN/control
RUN sed -i "s/SUPPORTED_ARCHITECTURES/$ARCH/" /output/DEBIAN/control

RUN dpkg-deb --build /output /tldr_${FULL_VERSION}.deb
