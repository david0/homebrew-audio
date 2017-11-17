class Calf < Formula
  desc "audio plugin collection"
  homepage "http://calf-studio-gear.org"
  version '72b13fa8670738e735184494554a9d6f3fad56ac'
  url "https://github.com/calf-studio-gear/calf.git", :revision=>'3274b8e63b5656f1d970990e63df148993f9e920'
  head "https://github.com/calf-studio-gear/calf.git"

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  depends_on "glib"
  depends_on "jack"
  depends_on "lv2" => :recommended
  depends_on "fluid-synth" => :recommended
  depends_on "cairo" => :optional
  depends_on "gtk+" => :optional

  patch do
    # Test if linker supports nodelete
    url "https://github.com/david0/calf/commit/d2f174083d97ce0f6930fc28764fdec80810f464.patch"
    sha256 "f44124501098e9bfac3da314198698ba9e72db9171f5670b0c8d1423267bd6f8"
  end

  def install
    args = "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--with-lv2-dir=#{lib}/lv2/"

    system "./autogen.sh", *args
    system "make", "install"
  end

  test do
    if build.with? "gtk+"
      system "calfjackhost", "--help"
    end
  end
end
