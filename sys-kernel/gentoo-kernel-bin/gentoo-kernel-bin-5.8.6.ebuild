# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-install

MY_P=${P/-bin/}-1
DESCRIPTION="Pre-built Linux kernel with genpatches"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="http://gentoo-overlay-bes-dist.xn--txe.net/gentoo-kernel-5.8.6-1.amd64.xpak"
S=${WORKDIR}

LICENSE="GPL-2"
KEYWORDS="amd64"

RDEPEND="
	!sys-kernel/gentoo-kernel:${SLOT}
	!sys-kernel/vanilla-kernel:${SLOT}
	!sys-kernel/vanilla-kernel-bin:${SLOT}"

QA_PREBUILT='*'

pkg_pretend() {
	ewarn "Starting with 5.7.9, Distribution Kernels are switching from Arch"
	ewarn "Linux configs to Fedora.  Please keep a backup kernel just in case."

	kernel-install_pkg_pretend
}

src_unpack() {
	ebegin "Unpacking ${MY_P}.${ARCH}.xpak"
	tar -x < <(xz -c -d --single-stream "${DISTDIR}/${MY_P}.${ARCH}.xpak")
	eend ${?} || die "Unpacking ${MY_P} failed"
}

src_test() {
	kernel-install_test "${PV}" \
		"${WORKDIR}/usr/src/linux-${PV}/$(kernel-install_get_image_path)" \
		"lib/modules/${PV}"
}

src_install() {
	mv * "${ED}" || die
}
