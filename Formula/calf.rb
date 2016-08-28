class Calf < Formula
  desc "audio plugin collection"
  homepage "http://calf-studio-gear.org"
  version '72b13fa8670738e735184494554a9d6f3fad56ac'
  url "https://github.com/calf-studio-gear/calf.git", :revision=>'72b13fa8670738e735184494554a9d6f3fad56ac' #https://github.com/calf-studio-gear/calf/issues/94

  head "https://github.com/calf-studio-gear/calf.git"

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  depends_on "glib"
  depends_on "jack"
  depends_on "lv2" => :recommended
  depends_on "fluid-synth" => :recommended
  depends_on "cairo" # could be optional, see: https://github.com/calf-studio-gear/calf/issues/95
  depends_on "gtk+" => :optional

  patch do
    # Test if linker supports nodelete
    url "https://github.com/david0/calf/commit/d2f174083d97ce0f6930fc28764fdec80810f464.patch"
    sha256 "e63a29017ce1cfff2a374f48fc3f2d99463851e88e5462aa5bc6475a870124f7"
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
