//
//  File.swift
//  LNSImagePicker
//
//  Created by linus on 9/9/19.
//  Copyright © 2019 linus. All rights reserved.
//

import UIKit

@objc public enum LNSImagePickerMediaType:Int {
    case Photo
    case Video
}


@objc public protocol LNSImagePickerControllerDelegate:NSObjectProtocol {
    // Implement it when setting source to LNSImagePickerSource.ALAsset
    @objc optional func imagePickerController(picker:LNSImagePickerController, didFinishPickingWithAssetsModels models:[LNSImagePickerAssetsModel])
    
    // Implement it when setting source to LNSImagePickerSource.Photos
    @available(iOS 8.0, *)
    @objc optional func imagePickerController(picker:LNSImagePickerController, didFinishPickingWithPhotosModels models:[LNSImagePickerPhotosModel])
    
    @objc optional func imagePickerControllerDidCancel(picker: LNSImagePickerController)
}

public class LNSImagePickerController:UINavigationController {
    
    public weak var imagePickerDelegate:LNSImagePickerControllerDelegate?
    public var mediaTypes:[LNSImagePickerMediaType]  = [.Photo]
    public var maxCount: Int = Int.max
    public var defaultShowCameraRoll:Bool = true
    private var _defaultShowSelectCount = false
    public var defaultShowSelectCount:Bool {
        get {
            return self._defaultShowSelectCount
        }
        set {
            self._defaultShowSelectCount = newValue
            
            if let vc = self.viewControllers.first, vc.isKind(of: LNSImagePickerAlbumsController.self) {
                (vc as! LNSImagePickerAlbumsController).defaultShowSelectCount = newValue
            }
        }
    }
    public var selectedSource = [LNSImagePickerModel]()
    private var _source = LNSImagePickerSource.Photos
    public var source:LNSImagePickerSource {
        get {
            return self._source
        }
        set {
            self._source = newValue
            // 只有iOS8以上才能使用Photos框架
            if newValue == .Photos {
                if #available(iOS 8.0, *) {
                    
                } else {
                    self._source = .ALAsset
                }
            }
        }
    }
    
    public var mediaTypesNSArray:NSArray {
        get {
            let arr = NSMutableArray()
            for mediaType in self.mediaTypes {
                arr.add(mediaType.rawValue)
            }
            return arr
        }
        set {
            self.mediaTypes.removeAll()
            for mediaType in newValue {
                if let intType = mediaType as? Int {
                    if intType == 0 {
                        self.mediaTypes.append(.Photo)
                    } else if intType == 1 {
                        self.mediaTypes.append(.Video)
                    }
                }
            }
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        if self.defaultShowCameraRoll {
            let controller = LNSImagePickerAssetsController.instance
            controller.defaultShowSelectCount = defaultShowSelectCount
            controller.delegate = self
            LNSImagePickerDataSource.fetchDefault(type: self.source, mediaTypes: self.mediaTypes) {
                controller.groupModel = $0
                self.pushViewController(controller, animated: false)
            }
        }
    }
    
    public class var instance:LNSImagePickerController {
        get {
            let controller = LNSImagePickerAlbumsController.instance
            let navigation = LNSImagePickerController(rootViewController: controller)
            controller.delegate = navigation
            return navigation
        }
    }
}

protocol LNSImagePickerDataSourceDelegate:NSObjectProtocol {
    var selectedSource:[LNSImagePickerModel] { get set }
    var maxCount:Int { get }
    var mediaTypes:[LNSImagePickerMediaType] { get }
    var source:LNSImagePickerSource { get }
    func didFinishPicking()
    func didCancel()
}

extension LNSImagePickerController:LNSImagePickerDataSourceDelegate {
    
    func didFinishPicking() {
        if self.source == .Photos {
            if #available(iOS 8.0, *) {
                self.imagePickerDelegate?.imagePickerController?(picker:self, didFinishPickingWithPhotosModels: selectedSource as! [LNSImagePickerPhotosModel])
            } else {
                // Fallback on earlier versions
            }
        } else {
            self.imagePickerDelegate?.imagePickerController?(picker:self, didFinishPickingWithAssetsModels: selectedSource as! [LNSImagePickerAssetsModel])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func didCancel() {
        imagePickerDelegate?.imagePickerControllerDidCancel?(picker: self)
        self.dismiss(animated: true, completion: nil)
    }

}


