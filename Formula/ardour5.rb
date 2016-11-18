class Ardour5 < Formula
  desc "hard disk recorder and digital audio workstation application"
  homepage "http://ardour.org"
  url "git://git.ardour.org/ardour/ardour.git", :tag=>'5.4'
  #sha256 "598fb7fbe288caad6d4472f6b2057e15d9e6a66770a5e64c66af01b8cd7d14f3"
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
    url "https://gist.githubusercontent.com/david0/56ee00434e4693852c24/raw/ae47c87874c398378402e83688bc6f47fe86e83c/mkappbundle"
  end

  # Otherwise fails with /System/Library/Frameworks/Security.framework/Headers/CSCommon.h:200:32: error: enumerator value evaluates to -2147483648, which cannot be narrowed to type 'uint32_t'
  #    (aka 'unsigned int') [-Wc++11-narrowing]
  patch :DATA

  needs :cxx11
  def install
    ENV.cxx11

    if build.head?
      system "git", "tag", "-a", "-m", "head tag", "5.4"
    end

    (buildpath/"libs/ardour/revision.cc").write <<-EOS.undent
      #include "ardour/revision.h"
      namespace ARDOUR { const char* revision = "5.4-999"; }
    EOS

    #inreplace "wscript", "--stdlib=libc++", "--stdlib=libc++ --Wno-c++11-narrowing" 

    system "./waf", "configure", "--prefix=#{prefix}", "--with-backends=coreaudio,jack", "--use-libc++", "--cxx11"
    system "./waf", "install"
  

    # hack: fix library names by looking for libraries that do not exist after removing them from sources
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
    system "ardour5", "--help"
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
diff --git a/wscript b/wscript
index 9edfde8..6d026e0 100644
--- a/wscript
+++ b/wscript
@@ -536,7 +536,7 @@ int main() { return 0; }''',
     elif conf.env['build_target'] in [ 'mavericks', 'yosemite', 'el_capitan' ]:
         compiler_flags.extend(
                 ("-DMAC_OS_X_VERSION_MAX_ALLOWED=1090",
-                 "-mmacosx-version-min=10.8"))
+                 "-mmacosx-version-min=10.9"))

     #
     # save off CPU element in an env