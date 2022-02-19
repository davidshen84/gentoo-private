# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Automatically configure containers with NVIDIA hardware."
HOMEPAGE="https://github.com/NVIDIA/libnvidia-container"
NVIDIA_DRIVER_VERSION=495.44
SRC_URI="https://github.com/NVIDIA/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz
https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.1.4/libtirpc-1.1.4.tar.bz2 -> libtirpc.tar.bz2
https://download.nvidia.com/XFree86/nvidia-modprobe/nvidia-modprobe-${NVIDIA_DRIVER_VERSION}.tar.bz2 -> nvidia-modprobe-${NVIDIA_DRIVER_VERSION}.tar.bz2
"

IUSE="+seccomp"
KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="sys-devel/bmake
>net-libs/rpcsvc-proto-1.4.0"
RDEPEND=">=virtual/libelf-3
seccomp? ( >=sys-libs/libseccomp-2.4.4 )
>=x11-drivers/nvidia-drivers-495[driver(+)]"

PATCHES=(
	"${FILESDIR}/revision-${PV}.patch"
	"${FILESDIR}/Makefile.patch"
	"${FILESDIR}/libtirpc-1.1.4-gcc10.patch"
)

QA_PRESTRIPPED="/usr/bin/nvidia-container-cli
/usr/lib64/libnvidia-container.so.*"

src_prepare() {
	DEPS_DIR=${WORKDIR}/${P}/deps
	TIRPC_SRC_DIR=${DEPS_DIR}/src/libtirpc-1.1.4
	MOD_SRC_DIR=${DEPS_DIR}/src/nvidia-modprobe-${NVIDIA_DRIVER_VERSION}

	mkdir -p "${DEPS_DIR}/src"
	mv "${WORKDIR}/libtirpc-1.1.4" "${TIRPC_SRC_DIR}"
	mv "${WORKDIR}/nvidia-modprobe-${NVIDIA_DRIVER_VERSION}" "${MOD_SRC_DIR}"

	default_src_prepare
}

src_compile() {
	emake WITH_LIBELF="yes" WITH_TIRPC="yes" WITH_SECCOMP="$(usex seccomp)" CURL="echo" TAR="echo" shared static tools
}

src_install() {
	dobin "${WORKDIR}/${P}/nvidia-container-cli"
	dolib.so "${WORKDIR}/${P}/${PN}.so.${PV}"
	dosym ${PN}.so.${PV} usr/lib64/${PN}.so.1
}
