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

  resource "fix-installnames-magic" do
    url "https://gist.githubusercontent.com/david0/34d1bbd280610ee48255/raw/234fec0d34a9b929f782c991f2c3804b85db6f9e/fix-installnames-magic.py"
    sha256 "2fb1b4a3e8c30e397c05480bad770101e10db04713f5c30dc951a52f3a465e1f"
  end

  resource "mkappbundle" do
    url "https://gist.githubusercontent.com/david0/56ee00434e4693852c24/raw/ae47c87874c398378402e83688bc6f47fe86e83c/mkappbundle"
    sha256 "ef5d349e9281605bc115217b146c81e6e38aefb39b014139e859ba031460b838"
  end

  # Otherwise fails with /System/Library/Frameworks/Security.framework/Headers/CSCommon.h:200:32: error: enumerator value evaluates to -2147483648, which cannot be narrowed to type 'uint32_t'
  #    (aka 'unsigned int') [-Wc++11-narrowing]
  patch :DATA

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

    # inreplace "wscript", "--stdlib=libc++", "--stdlib=libc++ --Wno-c++11-narrowing"

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
--- a/wscript
+++ b/wscript
@@ -396,6 +396,7 @@ int main() { return 0; }''',
 
     if opt.use_libcpp or conf.env['build_host'] in [ 'el_capitan' ]:
        cxx_flags.append('--stdlib=libc++')
+       cxx_flags.append('-Wno-c++11-narrowing')
        linker_flags.append('--stdlib=libc++')
 
     if conf.options.cxx11 or conf.env['build_host'] in [ 'mavericks', 'yosemite', 'el_capitan' ]:
