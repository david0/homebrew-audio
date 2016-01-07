class Infamousplugins < Formula
  desc "audio plugins in the LV2 format"
  homepage "https://ssj71.github.io/infamousPlugins"
  url "https://github.com/ssj71/infamousPlugins/archive/v0.2.02.tar.gz"
  sha256 "665bde8e8468dec0b56703e8892cefd44e375fc254b0c18a1b34b07dc054a362"
  head "https://github.com/ssj71/infamousPlugins.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "zita-resampler"
  depends_on "fftw"

  def install
    Pathname.glob("#{buildpath}/src/*/manifest.ttl") do |file|
      inreplace file, /\.so\b/, ".dylib"
    end

    system "cmake", ".", *std_cmake_args
    system "make", "no-GUI"

    # lushlife tries to install some UI even with no-GUI
    inreplace "cmake_install.cmake", /include.*lushlife.*/, ""
    system "cmake", "-DCOMPONENT=no-GUI", "-P", "cmake_install.cmake"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm #{lib}/lv2/powercut.lv2/powercut.dylib")
  end
end
