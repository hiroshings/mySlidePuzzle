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
    
    let util = Util()
    let const = AppConst()
    let defaults = NSUserDefaults()
    
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    
    override func viewWillAppear(animated: Bool) {
        
        // debug
        print(util.getCurrentTime())
    }
    
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
        baseImageView.frame = CGRectMake(0, 0, const.boardWidth, const.boardHeight)

        // デリゲートにイメージデータを渡す
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.baseImage = baseImageView
        appDelegate.bgImage = bgImageView
        
        // imageディレクトリがなければ作成
        setImageDirectory()
        
        // ローカルストレージに画像データを保存
        saveImageData(baseImageView.image!, imageFileName: ".png") // ベースイメージ
        
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
    func setImageDirectory() {
        
        let fileManager = NSFileManager.defaultManager()
        
        let dirUrl = util.getSubDirectory("image")
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
        
        let dirUrl = util.getSubDirectory("image")
        
        // ファイル名のパスを作成する
        let imageName = util.getCurrentTime() + imageFileName
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

