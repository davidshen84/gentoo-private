# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker xdg-utils

DESCRIPTION="Lens is the only IDE for Kubenetes."
HOMEPAGE="https://k8slens.dev/index.html"
REV="latest.20210722.1"
SRC_URI="https://api.k8slens.dev/binaries/Lens-${PV}-${REV}.amd64.deb"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0"
S="${WORKDIR}"
QA_PREBUILT="/opt/*"

src_prepare() {
	default

	unpack "$S/usr/share/doc/lens/changelog.gz"
	rm -r "$S/usr/share/doc/lens"
}

src_compile() {
	:
}

src_install() {
	dodoc changelog

	insinto /
	doins -r opt
	fperms +x /opt/Lens/lens
	fperms 4755 /opt/Lens/chrome-sandbox
	fperms 4755 /opt/Lens/resources/x64/kubectl

	insinto /
	doins -r usr
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
