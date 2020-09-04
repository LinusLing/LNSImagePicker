//
//  ViewController.swift
//  LNSImagePicker
//
//  Created by linus on 5/23/19.
//  Copyright © 2019 linus. All rights reserved.
//

import UIKit
import AssetsLibrary

class ViewController: UITableViewController,LNSImagePickerControllerDelegate {

    private var dataSource = [LNSImagePickerModel]()
    private var lib:ALAssetsLibrary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else {
            return dataSource.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: String(indexPath.row), for: indexPath as IndexPath)
            return cell
        } else {
            let model = self.dataSource[indexPath.row]
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath as IndexPath)
            // 不推荐的写法，此处为了简便所以这样实现
            let imageView = (cell.viewWithTag(1001) as! UIImageView)
            imageView.image = model.getThumbImage(size: imageView.frame.size)
            (cell.viewWithTag(1002) as! UILabel).text = model.getFileSize().byteFormat()
            (cell.viewWithTag(1003) as! UILabel).text = model.getFileName()
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 && indexPath.section == 0 {
            self.btnPickTouch()
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return 100
        }
    }
    
    @available(iOS 8.0, *)
    func imagePickerController(picker: LNSImagePickerController, didFinishPickingWithPhotosModels models: [LNSImagePickerPhotosModel]) {
        self.dataSource = models
        self.tableView.reloadData()
    }
    
    func imagePickerController(picker: LNSImagePickerController, didFinishPickingWithAssetsModels models: [LNSImagePickerAssetsModel]) {
        self.dataSource = models
        self.tableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: LNSImagePickerController) {
        print("cancel")
    }
    
    func btnPickTouch() {
        // 不推荐的写法，此处为了简便所以这样实现。
        let textCount = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(1001) as! UITextField
        let photoSwitch = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.viewWithTag(1001) as! UISwitch
        let videoSwitch = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.viewWithTag(1001) as! UISwitch
        let defaultAllSwitch = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0))?.viewWithTag(1001) as! UISwitch
        let sourceSwitch = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0))?.viewWithTag(1001) as! UISwitch
        let selectCountSwitch = self.tableView.cellForRow(at: IndexPath(row: 5, section: 0))?.viewWithTag(1001) as! UISwitch
        var mediaTypes = [LNSImagePickerMediaType]()
        var source = LNSImagePickerSource.ALAsset
        var defaultShowCameraRoll = false
        if photoSwitch.isOn == true {
            mediaTypes.append(LNSImagePickerMediaType.Photo)
        }
        if videoSwitch.isOn == true {
            mediaTypes.append(LNSImagePickerMediaType.Video)
        }
        if sourceSwitch.isOn == false {
            source = LNSImagePickerSource.Photos
        }
        if defaultAllSwitch.isOn == true {
            defaultShowCameraRoll = true
        }
        
        // 使用示例
        let vc = LNSImagePickerController.instance
        vc.mediaTypes = mediaTypes
        vc.source = source
        vc.imagePickerDelegate = self
        vc.defaultShowSelectCount = selectCountSwitch.isOn
        if let text = textCount.text,let maxCount = Int(text) {
            vc.maxCount = maxCount
        }
        vc.defaultShowCameraRoll = defaultShowCameraRoll
        self.present(vc, animated: true, completion: nil)
    }

}

