# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Automatically configure containers with NVIDIA hardware."
HOMEPAGE="https://github.com/NVIDIA/libnvidia-container"
EGIT_REPO_URI="file:///home/xi/github/libnvidia-container/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+seccomp"

BDEPEND="sys-devel/bmake"
RDEPEND=">=virtual/libelf-3
seccomp? ( >=sys-libs/libseccomp-2.4.4 )"

QA_PRESTRIPPED="/usr/bin/nvidia-container-cli
/usr/lib64/libnvidia-container.so.*"

src_compile() {
	if use seccomp ; then
	   WITH_SECCOMP=yes
	fi

	emake WITH_LIBELF="yes" WITH_TIRPC="yes" WITH_SECCOMP="${WITH_SECCOMP}" CC="gcc" shared
}

src_install() {
	dobin "${WORKDIR}/${P}/nvidia-container-cli"
	dolib.so "${WORKDIR}/${P}/${PN}.so.${PV}"
	dosym ${PN}.so.${PV} usr/lib64/${PN}.so.1
}
