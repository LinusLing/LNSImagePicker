//
//  MTImageSelectorViewCell.swift
//  LNSImagePicker
//
//  Created by linus on 5/24/19.
//  Copyright © 2019 linus. All rights reserved.
//

import UIKit

class LNSImagePickerCell:UICollectionViewCell {
    
    @IBOutlet weak var videoDuration: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var selectIndex: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    
    var indexPath:IndexPath!
}
