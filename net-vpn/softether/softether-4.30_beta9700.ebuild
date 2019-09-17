# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="git://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git refs/tags/v4.30-9700-beta"
EGIT_BRANCH="master"

inherit git-r3 systemd toolchain-funcs

DESCRIPTION="Multi-protocol VPN software"
HOMEPAGE="http://www.softether.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="bridge client cmd debug libressl server"
REQUIRED_USE="|| ( bridge client cmd server )"

RDEPEND="sys-libs/ncurses:0=
	 sys-libs/readline:0=
	 sys-libs/zlib
	 !libressl? ( dev-libs/openssl:0= )
	 libressl? ( dev-libs/libressl:0= )
        "
DEPEND="${RDEPEND}
        app-text/dos2unix
       "

DOCS=( AUTHORS.TXT ChangeLog README )

PATCHES=( "${FILESDIR}"/softether-4.30-sandbox.patch
	"${FILESDIR}"/softether-4.25-compile-flags.patch )

src_prepare() {
        dos2unix "src/Mayaqua/Unix.c"

	default

	sed -i '/opt\/vpn/s|/opt|/opt/softether|' systemd/*.service \
		|| die "sed failed for systemd files"

	rm -f configure || die
	if use amd64; then
		cp src/makefiles/linux_64bit.mak Makefile \
			|| die "copy Makefile for amd64 failed"
	elif use x86; then
		cp src/makefiles/linux_32bit.mak Makefile \
			|| die "copy Makefile for x86 failed"
	fi
}

src_compile() {
	tc-export CC AR RANLIB
	emake DEBUG="$(usex debug YES NO '' '')"
}

src_install() {
	einstalldocs

	# Define local variable, strip 'debug' and 'libressl' USE flags
	local MODULES
	MODULES="${IUSE//debug}"
	MODULES="${IUSE//libressl}"

	# Define installation location
	insinto /opt/softether
	doins src/bin/BuiltHamcoreFiles/unix/hamcore.se2

	# Install binary in accordance to used USE flags
	for module in ${MODULES}; do
		if use "$module" ; then
			dosym ../../hamcore.se2 /opt/softether/bin/vpn"$module"/hamcore.se2
			insinto /opt/softether/bin/vpn"$module"
			doins bin/vpn"$module"/vpn"$module"
			fperms 0755 /opt/softether/bin/vpn"$module"/vpn"$module"
			if [ "$module" != "cmd" ] ; then
				newinitd "${FILESDIR}"/"${PN}"-"$module".initd "${PN}"-"$module"
				systemd_newunit "systemd/${PN}-vpn$module.service" "${PN}"-"$module".service
			fi
		fi
	done
}
