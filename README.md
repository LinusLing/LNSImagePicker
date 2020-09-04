# LNSImagePicker
A WeiXin like multiple image and video picker which is compatible for iOS7+.You can use  either `ALAssetsLibrary` or `Photos framework` by setting the source of `LNSImagePickerController`.

# Announcement

1. This repo fork from [MTImagePicker](https://github.com/luowenxing/MTImagePicker), and thanks to [MT](https://github.com/luowenxing) for his work.
2. Fix some bugs and add some features as shown in []()


# Demo
![demo](https://github.com/luowenxing/LNSImagePicker/blob/master/LNSImagePicker/Demo/demo.gif)

# Requirement
* iOS7.0+
* Build success in Xcode 11.6 Swift 4.0

# Changelog

<details>
<summary>1.0.0</summary>
</br>
<p>1. fix UIAlertView deprecation bug</p>
<p>2. add selectCount feature</p>
<p>3. fork from MTImagePicker 3.0.2</p>
</details>

# Installation
* There is no ohter dependency in `LNSImagePicker`.Recommanded Simply drag the `LNSImagePicker/LNSImagePicker` folder to your project.
* LNSImagePicker is also available through CocoaPods. However using CocoaPod in Swift project required dynamic framework therefore iOS8.0+ is needed.To install it, simply add the following line to your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!
pod 'LNSImagePicker', '~> 1.0.0'
```

# Usage
* The LNSImagePicker is similiar to `UIImagePickerController`.It's easy to use the image picker following the sample code in demo like below
```
let imagePicker = LNSImagePickerController.instance
imagePicker.mediaTypes = [LNSImagePickerMediaType.Photo,LNSImagePickerMediaType.Video]
imagePicker.imagePickerDelegate = self
imagePicker.maxCount = 10 // max select count
imagePicker.defaultShowCameraRoll = true // when set to true would show Camera Roll Album like WeChat by default. 
```
* You can use  either `ALAssetsLibrary` or `Photos framework` by setting the source of `LNSImagePickerController`
```
//default is LNSImagePickerSource.ALAsset
imagePicker.source = LNSImagePickerSource.ALAsset
//imagePicker.source = LNSImagePickerSource.Photos (Work on iOS8+)
```
* Call `presentViewController` 
```
self.presentViewController(imagePicker, animated: true, completion: nil)
```
* Implement the delegate method accordding to the `source`.
```
@objc protocol LNSImagePickerControllerDelegate:NSObjectProtocol {

    // Implement it when setting source to LNSImagePickerSource.ALAsset
    optional func imagePickerController(picker:LNSImagePickerController, didFinishPickingWithAssetsModels models:[LNSImagePickerAssetsModel])
    
    // Implement it when setting source to LNSImagePickerSource.Photos
    @available(iOS 8.0, *)
    optional func imagePickerController(picker:LNSImagePickerController, didFinishPickingWithPhotosModels models:[LNSImagePickerPhotosModel])
    
    optional func imagePickerControllerDidCancel(picker: LNSImagePickerController)
}
```

# TODO
* ~~Add Albums selecting support.~~ Done.
