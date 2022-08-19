class Ardour6 < Formula
  desc "Hard disk recorder and digital audio workstation application"
  homepage "https://ardour.org"
  url "git://git.ardour.org/ardour/ardour.git", :tag=>"6.9", :revision => "945c8f288077565fe3de32c6ac0cb50e286722e4"
  head "git://git.ardour.org/ardour/ardour.git"

  depends_on "boost"
  depends_on "cairo"
  depends_on "gtk+" #=> ["with-quartz-relocation"] # will need the ardour patch also most likely
  depends_on "gdk-pixbuf" #=> ["with-relocations"]
  depends_on "lrdf"

  depends_on "glibmm"
  depends_on "gtkmm"
  depends_on "libarchive"
  depends_on "libsndfile"
  depends_on "liblo"
  depends_on "taglib"
  depends_on "rubberband"
  depends_on "vamp-plugin-sdk"
  depends_on "aubio"
  depends_on "jack"
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"
  depends_on "suil" => :recommended
  depends_on "fftw"
  depends_on "lilv"
  depends_on "libsigc++"

  # replaced :x11 by dedicated dependencies, untested, not sure whats really needed
  depends_on "fontconfig" => :optional
  depends_on "freetype" => :optional
  depends_on "libx11" => :optional
  depends_on "libxft" => :optional
  depends_on "libxmu" => :optional
  depends_on "libxrender" => :optional
  depends_on "libxt" => :optional

  depends_on "python3" => :build # for fix-installnames-magic

  resource "fix-installnames-magic" do
    url "https://gist.githubusercontent.com/david0/34d1bbd280610ee48255/raw/234fec0d34a9b929f782c991f2c3804b85db6f9e/fix-installnames-magic.py"
    sha256 "2fb1b4a3e8c30e397c05480bad770101e10db04713f5c30dc951a52f3a465e1f"
  end

  resource "mkappbundle6" do
    url "https://gist.githubusercontent.com/genevera/4461e5130723cbb0775690430ce56ed2/raw/35acd2b53cee04d32561328d8634bf743f0b7505/mkappbundle6"
    sha256 "fc387fa58c7ba0a9637406b704b704b29cf4ccf01d58c5e6bcad8aef73d1047a"
  end

  # needs :cxx11
  def install
    ENV.cxx11

    if build.head?
      system "git", "tag", "-d", "6.9"
      system "git", "tag", "-a", "-m", "head tag", "6.9"
    end

    (buildpath/"libs/ardour/revision.cc").write <<~EOS
      #include "ardour/revision.h"
      namespace ARDOUR { const char* revision = "6.8-999"; const char* date = "2021-08-12"; }
    EOS

    system "./waf", "configure", "--prefix=#{prefix}", "--with-backends=coreaudio,jack", "--use-libc++"
    system "./waf", "install"

    # HACK: fix library names by looking for libraries that do not exist after removing them from sources
    system "rm", "-rf", "build"
    resource("fix-installnames-magic").stage do
      chmod "+x", "fix-installnames-magic.py"

      system "find " + prefix + ' \( -name ardour-6.\* -or -name \*.dylib \) -exec chmod +w {} \;'
      system "find " + prefix + ' \( -name ardour-6.\* -or -name \*.dylib \) -exec ./fix-installnames-magic.py {} ' + prefix + ' \;'
    end

    cd "tools/osx_packaging" do
      resource("mkappbundle6").stage pwd
      chmod "+x", "mkappbundle6"
      system "./mkappbundle6", prefix
    end
  end

  test do
    system "#{bin}/ardour6", "--help"
  end
end


__END__
