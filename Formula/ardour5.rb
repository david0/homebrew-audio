class Ardour5 < Formula
  desc "Hard disk recorder and digital audio workstation application"
  homepage "https://ardour.org"
  url "git://git.ardour.org/ardour/ardour.git", :tag=>"5.10", :revision => "9c629c0c76808cc3e8f05e43bc760f849566dce6"
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
  depends_on :x11 => :optional

  depends_on "python3" => :build # for fix-installnames-magic

  patch do
    # commit e3c6a41c1190253eb46844ab6915c7aa673a7dc9 from upstream master to fix build on High Sierra
    url "https://gist.githubusercontent.com/jgefele/baca5725ee2fa5067e901a5f2c2f9162/raw/3eeb2585947da3cad36450863c5d345fa825497b/0001-Adds-support-for-building-in-Mac-OS-High-Sierra.patch"
    sha256 "9ba4a37fbb70cc467fe40aa9842b642861c00bc6157cdeca0c9f6701dcfc998e"
  end

  patch do
    # fix framework reference from "CoreMidi" to "CoreMIDI" on High Sierra  --  Ardour developers have been informed about this
    url "https://gist.githubusercontent.com/jgefele/baca5725ee2fa5067e901a5f2c2f9162/raw/99be80665e3e4072bf65862ac2e16f97ddcfe814/0002-Fixes-framework-CoreMIDI-for-building-in-Mac-OS-High-Sierra.patch"
    sha256 "f25230d81898e1795183799d1ac8c05e18c366f6768d24a20b5944b7058269e1"
  end

  resource "fix-installnames-magic" do
    url "https://gist.githubusercontent.com/david0/34d1bbd280610ee48255/raw/234fec0d34a9b929f782c991f2c3804b85db6f9e/fix-installnames-magic.py"
    sha256 "2fb1b4a3e8c30e397c05480bad770101e10db04713f5c30dc951a52f3a465e1f"
  end

  resource "mkappbundle" do
    url "https://gist.githubusercontent.com/david0/56ee00434e4693852c24/raw/ae47c87874c398378402e83688bc6f47fe86e83c/mkappbundle"
    sha256 "ef5d349e9281605bc115217b146c81e6e38aefb39b014139e859ba031460b838"
  end

  needs :cxx11
  def install
    ENV.cxx11

    if build.head?
      system "git", "tag", "-a", "-m", "head tag", "5.10"
    end

    (buildpath/"libs/ardour/revision.cc").write <<-EOS.undent
      #include "ardour/revision.h"
      namespace ARDOUR { const char* revision = "5.10-999"; }
    EOS

    system "./waf", "configure", "--prefix=#{prefix}", "--with-backends=coreaudio,jack", "--use-libc++"
    system "./waf", "install"

    # HACK: fix library names by looking for libraries that do not exist after removing them from sources
    system "rm", "-rf", "build"
    resource("fix-installnames-magic").stage do
      chmod "+x", "fix-installnames-magic.py"

      system "find " + prefix + ' \( -name ardour-5.\* -or -name \*.dylib \) -exec chmod +w {} \;'
      system "find " + prefix + ' \( -name ardour-5.\* -or -name \*.dylib \) -exec ./fix-installnames-magic.py {} ' + prefix + ' \;'
    end

    cd "tools/osx_packaging" do
      resource("mkappbundle").stage pwd
      chmod "+x", "mkappbundle"
      system "./mkappbundle", prefix
    end
  end

  test do
    system "#{bin}/ardour5", "--help"
  end
end


__END__
