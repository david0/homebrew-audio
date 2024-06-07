class Calf < Formula
  desc "Audio plugin collection"
  homepage "http://calf-studio-gear.org"
  url "https://github.com/calf-studio-gear/calf.git", :tag=>"0.90.3"
  license "LGPL-2.1"
  head "https://github.com/calf-studio-gear/calf.git"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "jack"
  depends_on "lv2" => :recommended
  depends_on "fluid-synth" => :recommended
  depends_on "cairo" => :optional
  depends_on "gtk+" => :optional

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
