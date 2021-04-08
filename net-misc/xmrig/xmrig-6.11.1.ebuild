# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="XMRig"
HOMEPAGE="https://github.com/xmrig/xmrig"
SRC_URI="https://github.com/xmrig/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="+tls +hwloc +msr http cryptonight +randomx argon2 astrobwt kawpow securejit"

BDEPEND="dev-util/cmake"
RDEPEND=">=dev-libs/libuv-1.40.0
hwloc? ( >=sys-apps/hwloc-1.11.13 )
msr? ( >=sys-apps/msr-tools-1.3 )
tls? ( >=dev-libs/openssl-1.1.1k[-static-libs] )"

src_configure() {
	local mycmakeargs=(
		-DWITH_HWLOC="$(usex hwloc ON OFF)"
		-DWITH_MSR="$(usex msr ON OFF)"
		-DWITH_OPENCL="OFF"
		-DWITH_CUDA="OFF"
		-DWITH_NVML="OFF"
		-DWITH_ADL="OFF"
		-DWITH_STRICT_CACHE="OFF"
		-DBUILD_STATIC="OFF"
		-DWITH_HTTP="$(usex http ON OFF)"
		-DWITH_SECURE_JIT="$(usex securejit ON OFF)"
		-DWITH_CN_LITE="$(usex cryptonight ON OFF)"
		-DWITH_CN_HEAVY="$(usex cryptonight ON OFF)"
		-DWITH_CN_PICO="$(usex cryptonight ON OFF)"
		-DWITH_RANDOMX="$(usex randomx ON OFF)"
		-DWITH_ARGON2="$(usex argon2 ON OFF)"
		-DWITH_ASTROBWT="$(usex astrobwt ON OFF)"
		-DWITH_KAWPOW="$(usex kawpow ON OFF)"
	)

	cmake_src_configure
}

src_install() {
	into "opt"
	dobin "${BUILD_DIR}/xmrig"
	dodoc "${WORKDIR}/${P}/src/config.json"
}
