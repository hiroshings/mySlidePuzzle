//
//  ViewController.swift
//  mySlidePuzzle
//
//  Created by hiroshings on 2016/01/02.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let defaults = NSUserDefaults.standardUserDefaults()
    // 現在時刻
    let currentTime = CurrentTime()
    let currentTimeFormatted = CurrentTimeFormatted()
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // log読み込み
        getImageDataSaveLog()
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
        
        // イメージデータを取得
        let image = info[UIImagePickerControllerEditedImage] as! UIImage // editedImageにすることで編集後のイメージを使用可能
        baseImage.image = image
        baseImage.frame = CGRectMake(0, 0, AppConst.boardWidth, AppConst.boardHeight)
        
        // デリゲートにイメージデータを渡す
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.baseImage = baseImage
        
        // ローカルストレージに画像データを保存
        savePhotoData(baseImage.image!)
        
        // log保存
        setImageDataSaveLog()
        
        // 選択画面閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // ゲーム画面に遷移
        self.performSegueWithIdentifier("goGameView", sender: self)
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
    
    /**
     photoディレクトリを作成
     
     - parameters:
        - none
     
     - returns: photoディレクトリのパス
     */
    func setDirectory() -> NSURL {
        
        let fileManager = NSFileManager.defaultManager()
        
        // NSURL型でルートディレクトリの取得
        let url = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        print("ディレクトリ = " + String(url))
        
        // photoディレクトリを参照
        let dirUrl = url.URLByAppendingPathComponent("photo")
        let dir = dirUrl.path
        print("ディレクトリ = " + dir!)
        
        // photoディレクトリがなければ作成
        if !fileManager.fileExistsAtPath(dir!) {
            do {
                try fileManager.createDirectoryAtPath(dir!, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("Unable to create directory: \(error)")
            }
        }
        
        return dirUrl
    }
    
    /**
     photoディレクトリにpng画像を保存
     
     - parameters:
        - image: 保存する画像
     
     - returns: none
     */
    func savePhotoData(image: UIImage) {
        
        // pngデータ生成
        let _photoData = UIImagePNGRepresentation(image)
        
        let dirUrl = setDirectory()
        
        // ファイル名のパスを作成する
        let photoName = currentTime.getCurrentTime() + ".png"
        let path = dirUrl.URLByAppendingPathComponent(photoName).path
        
        // nilチェック
        guard let photoData = _photoData else {
            return
        }
        
        // pngデータの保存
        if photoData.writeToFile(path!, atomically: true) {
            print(photoName)
        } else {
            print("error writing file: \(path)")
        }
    }
    
    /// 画像保存ログを保存
    func setImageDataSaveLog() {
        
        let log = currentTimeFormatted.getCurrentTime()
        defaults.setObject(log, forKey: "log")
    }
    
    /// 画像保存ログの読み込み
    func getImageDataSaveLog() {
        
        if let log = defaults.objectForKey("log") {
            print("画像保存ログ：" + String(log))
        }
    }
}

