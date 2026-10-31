# Maintainer: Russell Wright Helder <rwh[at]russellhelder[dot]net>
#
# Forked from Arch Linux's bubblewrap package:
# Maintainer: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
# Maintainer: Levente Polyak <anthraxx[at]archlinux[dot]org>
# Contributor: Bartłomiej Piotrowski <bpiotrowski@archlinux.org>

_name=bubblewrap
pkgname=bubblewrap-restricted
pkgver=0.13.1
pkgrel=1
pkgdesc='Unprivileged sandboxing tool, with SELinux support and without --cap-add option'
url='https://github.com/containers/bubblewrap'
arch=(x86_64)
license=(LGPL-2.1-or-later)
depends=(
  glibc
  libcap
  libselinux
  libgcc
)
makedepends=(
  bash-completion
  docbook-xsl
  git
  libxslt
  meson
)
provides=(bubblewrap)
conflicts=(bubblewrap)
source=(
  "git+$url?signed#tag=v$pkgver"
  "$_name-utils-$pkgver.tar.gz::https://codeberg.org/HastD/$_name-utils/archive/v$pkgver.tar.gz"
)
b2sums=(
  'c7e182d4bb08afcba1bdc4beae77106a6fa75e366f328642f6703ca10299e24ee44ca428f78b00617dfee3e758e68885f889c940c1aa48e7a5c1d3d0baa5c133'
  '00476dad5836b5143d7f5abf4ab68b458b2e9a59820f0a60b52969b4fa428895ba3d44769ebe8f9b3d3c4ebbe1fdae9f8006229b2189145b48b6161c0259b12f'
)
validpgpkeys=(
  DA98F25C0871C49A59EAFF2C4DE8FF2A63C7CC90 # Simon McVittie <smcv@collabora.com>
  252C6FEA78A69D3BC0AD458A616C5BDC0C29AB04 # Alexander Larsson <alexl@redhat.com>
)

prepare() {
  cd $_name
  patch -N -i ../$_name-utils/restricted/bubblewrap.c.patch
  patch -N -i ../$_name-utils/restricted/bwrap.xml.patch
}

build() {
  local meson_options=(
    # major.minor.0 of linux-lts
    -D assume_kernel=6.18.0

    -D selinux=enabled

    -D man=enabled
  )

  arch-meson $_name build "${meson_options[@]}"
  meson compile -C build
}

check() {
  # Broken in our build containers
  meson test -C build --print-errorlogs || :
}

package() {
  replaces=("bubblewrap-suid<=0.11.2-1")

  meson install -C build --destdir "$pkgdir"
}

# vim:set sw=2 sts=-1 et:
