# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="The NVIDIA Container Toolkit."
HOMEPAGE="https://github.com/NVIDIA/nvidia-container-toolkit"
SRC_URI="https://github.com/NVIDIA/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

KEYWORDS="amd64"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="dev-lang/go
~sys-libs/libnvidia-container-1.13.5
"

NVIDIA_CONTAINER_RUNTIME_SCRIPT=usr/bin/nvidia-container-runtime-hook

src_compile() {
	emake binaries
}

src_install() {
	dobin nvidia-ctk
	dobin nvidia-container-runtime
	dobin nvidia-container-runtime-hook

	mkdir -p etc/nvidia-container-runtime
	insinto etc/nvidia-container-runtime
	newins config/config.toml.ubuntu config.toml
}

pkg_postrm() {
	[ -L ${NVIDIA_CONTAINER_RUNTIME_SCRIPT} ] && rm ${NVIDIA_CONTAINER_RUNTIME_SCRIPT}
}
