class ZitaResampler < Formula
  desc "C++ library for resampling audio signals"
  homepage "http://kokkinizita.linuxaudio.org/linuxaudio/"
  url "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-resampler-1.6.2.tar.bz2"
  sha256 "233baefee297094514bfc9063e47f848e8138dc7c959d9cd957b36019b98c5d7"

  depends_on "coreutils" => :build
  depends_on "libsndfile"

  def install
    ENV.prepend "PATH", Formula["coreutils"].libexec/"gnubin" + ":"

    cd "source" do
      inreplace "Makefile", "-Wl,-soname,$(ZITA-RESAMPLER_MAJ)", ""
      inreplace "Makefile", "ldconfig", ""
      system "make", "install", "PREFIX=#{prefix}", "SUFFIX=", "ZITA-RESAMPLER_SO=libzita-resampler.dylib", "ZITA-RESAMPLER_MIN=libzita-resampler.#{version}.dylib"
    end

    ENV.append_to_cflags "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"
    cd "apps" do
      mkdir share
      mkdir man
      mkdir bin
      inreplace "Makefile", "-lrt", ""
      system "make", "install", "PREFIX=#{prefix}", "SUFFIX=", "MANDIR=#{man}"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/zresample --help 2>&1", 1)
  end
end
