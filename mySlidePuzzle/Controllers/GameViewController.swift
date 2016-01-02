//
//  GameViewController.swift
//  mySlidePuzzle
//
//  Created by hiroshings on 2016/01/02.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var baseImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "My Slide Puzzle"
        
        // TODO: HOME画面で選択させる
        /**
        - 画像選択画面を表示
        */
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            // アラート表示
            let alert:UIAlertController = UIAlertController(
                title: "警告",
                message: "フォトライブラリにアクセスできません",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
        } else {
            
            let imagePickerController = UIImagePickerController()
            
            // フォトライブラリから選択
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            // 編集可能に
            imagePickerController.allowsEditing = true
            
            // デリゲート
            imagePickerController.delegate = self
            
            // 選択画面起動
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            
        }
    }
    
    
    /*-----------------------
    // MARK: - private -
    ----------------------*/
    
    /// UIImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // イメージ表示
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        baseImage.image = image
        
        // 選択画面閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}