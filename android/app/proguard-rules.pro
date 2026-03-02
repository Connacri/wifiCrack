# Google Mobile Ads SDK rules
-keep public class com.google.android.gms.ads.** {
   public *;
}

# Flutter Fire rules
-keep class io.flutter.plugins.** { *; }
-keep class com.google.firebase.** { *; }

# Prevent shrinking of important classes
-keep class com.wificrack.dz.comwificrack.** { *; }
