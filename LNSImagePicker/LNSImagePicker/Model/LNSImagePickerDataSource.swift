//
//  LNSImagePickerDataSource.swift
//  LNSImagePicker
//
//  Created by linus on 9/6/19.
//  Copyright © 2019 linus. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AssetsLibrary
import PhotosUI

@objc public enum LNSImagePickerSource:Int {
    case ALAsset
    case Photos
}

class LNSImagePickerDataSource {
    
    class func fetch(type:LNSImagePickerSource,mediaTypes:[LNSImagePickerMediaType],complete:@escaping  ([LNSImagePickerAlbumModel]) -> Void) {
        if type == .ALAsset {
            LNSImagePickerDataSource.fetchByALAsset(mediaTypes: mediaTypes) { complete($0) }
        } else if type == .Photos {
            if #available(iOS 8.0, *) {
                
                LNSImagePickerDataSource.fetchByPhotos(mediaTypes: mediaTypes) { complete($0) }
            }
        }
    }
    
    // 可优化 这里简单复用代码，取数量最多的group作为默认所有相片的group
    class func fetchDefault(type:LNSImagePickerSource,mediaTypes:[LNSImagePickerMediaType],complete:@escaping  (LNSImagePickerAlbumModel) -> Void) {
        if type == .ALAsset {
            LNSImagePickerDataSource.fetchByALAsset(mediaTypes: mediaTypes) {
                if let model = ($0.max { $0.getAlbumCount() < $1.getAlbumCount() }) {
                    complete(model)
                }
            }
        } else if type == .Photos {
            if #available(iOS 8.0, *) {
                LNSImagePickerDataSource.fetchByPhotos(mediaTypes: mediaTypes) {
                    if let model = ($0.max { $0.getAlbumCount() < $1.getAlbumCount() }) {
                        complete(model)
                    }
                }
            }
        }
    }
    
    class func fetchByALAsset(mediaTypes:[LNSImagePickerMediaType],complete:@escaping ([LNSImagePickerAlbumModel]) -> Void) {
        
        var models = [LNSImagePickerAlbumModel]()
        ALAsset.lib.enumerateGroupsWithTypes(ALAssetsGroupAll|ALAssetsGroupLibrary, usingBlock: {
            (Group, success) in
            if let group = Group {
                var filter:ALAssetsFilter?
                let containsPhoto = mediaTypes.contains(.Photo)
                let containsVideo = mediaTypes.contains(.Video)
                filter = containsPhoto ? ALAssetsFilter.allPhotos() : filter
                filter = containsVideo ? ALAssetsFilter.allVideos() : filter
                filter = containsPhoto && containsVideo ? ALAssetsFilter.allAssets() : filter
                if let Fliter = filter {
                    group.setAssetsFilter(Fliter)
                }
                if group.numberOfAssets() > 0 {
                    let model = LNSImagePickerAssetsAlbumModel(group: group)
                    models.insert(model, at: 0)
                }
            } else {
                complete(models)
            }
        }){
            (NSError) in
            LNSImagePickerDataSource.showUnAuthorize()
        }
    }
    
    @available(iOS 8.0, *)
    class func fetchByPhotos(mediaTypes:[LNSImagePickerMediaType],complete:@escaping ([LNSImagePickerAlbumModel]) -> Void) {
        
        func chargeAuthorizationStatus(status: PHAuthorizationStatus,onAuthorized:@escaping () -> Void) {
            switch (status) {
            case .limited:
                onAuthorized()
            case .authorized:
                onAuthorized()
            case .denied:
                LNSImagePickerDataSource.showUnAuthorize()
                break
            case .restricted:
                LNSImagePickerDataSource.showUnAuthorize()
                break
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                    guard status != .notDetermined else {
                        return
                    }
                    DispatchQueue.main.async {
                        chargeAuthorizationStatus(status: status,onAuthorized: onAuthorized )
                    }
                })
            }
        }
        
        chargeAuthorizationStatus(status: PHPhotoLibrary.authorizationStatus()) {
            var models = [LNSImagePickerAlbumModel]()
            func fetchAlbums() -> [PHFetchResult<AnyObject>] {
                let userAlbumsOptions = PHFetchOptions()
                userAlbumsOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
                userAlbumsOptions.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
                var albums = [PHFetchResult<AnyObject>]()
                albums.append(
                    PHAssetCollection.fetchAssetCollections(
                        with: PHAssetCollectionType.smartAlbum,
                        subtype: PHAssetCollectionSubtype.albumRegular,
                        options: nil) as! PHFetchResult<AnyObject>
                )
                albums.append(
                    PHAssetCollection.fetchAssetCollections(
                        with: PHAssetCollectionType.album,
                        subtype: PHAssetCollectionSubtype.any,
                        options: userAlbumsOptions) as! PHFetchResult<AnyObject>
                )
                return albums
            }
            
            let results = fetchAlbums()
            let options = PHFetchOptions()
            var formats = [String]()
            var arguments = [Int]()
            for type in mediaTypes {
                formats.append("mediaType = %d")
                if type == .Photo {
                    arguments.append(PHAssetMediaType.image.rawValue)
                } else if type == .Video {
                    arguments.append(PHAssetMediaType.video.rawValue)
                }
            }
            options.predicate = NSPredicate(format: formats.joined(separator: " or "), argumentArray: arguments)
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            for (_, result) in results.enumerated() {
                result.enumerateObjects({ (collection, index, isStop) -> Void in
                    let album = collection as! PHAssetCollection
                    let assetResults = PHAsset.fetchAssets(in: album, options: options)
                    var count = 0
                    switch album.assetCollectionType {
                    case .album:
                        count = assetResults.count
                    case .smartAlbum:
                        count = assetResults.count
                    case .moment:
                        count = 0
                    }
                    if count > 0 {
                        let model = LNSImagePickerPhotosAlbumModel(result: assetResults as! PHFetchResult<AnyObject>, albumCount: count, albumName: album.localizedTitle)
                        models.append(model)
                    }
                })
            }
            complete(models)
        }
    }
    
    
    
    class func showUnAuthorize() {
        DispatchQueue.main.async {
            let alertView = FlashAlertView(message: "照片访问权限被禁用，请前往系统设置->隐私->照片中，启用本程序对照片的访问权限".localized, delegate: nil)
            alertView.show()
        }
    }
}

extension PHAsset {

    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
