class ZitaResampler < Formula
  desc "C++ library for resampling audio signals"
  homepage "http://kokkinizita.linuxaudio.org/linuxaudio/"
  url "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-resampler-1.3.0.tar.bz2"
  sha256 "98034c8c77b03ad1093f7ca0a83ccdfad5a36040a5a95bd4dac80fa68bcf2a65"

  depends_on "libsndfile"

  def install
    cd "libs" do
      inreplace "Makefile", "-Wl,-soname,$(ZITA-RESAMPLER_MAJ)", ""
      inreplace "Makefile", "ldconfig", ""
      inreplace "Makefile", /\.so\b/, ".dylib"
      system "make", "install", "PREFIX=#{prefix}", "SUFFIX="
    end

    ENV.append_to_cflags "-I#{include}"
    cd "apps" do
      system "mkdir", "-p", man, bin
      inreplace "Makefile", "-lrt", ""
      inreplace "Makefile", "install -Dm", "install -m"
      system "make", "install", "PREFIX=#{prefix}", "SUFFIX=", "MANDIR=#{man}"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/zresample --help 2>&1", 1)
  end
end
