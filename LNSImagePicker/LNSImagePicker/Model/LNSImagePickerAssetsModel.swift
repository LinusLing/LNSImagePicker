//
//  LNSImagePickerAssetsModel.swift
//  LNSImagePicker
//
//  Created by linus on 6/27/19.
//  Copyright © 2019 linus. All rights reserved.
//
import UIKit
import AssetsLibrary
import AVFoundation

public class LNSImagePickerAssetsModel : LNSImagePickerModel {
    
    public var asset:ALAsset!
    var lib:ALAssetsLibrary = ALAsset.lib
    
    private lazy var rept:ALAssetRepresentation = {
        return self.asset.defaultRepresentation()
    }()
    
    init(mediaType:LNSImagePickerMediaType, asset:ALAsset) {
        super.init(mediaType: mediaType)
        self.asset = asset
    }
    
    override func getFileName() -> String? {
        return self.rept.filename()
    }
    
    override func getThumbImage(size:CGSize)-> UIImage? {
        return UIImage(cgImage: self.asset.thumbnail().takeUnretainedValue())
    }
    
    override func getPreviewImage() -> UIImage?{
        return UIImage(cgImage: self.asset.aspectRatioThumbnail().takeUnretainedValue())
    }
    
    override func getImageAsync(complete:@escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let img = self.rept.fullScreenImage() {
                let image = UIImage(cgImage: img.takeUnretainedValue())
                DispatchQueue.main.async {
                    complete(image)
                }
            }
        }
    }
    
    override func getVideoDurationAsync(complete:@escaping (Double) -> Void) {
        complete((self.asset.value(forProperty: ALAssetPropertyDuration) as AnyObject).doubleValue)
    }
    
    override func getAVPlayerItem() -> AVPlayerItem? {
        return AVPlayerItem(url: self.rept.url())
    }
    
    override func getFileSize() -> Int {
        return Int(self.rept.size())
    }
    
    override func getIdentity() -> String {
        return self.rept.url().absoluteString
    }
}


class LNSImagePickerAssetsAlbumModel:LNSImagePickerAlbumModel {
    
    private var group:ALAssetsGroup
    
    init(group:ALAssetsGroup) {
        self.group = group
    }
    
    override func getAlbumCount() -> Int {
        return self.group.numberOfAssets()
    }
    
    override func getAlbumName() -> String? {
        return self.group.value(forProperty: ALAssetsGroupPropertyName) as? String
    }
    
    override func getAlbumImage(size:CGSize) -> UIImage? {
        return UIImage(cgImage: self.group.posterImage().takeUnretainedValue())
    }
    
    override func getLNSImagePickerModelsListAsync(complete: @escaping ([LNSImagePickerModel]) -> Void) {
        var models = [LNSImagePickerModel]()
        DispatchQueue.global().async {
            self.group.enumerateAssets({ (result, index, success) in
                if let asset = result {
                    let ALAssetType = result?.value(forProperty: ALAssetPropertyType) as! NSString
                    let mediaType:LNSImagePickerMediaType = ALAssetType.isEqual(to: ALAssetTypePhoto) ? .Photo : .Video
                    let model = LNSImagePickerAssetsModel(mediaType: mediaType, asset:asset)
                    models.append(model)
                }
            })
            DispatchQueue.main.async {
                complete(models)
            }
        }
    }
    
    
    
}


