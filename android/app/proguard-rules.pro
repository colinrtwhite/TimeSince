# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /Users/Colin/Library/Android/sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

-allowaccessmodification
-flattenpackagehierarchy
-mergeinterfacesaggressively
-optimizationpasses 10 # If a pass finishes and no optimization is made, then it skips the rest of the passes.
-optimizations !class/merging/*, !field/*

# Work around for Android build tools bug, see https://issuetracker.google.com/issues/37070898
-dontnote android.net.http.*
-dontnote org.apache.commons.codec.**
-dontnote org.apache.http.**

# Kotlin
-assumenosideeffects class kotlin.jvm.internal.Intrinsics {
    static void checkParameterIsNotNull(java.lang.Object, java.lang.String);
}
-dontnote kotlin.**
-dontwarn kotlin.**

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }