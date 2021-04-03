# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="The NVIDIA Container Toolkit."
HOMEPAGE="https://github.com/NVIDIA/nvidia-container-toolkit"
SRC_URI="https://github.com/NVIDIA/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="dev-lang/go
sys-libs/libnvidia-container"

go-module_set_globals

src_compile() {
	emake binary
}

src_install() {
	dobin ${PN}
	newconfd config/config.toml.ubuntu nvidia-container-runtime
}
