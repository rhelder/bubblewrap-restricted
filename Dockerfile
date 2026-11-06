# syntax=docker/dockerfile:1

FROM archlinux:base-devel

ARG PKGBUILD="./PKGBUILD"

RUN pacman --noconfirm -Syu devtools && \
  pacman --noconfirm -Scc && \
  install -vDm644 -T /usr/share/devtools/makepkg.conf.d/x86_64.conf /etc/makepkg.conf && \
  rm -vrf /etc/makepkg.conf.d && \
  mkdir -vp /etc/makepkg.conf.d && \
  install -vDm644 -t /etc/makepkg.conf.d /usr/share/devtools/makepkg.conf.d/x86_64.conf.d/* && \
  install -vDm644 -T /usr/share/devtools/pacman.conf.d/extra.conf /etc/pacman.conf && \
  sed -i '/^\[core\]$/i [selinux]\nServer = https:\/\/github.com\/archlinuxhardened\/selinux\/releases\/download\/ArchLinux-SELinux\nSigLevel = Never\n' /etc/pacman.conf && \
  useradd -m builduser

RUN --mount=type=bind,source=$PKGBUILD,target=/tmp/PKGBUILD,rw \
  chown builduser:builduser /tmp/PKGBUILD && \
  for dep in $(runuser -u builduser -- sh -c '. /tmp/PKGBUILD; printf "%s\n" "${depends[@]}" "${makedepends[@]}" "${checkdepends[@]}"'); do \
    printf '%s\0' "${dep%%[<=>]*}"; \
  done | xargs -0 pacman --noconfirm --disable-sandbox-filesystem -Syu --asdeps && \
  pacman --noconfirm -Scc

ENV PKGDEST="/home/builduser/packages"
ENV PACKAGER="Russell Wright Helder <rwh@russellhelder.net>"
