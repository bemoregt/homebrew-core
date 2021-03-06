class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"

  stable do
    url "https://github.com/libgd/libgd/releases/download/gd-2.2.2/libgd-2.2.2.tar.xz"
    sha256 "489f756ce07f0c034b1a794f4d34fdb4d829256112cb3c36feb40bb56b79218c"

    # OS X linker restricts the revision field to 8 bits: libgd/libgd#214.
    # Same as https://github.com/libgd/libgd/commit/502e4cd8, but recommended by
    # upstream for patching the release tarball; already fixed in HEAD.
    patch do
      url "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/gd/files/gd-2.2.2-osx-libtool.patch?id=ede657b970d1deee8305dbefaf5651c37aea115c"
      sha256 "8af30e9f8da6ca7ed28ee766e87b66d8ccf034745851760fb4fc8e9bc4907f14"
    end
  end

  bottle do
    cellar :any
    sha256 "f17582f4983460221308bb459b8b7ffa8df9fc8609707a1915a83905f72b51b2" => :el_capitan
    sha256 "9474f102ea232b7aa7a49d43cde4401f6ab5ce92506a947ebcf7498273a4a81f" => :yosemite
    sha256 "b2b106e9ebab3ae27b0b9626aa5063c699fcc2ddc2fdaee1d844989bb31a42f5" => :mavericks
  end

  head do
    url "https://github.com/libgd/libgd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "fontconfig" => :recommended
  depends_on "freetype" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "webp" => :recommended

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
      --without-xpm
    ]

    if build.with? "libpng"
      args << "--with-png=#{Formula["libpng"].opt_prefix}"
    else
      args << "--without-png"
    end

    if build.with? "fontconfig"
      args << "--with-fontconfig=#{Formula["fontconfig"].opt_prefix}"
    else
      args << "--without-fontconfig"
    end

    if build.with? "freetype"
      args << "--with-freetype=#{Formula["freetype"].opt_prefix}"
    else
      args << "--without-freetype"
    end

    if build.with? "jpeg"
      args << "--with-jpeg=#{Formula["jpeg"].opt_prefix}"
    else
      args << "--without-jpeg"
    end

    if build.with? "libtiff"
      args << "--with-tiff=#{Formula["libtiff"].opt_prefix}"
    else
      args << "--without-tiff"
    end

    if build.with? "webp"
      args << "--with-webp=#{Formula["webp"].opt_prefix}"
    else
      args << "--without-webp"
    end

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pngtogd", test_fixtures("test.png"), "gd_test.gd"
    system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
  end
end
