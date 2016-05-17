# gentoo-overlay-bes
personal portage overlay

## Installing

Install layman, if you didn't already, add the overlay:

`layman -a bes`

## Atoms

- #### dev-libs/cmark
	CommonMark parsing and rendering library and program in C
	`cat README.md |cmark`
- #### dev-perl/CommonMark
	Interface to the CommonMark C library
	`perl -MCommonMark -E 'say CommonMark->parse_document($txt)->render_html;'`
