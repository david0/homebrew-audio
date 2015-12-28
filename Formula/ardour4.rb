class Ardour4 < Formula
  desc "hard disk recorder and digital audio workstation application"
  homepage "http://ardour.org"
  url "https://codeload.github.com/Ardour/ardour/tar.gz/4.4"
  sha256 "d567e99c4476c0122006c85d09a8e4eab93db28be7be99d338ea66be8581bfcf"
  head "git://git.ardour.org/ardour/ardour.git"

  stable do
    patch do
      # add El Capitan support
      url "https://github.com/Ardour/ardour/commit/0e1ce02941f2df585b41c7ce162995ce9a85a598.patch"
      sha256 "4705e84dbce2bd9ebfd04d814bb2a51f3da1abd9473268d540eab04bbabe367f"
    end

    patch do
      # Add "-" to cpp arguments because superenv cpp needs it
      url "https://github.com/Ardour/ardour/commit/1ecb3dde74962b17186757a93cc78eb5ea0f3c1d.patch"
      sha256 "178a6a9f670c338ede8425d0f5f47e7e2d285ac364c641b565586de0fbc1d24f"
    end

    patch do
      # add --use-libc++ use libc++ instead of libstdc++
      url "https://github.com/Ardour/ardour/commit/6b00ff6198210ac3f7e11d9758f4af1962961f1d.patch"
      sha256 "3eaee9cc46c3adcd025fc24c5ae6f2ad657a3c60945f057576c84b491ccd1935"
    end
  end

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
  depends_on "libsigc++" # can be removed when libsigc++ > 2.6.2
  depends_on :x11 => :optional

  depends_on "python3" => :build # for fix-installnames-magic

  resource "fix-installnames-magic" do
    url "https://gist.githubusercontent.com/david0/34d1bbd280610ee48255/raw/234fec0d34a9b929f782c991f2c3804b85db6f9e/fix-installnames-magic.py"
  end

  needs :cxx11
  def install
    ENV.cxx11

    if build.head?
      system "git", "tag", "-a", "-m", "head tag", "4.4"
    end

    (buildpath/"libs/ardour/revision.cc").write <<-EOS.undent
      #include "ardour/revision.h"
      namespace ARDOUR { const char* revision = "4.4-999"; }
    EOS

    system "./waf", "configure", "--prefix=#{prefix}", "--with-backends=coreaudio,jack", "--use-libc++"
    system "./waf", "install"

    # hack: fix library names by looking for libraries that do not exist after removing them from sources
    system "rm", "-rf", "build"
    resource("fix-installnames-magic").stage do
      chmod "+x", "fix-installnames-magic.py"

      system "find " + prefix + ' \( -name ardour-4.4\* -or -name \*.dylib \) -exec chmod +w {} \;'
      system "find " + prefix + ' \( -name ardour-4.4\* -or -name \*.dylib \) -exec ./fix-installnames-magic.py {} ' + prefix + ' \;'
    end
  end

  test do
    system "ardour4", "--help"
  end
end
