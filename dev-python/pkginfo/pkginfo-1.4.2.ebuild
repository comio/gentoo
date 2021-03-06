# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Provides an API for querying the distutils metadata written in a PKG-INFO file"
HOMEPAGE="https://pypi.org/project/pkginfo/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="doc"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Disable tests that seek to read the version of pkginfo from an installed state
	# These test will still become installed and testable once installed
	sed -e 's:test_w_directory_no_EGG_INFO:_&:' \
		-e 's:test_w_module_and_metadata_version:_&:' \
		-e 's:test_w_package_name_and_metadata_version:_&:' \
		-i pkginfo/tests/test_utils.py || die
	sed -e 's:test_ctor_w_path_nested_egg_info:_&:' \
		-i pkginfo/tests/test_develop.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" -m unittest discover || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/.build/html/. )
	distutils-r1_python_install_all
}
