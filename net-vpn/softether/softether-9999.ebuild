# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="git://github.com/SoftEtherVPN/SoftEtherVPN.git"
#EGIT_COMMIT="5.01.9671"

inherit git-r3 systemd

DESCRIPTION="Multi-protocol VPN software"
HOMEPAGE="http://www.softether.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug libressl"

RDEPEND="sys-libs/ncurses:0=
	 sys-libs/readline:0=
	 !libressl? ( dev-libs/openssl:0= )
	 libressl? ( dev-libs/libressl:0= )
         virtual/libiconv
        "
DEPEND="${RDEPEND}
        app-text/dos2unix
       "

#PATCHES=( "${FILESDIR}"/softether-5.01-sandbox.patch )

src_prepare() {
 dos2unix "src/Mayaqua/Unix.c"
 default
}


src_configure() {
 CMAKE_INSTALL_PREFIX="/usr" econf
}

src_compile() {
 emake -C tmp
}

src_install() {
 emake DESTDIR="${D}" -C tmp install

MODULES=(server client bridge cmd)
 for module in ${MODULES}; do
  newinitd "${FILESDIR}"/"${PN}"-"$module".initd "${PN}"-"$module"
  systemd_newunit "systemd/${PN}-vpn$module.service" "${PN}"-"$module".service
 done
}
