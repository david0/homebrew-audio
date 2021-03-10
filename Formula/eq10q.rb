class Eq10q < Formula
  desc 'audio plugins implementing a powerful and flexible parametric equalizer'
  homepage 'http://eq10q.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/eq10q/eq10q-2.2.tar.gz'
  version '2.2'
  sha256 '337f4c703ba31902565faad1cd450cf0312ad5a48dc499661277f287b662b09a'
  head 'svn://svn.code.sf.net/p/eq10q/code/trunk'

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

    Dir['**/*_ui.cpp'].each do |source| 
      inreplace source, 'const _LV2UI_Descriptor', 'const LV2UI_Descriptor'
    end

    # Wrong library name in ttl-files on OS/X (https://sourceforge.net/p/eq10q/bugs/14/)
    ["eq1qm.ttl", "eq1qs.ttl", "eq4qm.ttl", "eq4qs.ttl", "eq6qm.ttl", "eq6qs.ttl", "eq10qm.ttl", "eq10qs.ttl", "gate.ttl", "compressor.ttl", "gate_stereo.ttl", "compressor_stereo.ttl", "bassup.ttl", "lr2ms.ttl", "ms2lr.ttl"].each do |ttl|
      inreplace ttl, /\.so\b/, ".dylib"
    end

    # pow10 not defined on OS/X (https://sourceforge.net/p/eq10q/bugs/13/)
    ["gui/widgets/bandctl.cpp", "gui/widgets/bodeplot.cpp"].each do |f|
      inreplace f, "pow10(", "pow(10, "
    end

    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX='#{lib}/lv2'", "-DCMAKE_BUILD_TYPE=Release"
    system "make", "install"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm #{lib}/lv2/sapistaEQv2.lv2/eq10qm.dylib")
  end
end
