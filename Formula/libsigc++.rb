class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "http://libsigc.sourceforge.net"
  url "https://download.gnome.org/sources/libsigc++/2.6/libsigc++-2.6.2.tar.xz"
  sha256 "fdace7134c31de792c17570f9049ca0657909b28c4c70ec4882f91a03de54437"

  needs :cxx11

  depends_on "mm-common" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  patch do
    # nil is a keyword in Objective-C++
    # https://bugzilla.gnome.org/show_bug.cgi?id=695235
    url "https://git.gnome.org/browse/libsigc++2/patch/?id=75466ce1e1d92fe04926f72567417912779cc5c1"
    sha256 "42966b4e84096fc091ae08cffc733d252cadab719405270d1170be3a60ac7cba"
  end

  patch do
    # can_deduce_result_type_with_decltype: Rename the check() methods
    # https://bugzilla.gnome.org/show_bug.cgi?id=759315
    url "https://git.gnome.org/browse/libsigc++2/patch/?id=9bd7f99838f1fb0f67fe5a66155dc13d075041df"
    sha256 "50d01a41aed4e1a7a0d1f895b26e7cb613e17eddb1d2eb9bc32ca75ee13799e9"
  end

  def install
    ENV.cxx11

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <sigc++/sigc++.h>

      void somefunction(int arg) {}

      int main(int argc, char *argv[])
      {
         sigc::slot<void, int> sl = sigc::ptr_fun(&somefunction);
         return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                   "-L#{lib}", "-lsigc-2.0", "-I#{include}/sigc++-2.0", "-I#{lib}/sigc++-2.0/include", "-o", "test"
    system "./test"
  end
end
