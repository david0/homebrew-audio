class Lmms < Formula
  desc "free digital audio workstation"
  homepage "https://lmms.io"
  head "https://github.com/LMMS/lmms.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "libsndfile"
  depends_on "fftw"
  depends_on "libvorbis"
  depends_on "libogg"
  depends_on "jack"
  depends_on "sdl"
  depends_on "libsamplerate"
  depends_on "libsoundio"
  depends_on "stk"
  depends_on "fluid-synth"
  depends_on "portaudio"
  depends_on "fltk"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/lmms --help")
  end
end
