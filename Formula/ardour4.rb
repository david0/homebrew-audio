class Ardour4 < Formula
  desc "hard disk recorder and digital audio workstation application"
  homepage "http://ardour.org"
  url "https://codeload.github.com/Ardour/ardour/tar.gz/4.7"
  sha256 "dfa3d102b3f7bb0702969153d22d9311ac98c587f691760ab0f1d3f4f455a86d"
  head "git://git.ardour.org/ardour/ardour.git"

  depends_on "cairo"
  depends_on "gtk+" #=> ["with-quartz-relocation"] # will need the ardour patch also most likely
  depends_on "gdk-pixbuf" #=> ["with-relocations"]
  depends_on "lrdf"

  depends_on "glibmm"
  depends_on "gtkmm"
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

  resource "fix-installnames-magic" do
    url "https://gist.githubusercontent.com/david0/34d1bbd280610ee48255/raw/234fec0d34a9b929f782c991f2c3804b85db6f9e/fix-installnames-magic.py"
  end

  resource "mkappbundle" do
    url "https://gist.githubusercontent.com/david0/56ee00434e4693852c24/raw/492493cc33994428648c876138597ea3cad667da/mkappbundle"
    sha256 "2d9c9220a589709387f123107e2ecc555d51ed35f1da64194cb8a95e0d902069"
  end

  # Otherwise fails with /System/Library/Frameworks/Security.framework/Headers/CSCommon.h:200:32: error: enumerator value evaluates to -2147483648, which cannot be narrowed to type 'uint32_t'
  #    (aka 'unsigned int') [-Wc++11-narrowing]
  patch :DATA

  # needs :cxx11
  def install
    ENV.cxx11

    if build.head?
      system "git", "tag", "-a", "-m", "head tag", "4.7"
    end

    (buildpath/"libs/ardour/revision.cc").write <<-EOS.undent
      #include "ardour/revision.h"
      namespace ARDOUR { const char* revision = "4.7-999"; }
    EOS

    #inreplace "wscript", "--stdlib=libc++", "--stdlib=libc++ --Wno-c++11-narrowing" 

    system "./waf", "configure", "--prefix=#{prefix}", "--with-backends=coreaudio,jack", "--use-libc++"
    system "./waf", "install"
  

    # hack: fix library names by looking for libraries that do not exist after removing them from sources
    system "rm", "-rf", "build"
    resource("fix-installnames-magic").stage do
      chmod "+x", "fix-installnames-magic.py"

      system "find " + prefix + ' \( -name ardour-4.\* -or -name \*.dylib \) -exec chmod +w {} \;'
      system "find " + prefix + ' \( -name ardour-4.\* -or -name \*.dylib \) -exec ./fix-installnames-magic.py {} ' + prefix + ' \;'
    end

    cd "tools/osx_packaging" do
      resource("mkappbundle").stage pwd
      chmod "+x", "mkappbundle"
      system "./mkappbundle", prefix
    end
  end

  test do
    system "ardour4", "--help"
  end
end


__END__
diff --git a/wscript b/wscript
index 965e546..6bc0351 100644
--- a/wscript
+++ b/wscript
@@ -396,6 +396,7 @@ int main() { return 0; }''',
 
     if opt.use_libcpp or conf.env['build_host'] in [ 'el_capitan' ]:
        cxx_flags.append('--stdlib=libc++')
+       cxx_flags.append('-Wno-c++11-narrowing')
        linker_flags.append('--stdlib=libc++')
 
     if conf.options.cxx11 or conf.env['build_host'] in [ 'mavericks', 'yosemite', 'el_capitan' ]:
