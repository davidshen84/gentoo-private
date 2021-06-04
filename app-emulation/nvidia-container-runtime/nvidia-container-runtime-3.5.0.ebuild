# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A modified version of runc adding a custom pre-start hook to all containers."
HOMEPAGE="https://github.com/NVIDIA/nvidia-container-runtime"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND=">=dev-lang/go-1.4
>=app-emulation/nvidia-container-toolkit-1.5.0"

SRC_URI="https://www.github.com/NVIDIA/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

src_compile() {
	cd src
	emake build
}

src_install() {
	dobin src/nvidia-container-runtime
}
