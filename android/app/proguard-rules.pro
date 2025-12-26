# Keep OkHttp3 classes (used by image_cropper)
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keep interface okhttp3.** { *; }
-keep interface okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Keep image_cropper classes
-keep class com.yalantis.ucrop.** { *; }
-dontwarn com.yalantis.ucrop.**

# Keep Flutter plugins
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.plugins.**
