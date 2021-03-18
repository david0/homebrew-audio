class Jalv < Formula
  desc "Simple but fully featured LV2 host for Jack"
  homepage "http://drobilla.net/software/jalv/"
  url "http://download.drobilla.net/jalv-1.6.6.tar.bz2"
  sha256 "92d141781b664373207c343cebc5e9b8ced461faf26fdccb95df0007b0639e16"
  head "http://git.drobilla.net/jalv.git"

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "jack"
  depends_on "lilv"
  depends_on "lv2"
  depends_on "qt@5"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"
  depends_on "suil"
  depends_on "gtk+3" => :optional

  unless build.head?
    # Fix crash when running jalv without arguments
    patch do
      url "https://gitlab.com/drobilla/jalv/-/commit/8952dde02d9d6761ae0cae033600f4a220c8e075.patch"
      sha256 "5fad49ccdfcdd6f0fdb9d6005a64965e3ef3b7afa354ea0cc9b0858279400d50"
    end
  end

  # Workaround: Deadlock on program start, disable semaphores
  patch :p1, :DATA

  def install
    ENV.cxx11
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/jalv -h 2>&1", 1)
  end
end
__END__
diff --git a/src/jalv.c b/src/jalv.c
index e445c64..4c825f6 100644
--- a/src/jalv.c
+++ b/src/jalv.c
@@ -104,9 +104,9 @@ map_uri(LV2_URID_Map_Handle handle,
         const char*         uri)
 {
 	Jalv* jalv = (Jalv*)handle;
-	zix_sem_wait(&jalv->symap_lock);
+	//zix_sem_wait(&jalv->symap_lock);
 	const LV2_URID id = symap_map(jalv->symap, uri);
-	zix_sem_post(&jalv->symap_lock);
+	//zix_sem_post(&jalv->symap_lock);
 	return id;
 }
 
