# Image_editor_app


```Here's the demo for the app, which shows the features of the app:```




Uploading Android Emulator - Pixel_6_API_33_5554 2023-09-20 22-37-31.mp4…




Required Dependencies in ```pubspec.yaml```:
 ``` dart
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  image: ^4.0.17
  image_picker: ^1.0.4
  image_editor_plus: ^1.0.3
  path_provider: ^2.1.1
  permission_handler: ^11.0.0
```

adding the permission to the ```AndroidManifest.xml ```:
``` dart
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.yourappname">
    
    <!-- ... other manifest elements ... -->
    
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
</manifest>
```


Make sure to replace "com.example.yourappname" with the actual package name of your Flutter app.



