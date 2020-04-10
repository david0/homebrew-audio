class Setbfree < Formula
  desc "DSP Tonewheel Organ emulator"
  homepage "http://setbfree.org"
  head "https://github.com/pantherb/setBfree.git"

  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "lv2"
  depends_on "bzip2" => :recommended
  depends_on "freetype" => :recommended
  depends_on "ftgl" => :recommended
  depends_on "libpng" => :recommended
  depends_on "zlib" => :recommended

  def install
    inreplace "common.mak", "`pkg-config --variable=libdir ftgl`/libfreetype.a", "`pkg-config --libs freetype2`"
    system "make", "PREFIX=#{prefix}", "FONTFILE=/opt/X11/share/fonts/TTF/VeraBd.ttf", "install"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/b_synth.lv2/b_synth.dylib")
  end
end
