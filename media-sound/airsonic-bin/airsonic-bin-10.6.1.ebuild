# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN//-bin}"
SUBSONIC_HOME="/var/lib/${MY_PN}"

DESCRIPTION="Subsonic is a personal media server, opensource fork of Subsonic"
HOMEPAGE="https://airsonic.github.io/"
SRC_URI="https://github.com/airsonic/airsonic/releases/download/v${PV}/airsonic.war"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg lame"

DEPEND=""
RDEPEND="
	acct-user/airsonic
	acct-group/airsonic
	virtual/jre
	lame? ( media-sound/lame )
	ffmpeg? ( virtual/ffmpeg )
"

S="${WORKDIR}/"

src_install() {
	insinto "/usr/libexec/airsonic"
	doins "${DISTDIR}"/airsonic.war

	keepdir ${SUBSONIC_HOME}
	fowners airsonic:airsonic ${SUBSONIC_HOME}

	newinitd "${FILESDIR}/airsonic.initd" airsonic
	newconfd "${FILESDIR}/airsonic.confd" airsonic

	if use ffmpeg; then
		dodir ${SUBSONIC_HOME}/transcode
		dosym /usr/bin/ffmpeg ${SUBSONIC_HOME}/transcode/ffmpeg
	fi

	if use lame; then
		dodir ${SUBSONIC_HOME}/transcode
		dosym /usr/bin/lame ${SUBSONIC_HOME}/transcode/lame
	fi
}
