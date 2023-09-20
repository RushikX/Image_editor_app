# Image_editor_app

features of the app:
```
selects the image from the device's gallery.
for editing the image , image_editor_plus was used which includes cropping, rotating, applying filters and more
displays both the original and edited versions of the image (preview of the image)
performs editing on the previously edited image instead of the original image; if there's no previously edited image, it will edit the original image.
saves the edited image to the device's gallery
provides feedback messages to users through Snackbars

```




Here's the demo which shows the features of the app:




https://github.com/RushikX/Image_editor_app/assets/111432352/1b56abb8-ed51-46fe-89c3-827501f35cef







Required Dependencies in ```pubspec.yaml```
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

adding the permission to the ```AndroidManifest.xml ```
``` dart
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.yourappname">
    
    <!-- ... other manifest elements ... -->
    
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
</manifest>
```


Make sure to replace "com.example.yourappname" with the actual package name of your Flutter app.



