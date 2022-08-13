# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

# go-module_set_globals

DESCRIPTION="The NVIDIA Container Toolkit."
HOMEPAGE="https://github.com/NVIDIA/nvidia-container-toolkit"
SRC_URI="https://github.com/NVIDIA/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

KEYWORDS="amd64"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="dev-lang/go
~sys-libs/libnvidia-container-1.10.0"

NVIDIA_CONTAINER_RUNTIME_HOOK=usr/bin/nvidia-container-runtime-hook

src_compile() {
	emake binaries
}

src_install() {
	dobin ${PN}
	dobin nvidia-container-runtime
	dosym ${PN} ${NVIDIA_CONTAINER_RUNTIME_HOOK}

	mkdir -p etc/nvidia-container-runtime
	insinto etc/nvidia-container-runtime
	newins config/config.toml.ubuntu config.toml
}

pkg_postrm() {
	[ -L ${NVIDIA_CONTAINER_RUNTIME_HOOK} ] && rm ${NVIDIA_CONTAINER_RUNTIME_HOOK}
}
