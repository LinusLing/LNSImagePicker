//
//  ImageSelectorViewModel.swift
//  
//
//  Created by linus on 5/9/19.
//  Copyright © 2019 linus. All rights reserved.
//

import UIKit
import AVFoundation

func ==(lhs:LNSImagePickerModel, rhs:LNSImagePickerModel) -> Bool {
    return lhs.getIdentity() == rhs.getIdentity()
}

public class LNSImagePickerModel:NSObject {
    
    // 实现自定义的array contains
    override public func isEqual(_ object: Any?) -> Bool {
        guard let obj = object as? LNSImagePickerModel else { return false }
        return obj.getIdentity() == self.getIdentity()
    }
    
    public var mediaType:LNSImagePickerMediaType
    
    init(mediaType:LNSImagePickerMediaType) {
        self.mediaType = mediaType
    }
    
    func getIdentity() -> String {
        fatalError("getIdentity has not been implemented")
    }
    
    func getFileName() -> String? {
        fatalError("getFileName has not been implemented")
    }
    
    func getThumbImage(size:CGSize)-> UIImage? {
        fatalError("getThumbImage has not been implemented")
    }
    
    func getPreviewImage() -> UIImage?{
        fatalError("getPreviewImage has not been implemented")
    }
    
    func getImageAsync(complete: @escaping (UIImage?) -> Void) {
        fatalError("getImageAsync has not been implemented")
    }
    
    func getVideoDurationAsync(complete: @escaping (Double) -> Void) {
        fatalError("getVideoDurationAsync has not been implemented")
    }
    
    func getAVPlayerItem () -> AVPlayerItem? {
        fatalError("getAVPlayerItem has not been implemented")
    }
    
    func getFileSize() -> Int {
        fatalError("getFileSize has not been implemented")
    }
}


class LNSImagePickerAlbumModel:NSObject {
    
    func getAlbumName() -> String? {
        fatalError("getAlbumName has not been implemented")
    }
    
    func getAlbumImage(size:CGSize) -> UIImage? {
        fatalError("getAlbumImage has not been implemented")
    }
    
    func getAlbumCount() -> Int {
        fatalError("getAlbumCount has not been implemented")
    }
    
    func getLNSImagePickerModelsListAsync(complete: @escaping ([LNSImagePickerModel]) -> Void) {
        fatalError("getLNSImagePickerModelsAsync has not been implemented")
    }
    
}
