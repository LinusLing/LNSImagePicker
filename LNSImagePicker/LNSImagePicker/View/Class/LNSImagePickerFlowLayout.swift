//
//  LNSImagePickerFlowLayout.swift
//  LNSImagePicker
//
//  Created by linus on 5/24/19.
//  Copyright © 2019 linus. All rights reserved.
//

import UIKit

class LNSImagePickerFlowLayout:UICollectionViewFlowLayout {
    var space:CGFloat!
    var itemOfRow:Int = 4
    override func prepare() {
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        let bounds = UIScreen.main.compatibleBounds
        self.space = bounds.width  / CGFloat(itemOfRow) / 20.0
        // - 1 避免精度丢失导致一行放不下4个
        let width = ( bounds.width - self.space - 1 ) / CGFloat(itemOfRow)
        self.itemSize = CGSize(width: width, height: width)
        if let collectionView = (self.collectionView as? LNSImagePickerCollectionView) {
            collectionView.leading.constant = self.space / 2.0
            collectionView.trailing.constant = self.space / 2.0
            collectionView.contentOffset = self.targetContentOffset(forProposedContentOffset: collectionView.contentOffset)
        }
    }
    
    // 旋转之后重新布局，维持contentOffset和之前显示的cell一致
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if let collectionView = self.collectionView as? LNSImagePickerCollectionView,let prevItemSize = collectionView.prevItemSize {
            let rows = collectionView.prevOffset / prevItemSize.width
            collectionView.prevItemSize = nil
            return CGPoint(x: 0, y: self.itemSize.width * rows)
        }
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
}


class LNSImagePickerPreviewFlowLayout:UICollectionViewFlowLayout {
    
    override func prepare() {
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        if let collectionView = self.collectionView {
            self.itemSize = collectionView.bounds.size
            collectionView.contentOffset = self.targetContentOffset(forProposedContentOffset: collectionView.contentOffset)
        }
    }
    
    //旋转后保证还是之前的图片
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if let collectionView = self.collectionView as? LNSImagePickerCollectionView,let prevItemSize = collectionView.prevItemSize {
            let rows = collectionView.prevOffset / prevItemSize.width
            collectionView.prevItemSize = nil
            return CGPoint(x: self.itemSize.width * rows, y: 0)
        }
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
    
}
