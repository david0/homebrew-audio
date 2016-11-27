# Jack2 from waf-macosx-fixes branch
class Jack2 < Formula
  desc "Jack Audio Connection Kit (JACK) 2"
  homepage "http://jackaudio.org"
  url "git://github.com/jackaudio/jack2.git", :branch=>'waf-macosx-fixes'
  #sha256 "3517b5bff82139a76b2b66fe2fd9a3b34b6e594c184f95a988524c575b11d444"
  head "git://github.com/jackaudio/jack2.git"

  depends_on "pkg-config" => :build
  depends_on "libsndfile"
  depends_on "libsamplerate"
  depends_on "aften"

#   def install
#     # Makefile hardcodes Carbon header location
#     inreplace Dir["drivers/coreaudio/Makefile.{am,in}"],
#       "/System/Library/Frameworks/Carbon.framework/Headers/Carbon.h",
#       "#{MacOS.sdk_path}/System/Library/Frameworks/Carbon.framework/Headers/Carbon.h"
# 
#     ENV["LINKFLAGS"] = ENV.ldflags
#     system "./configure", "--prefix=#{prefix}"
#     system "make", "install"
#   end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "install"
  end

  plist_options :manual => "jackd -d coreaudio"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>WorkingDirectory</key>
      <string>#{prefix}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/jackd</string>
        <string>-d</string>
        <string>coreaudio</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jackd --version")
  end
end
