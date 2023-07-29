# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Automatically configure containers with NVIDIA hardware."
HOMEPAGE="https://github.com/NVIDIA/libnvidia-container"
NVIDIA_DRIVER_VERSION=495.44
SRC_URI="https://github.com/NVIDIA/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz
https://download.nvidia.com/XFree86/nvidia-modprobe/nvidia-modprobe-${NVIDIA_DRIVER_VERSION}.tar.bz2
"

IUSE="+seccomp"
KEYWORDS="amd64"
LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="sys-devel/bmake
>net-libs/rpcsvc-proto-1.4.0"

RDEPEND=">=virtual/libelf-3
>=net-libs/libtirpc-1.3.2
seccomp? ( >=sys-libs/libseccomp-2.4.4 )
>=x11-drivers/nvidia-drivers-${NVIDIA_DRIVER_VERSION%%.*}[driver(+)]"

PATCHES=(
	"${FILESDIR}/revision-${PV}.patch"
	"${FILESDIR}/Makefile-${PV}.patch"
)

QA_PRESTRIPPED="/usr/bin/nvidia-container-cli
/usr/lib64/libnvidia-container.so.*
/usr/lib64/libnvidia-container-go.so.*
"

src_prepare() {
	DEPS_DIR=${WORKDIR}/${P}/deps
	MOD_SRC_DIR=${DEPS_DIR}/src/nvidia-modprobe-${NVIDIA_DRIVER_VERSION}

	mkdir -p "${DEPS_DIR}/src"
	mv "${WORKDIR}/nvidia-modprobe-${NVIDIA_DRIVER_VERSION}" "${MOD_SRC_DIR}"

	default_src_prepare
}

src_compile() {
	emake WITH_LIBELF="yes" WITH_TIRPC="yes" WITH_SECCOMP="$(usex seccomp)" CURL="echo" TAR="echo" all
}

src_install() {
	dobin "${WORKDIR}/${P}/nvidia-container-cli"

	dolib.so "${WORKDIR}/${P}/${PN}.so.${PV}"
	dosym ${PN}.so.${PV} usr/lib64/${PN}.so.1

	dolib.so "${WORKDIR}/${P}/deps/usr/local/lib/${PN}-go.so.${PV}"
	dosym ${PN}-go.so.${PV} usr/lib64/${PN}-go.so.1
}
