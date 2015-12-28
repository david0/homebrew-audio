class IrLv2 < Formula
  desc "no-latency/low-latency, realtime, high performance signal convolver especially for creating reverb effects"
  homepage "http://factorial.hu/plugins/lv2/ir"
  url "http://factorial.hu/system/files/ir.lv2-1.3.2.tar.gz"
  sha256 "ef9053e7b6002ed9f0b9a95046ec61cfb7035c0b2159f0fdc98ad44403f802ca"

  depends_on "pkg-config" => :build
  depends_on "gtk"
  depends_on "glib"
  depends_on "libsamplerate"
  depends_on "lv2"

  # exp10 does not exist on OS/X
  patch :p1, :DATA

  def install
    # nodelete is not supported
    inreplace "Makefile", "-z nodelete", "" 

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/ir.lv2/ir.so")
  end 

end
__END__
diff -u ir.lv2-1.3.2-orig/ir.h ir.lv2-1.3.2/ir.h
--- ir.lv2-1.3.2-orig/ir.h	2012-06-25 14:56:28.000000000 +0200
+++ ir.lv2-1.3.2/ir.h	2015-12-26 19:36:38.000000000 +0100
@@ -35,7 +35,7 @@
 #define BSIZE_SR    0x1000      /* Blocksize for SRC */
 #define MAXSIZE 0x00100000  /* Max. available convolver size of zita-convolver */
 
-#define DB_CO(g) ((g) > -90.0f ? exp10f((g) * 0.05f) : 0.0f)
+#define DB_CO(g) ((g) > -90.0f ? pow(10,(g) * 0.05f) : 0.0f)
 #define CO_DB(g) ((g) > 0.0f ? 20.0f * log10f(g) : -90.0f)
 
 #define SMOOTH_CO_0      0.01
diff -u ir.lv2-1.3.2-orig/ir_gui.cc ir.lv2-1.3.2/ir_gui.cc
--- ir.lv2-1.3.2-orig/ir_gui.cc	2012-06-25 16:42:08.000000000 +0200
+++ ir.lv2-1.3.2/ir_gui.cc	2015-12-26 19:36:38.000000000 +0100
@@ -236,7 +236,7 @@
 		real = min + (y - LOG_SCALE_MIN) / (LOG_SCALE_MAX - LOG_SCALE_MIN) * (max - min);
 		real = round(10.0 * real) / 10.0; /* one decimal digit */
 	} else if (log == INVLOG) {
-		y = exp10(scale);
+		y = pow(10,scale);
 		real = min + (y - INVLOG_SCALE_MIN) / (INVLOG_SCALE_MAX - INVLOG_SCALE_MIN) * (max - min);
 		real = round(10.0 * real) / 10.0; /* one decimal digit */
 	}
@@ -253,7 +253,7 @@
 	} else if (log == LOG) {
 		scale = (real - min) / (max - min) *
 			(LOG_SCALE_MAX - LOG_SCALE_MIN) + LOG_SCALE_MIN;
-		scale = exp10(scale);
+		scale = pow(10,scale);
 	} else if (log == INVLOG) {
 		scale = (real - min) / (max - min) *
 			(INVLOG_SCALE_MAX - INVLOG_SCALE_MIN) + INVLOG_SCALE_MIN;
diff -u ir.lv2-1.3.2-orig/ir_meter.cc ir.lv2-1.3.2/ir_meter.cc
--- ir.lv2-1.3.2-orig/ir_meter.cc	2011-09-22 14:47:11.000000000 +0200
+++ ir.lv2-1.3.2/ir_meter.cc	2015-12-26 19:36:38.000000000 +0100
@@ -71,7 +71,7 @@
 	cairo_t * cr = gdk_cairo_create(p->pixmap);
 
 	float fzero = 1.0f + 90.0f/96.0f; /* result of convert_real_to_scale(ADJ_*_GAIN, 0) */
-	fzero = exp10(fzero);
+	fzero = pow(10,fzero);
 	fzero = (fzero - 10.0f) / 90.0f;
 	int zero = h * (1.0 - fzero);
 
