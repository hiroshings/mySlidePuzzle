//
//  ViewController.swift
//  mySlidePuzzle
//
//  Created by hiroshings on 2016/01/02.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /*-----------------------
    // MARK: - properties -
    ----------------------*/
    
    @IBOutlet weak var puzzleLevelSC: UISegmentedControl! // レベル切り替えボタン
    let puzzleDirectory = PuzzleDirectory() // ディレクト管理クラス
    
    let defaults = NSUserDefaults()
    let const = AppConst()
    
    // 現在時刻
    let currentTime = CurrentTime()
    let currentTimeFormatted = CurrentTimeFormatted()
    
    
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期値は8パズル
        defaults.registerDefaults(["level": const.piece8])
        
        // レベル選択ボタンの選択位置初期化
        if let level = defaults.objectForKey("level") {
            
            switch String(level) {
            case const.piece8:
                puzzleLevelSC.selectedSegmentIndex = 0
            case const.piece15:
                puzzleLevelSC.selectedSegmentIndex = 1
            default:
                break
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
    
    /*-----------------------
    // MARK: - private -
    ----------------------*/

    /// UIImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let baseImageView = UIImageView()
        let bgImageView = UIImageView()
        
        // イメージデータを取得
        let baseImage = info[UIImagePickerControllerEditedImage] as! UIImage // editedImageにすることで編集後のイメージを使用可能
        let bgImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        baseImageView.image = baseImage
        bgImageView.image = bgImage
        
        // TODO: 縦横比を守ったままリサイズ
        baseImageView.frame = CGRectMake(0, 0, AppConst.boardWidth, AppConst.boardHeight)
        bgImageView.frame = CGRectMake(0, 0, AppConst.screenBounds.width, AppConst.screenBounds.height)

        // デリゲートにイメージデータを渡す
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.baseImage = baseImageView
        appDelegate.bgImage = bgImageView
        
        // imageディレクトリがなければ作成
        setDirectory()
        
        // ローカルストレージに画像データを保存
        saveImageData(baseImageView.image!, imageFileName: ".png") // ベースイメージ
        saveImageData(bgImageView.image!, imageFileName: "_bg.png") // 背景イメージ
        
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
     imageディレクトリを作成
     
     - parameters:
        - none
     
     - returns: imageディレクトリのパス
     */
    func setDirectory() {
        
        let fileManager = NSFileManager.defaultManager()
        
        let dirUrl = puzzleDirectory.getSubDirectory("image")
        let dir = dirUrl.path
        print("ディレクトリ = " + dir!)
        
        // imageディレクトリがなければ作成
        if !fileManager.fileExistsAtPath(dir!) {
            do {
                try fileManager.createDirectoryAtPath(dir!, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("Unable to create directory: \(error)")
            }
        }
    }
    
    /**
     imageディレクトリにpng画像を保存
     
     - parameters:
        - image: 保存する画像
     
     - returns: none
     */
    func saveImageData(image: UIImage, imageFileName: String) {
        
        // pngデータ生成
        let _imageData = UIImagePNGRepresentation(image)
        
        let dirUrl = puzzleDirectory.getSubDirectory("image")
        
        // ファイル名のパスを作成する
        let imageName = currentTime.getCurrentTime() + imageFileName
        let path = dirUrl.URLByAppendingPathComponent(imageName).path
        
        // nilチェック
        guard let imageData = _imageData else {
            return
        }
        
        // pngデータの保存
        if imageData.writeToFile(path!, atomically: true) {
            print(imageName)
        } else {
            print("error writing file: \(path)")
        }
    }
    
    func getImageDataSaveLog() {
        
        if let log = defaults.objectForKey("log") {
            print("画像保存ログ：" + String(log))
        }
    }
    
    /**
     レベル変更をデリゲートに通知
     
     - parameters:
        - sender: actionの送信元オブジェクト
     
     - returns: none
     */
    @IBAction func levelChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            case 0:
                defaults.setObject(const.piece8, forKey: "level")
            case 1:
                defaults.setObject(const.piece15, forKey: "level")
            default:
                break
        }
    }
}

