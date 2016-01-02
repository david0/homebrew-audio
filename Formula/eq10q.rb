class Eq10q < Formula
  desc "audio plugins implementing a powerful and flexible parametric equalizer"
  homepage "http://eq10q.sourceforge.net"
  url "https://downloads.sourceforge.net/project/eq10q/eq10q-2.0.tar.gz?r=http%3A%2F%2Feq10q.sourceforge.net%2F%3Fpage_id%3D16&ts=1451392119"
  version "2.0"
  sha256 "704410f7835e17599b92dcf27bd2bc2c02642ebce5157b79c42e630c3c757423"
  head "svn://svn.code.sf.net/p/eq10q/code/trunk"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gtkmm"
  depends_on "lv2"

  # Make CMAKE_INSTALL_PREFIX configurable (https://sourceforge.net/p/eq10q/patches/11/)
  patch :p0 do
    url "https://sourceforge.net/p/eq10q/patches/11/attachment/eq10qs-install-prefix.patch"
    sha256 "32025fb7a7805bf98dcd2991b612c4211fa0af95682af0f2882f91a3f99d81b7"
  end

  def install
    # Wrong library name in ttl-files on OS/X (https://sourceforge.net/p/eq10q/bugs/14/)
    ["eq1qm.ttl", "eq1qs.ttl", "eq4qm.ttl", "eq4qs.ttl", "eq6qm.ttl", "eq6qs.ttl", "eq10qm.ttl", "eq10qs.ttl", "gate.ttl", "compressor.ttl", "gate_stereo.ttl", "compressor_stereo.ttl", "bassup.ttl", "lr2ms.ttl", "ms2lr.ttl"].each do |ttl|
      inreplace ttl, /\.so\b/, ".dylib"
    end

    # pow10 not defined on OS/X (https://sourceforge.net/p/eq10q/bugs/13/)
    ["gui/widgets/bandctl.cpp", "gui/widgets/bodeplot.cpp"].each do |f|
      inreplace f, "pow10(", "pow(10, "
    end

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm #{lib}/lv2/sapistaEQv2.lv2/eq10qm.dylib")
  end
end
