# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The NVIDIA Container Toolkit."
HOMEPAGE="https://github.com/NVIDIA/nvidia-docker"
SRC_URI="https://github.com/NVIDIA/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND=">=x11-drivers/nvidia-drivers-460.39[driver(+)]
app-emulation/nvidia-container-runtime"

src_compile() {
	:
}

src_install() {
	dobin nvidia-docker
	insinto etc/docker
	doins daemon.json
}
