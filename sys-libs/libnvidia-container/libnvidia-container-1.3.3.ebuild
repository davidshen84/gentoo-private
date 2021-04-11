# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#inherit git-r3

DESCRIPTION="Automatically configure containers with NVIDIA hardware."
HOMEPAGE="https://github.com/NVIDIA/libnvidia-container"
SRC_URI="https://github.com/NVIDIA/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz
https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.1.4/libtirpc-1.1.4.tar.bz2 -> libtirpc.tar.bz2
https://github.com/NVIDIA/nvidia-modprobe/archive/450.57.tar.gz -> nvidia-modprobe-450.57.tar.gz
"

IUSE="+seccomp"
KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="sys-devel/bmake"
RDEPEND=">=virtual/libelf-3
seccomp? ( >=sys-libs/libseccomp-2.4.4 )"

PATCHES=(
	"${FILESDIR}/revision.patch"
	"${FILESDIR}/Makefile.patch"
)

QA_PRESTRIPPED="/usr/bin/nvidia-container-cli
/usr/lib64/libnvidia-container.so.*"

src_compile() {
	if use seccomp ; then
	   WITH_SECCOMP=yes
	fi

	DEPS_DIR=${WORKDIR}/${P}/deps
	TIRPC_SRC_DIR=${DEPS_DIR}/src/libtirpc-1.1.4
	MOD_SRC_DIR=${DEPS_DIR}/src/nvidia-modprobe-450.57

	mkdir -p "${WORKDIR}/${P}/deps/src"
	ln -s "${WORKDIR}/libtirpc-1.1.4" "${TIRPC_SRC_DIR}"
	ln -s "${WORKDIR}/nvidia-modprobe-450.57" "${MOD_SRC_DIR}"
	emake WITH_LIBELF="yes" WITH_TIRPC="yes" WITH_SECCOMP="${WITH_SECCOMP}" CURL="echo" TAR="echo" shared static tools
}

src_install() {
	dobin "${WORKDIR}/${P}/nvidia-container-cli"
	dolib.so "${WORKDIR}/${P}/${PN}.so.${PV}"
	dosym ${PN}.so.${PV} usr/lib64/${PN}.so.1
}
