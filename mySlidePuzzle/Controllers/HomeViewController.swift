//
//  ViewController.swift
//  mySlidePuzzle
//
//  Created by hiroshings on 2016/01/02.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate {
    func goGameView()
}

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    /*-----------------------
    // MARK: - private -
    ----------------------*/

    /// UIImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let baseImage = UIImageView()
        
        // イメージ表示
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        baseImage.image = image
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.baseImage = baseImage
        
        // 選択画面閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
        
        goGameView()
    }
    
    /// STARTボタン押下でフォトライブラリを表示
    @IBAction func onTapStartBtn(sender: AnyObject) {
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
    
    
    func goGameView() -> Void {
        
        let gameView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("gameView")
        self.presentViewController(gameView, animated: true, completion: nil)
    }
}

