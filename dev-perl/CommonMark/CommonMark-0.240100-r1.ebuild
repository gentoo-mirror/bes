# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="NWELLNHOF"
MODULE_VERSION="0.240100"

inherit perl-module

DESCRIPTION="Interface to the CommonMark C library"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND=">dev-libs/cmark-0.23:="

src_prepare() {
	epatch "${FILESDIR}/remove_dep.patch"
}
