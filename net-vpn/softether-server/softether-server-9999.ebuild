# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="git://github.com/SoftEtherVPN/SoftEtherVPN.git"
#EGIT_COMMIT="5.01.9671"

inherit git-r3 systemd eutils

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
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/softether-sandbox.patch )

src_prepare() {
 edos2unix "src/Mayaqua/Unix.c"
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

 newinitd "${FILESDIR}"/softether-server.initd softether-server
 systemd_newunit "systemd/softether-vpnserver.service" softether-server.service
}
