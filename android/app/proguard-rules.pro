# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.kts.

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class androidx.lifecycle.** { *; }

# Gson specific classes
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**

# Keep generic signature of Call, Response (R8 full mode strips signatures from non-kept items).
-keep,allowshrinking,allowoptimization interface retrofit2.Call
-keep,allowshrinking,allowoptimization class retrofit2.Response

# With R8 full mode generic signatures are stripped for classes that are not
# kept. Suspend functions are wrapped in continuations where the type argument
# is used.
-keep,allowshrinking,allowoptimization class kotlin.coroutines.Continuation

# AudioPlayers plugin rules
-keep class xyz.luan.audioplayers.** { *; }

# Provider plugin rules (for state management)
-keep class * extends androidx.lifecycle.ViewModel { *; }

# Wakelock plugin rules
-keep class io.flutter.plugins.wakelock.** { *; }

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep setters in Views so that animations can still work.
-keepclassmembers public class * extends android.view.View {
    void set*(***);
    *** get*();
}

# Keep classes that might be referenced only in XML, etc.
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Obfuscation parameters
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable 