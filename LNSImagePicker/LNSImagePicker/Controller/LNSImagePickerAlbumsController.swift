//
//  LNSImagePickerAlbumController.swift
//  LNSImagePicker
//
//  Created by linus on 9/6/19.
//  Copyright © 2019 linus. All rights reserved.
//

import UIKit
import AssetsLibrary

class LNSImagePickerAlbumCell:UITableViewCell {
    
    @IBOutlet weak var lbAlbumCount: UILabel!
    @IBOutlet weak var lbAlbumName: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    func setup(model:LNSImagePickerAlbumModel) {
        self.lbAlbumCount.text = "(\(model.getAlbumCount()))"
        self.lbAlbumName.text = model.getAlbumName()
        self.posterImageView.image = model.getAlbumImage(size: self.posterImageView.frame.size)
    }
}

class LNSImagePickerAlbumsController :UITableViewController {
    var defaultShowSelectCount:Bool = false
    weak var delegate:LNSImagePickerDataSourceDelegate!
    private var dataSource = [LNSImagePickerAlbumModel]()
    
    class var instance:LNSImagePickerAlbumsController {
        get {
            let storyboard = UIStoryboard(name: "LNSImagePicker", bundle: Bundle.getResourcesBundle())
            let vc = storyboard.instantiateViewController(withIdentifier: "LNSImagePickerAlbumsController") as! LNSImagePickerAlbumsController
            return vc
        }
    }
    
    override func viewDidLoad() {
        self.tableView.tableFooterView = UIView()
        LNSImagePickerDataSource.fetch(type: delegate.source, mediaTypes: delegate.mediaTypes, complete: { (dataSource) in
            self.dataSource = dataSource
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataSource[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LNSImagePickerAlbumCell", for: indexPath as IndexPath)
        (cell as? LNSImagePickerAlbumCell)?.setup(model: model)
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        self.pushToLNSImagePickerController(model: model,animate: true)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    func pushToLNSImagePickerController(model:LNSImagePickerAlbumModel,animate:Bool) {
        let controller = LNSImagePickerAssetsController.instance
        controller.defaultShowSelectCount = defaultShowSelectCount
        controller.groupModel = model
        controller.delegate = delegate
        self.navigationController?.pushViewController(controller, animated: animate)
    }
    @IBAction func btnCancelTouch(_ sender: AnyObject) {
        self.delegate.didCancel()
    }
}

