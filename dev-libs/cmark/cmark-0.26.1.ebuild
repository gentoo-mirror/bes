# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="CommonMark parsing and rendering library and program in C"
HOMEPAGE="https://github.com/jgm/cmark"
SRC_URI="https://github.com/jgm/cmark/archive/${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
dev-util/cmake
"

src_compile() {
	emake INSTALL_PREFIX="/usr/" || die "emake failed"
}
