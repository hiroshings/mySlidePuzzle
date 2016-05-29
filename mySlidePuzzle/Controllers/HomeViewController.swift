//
//  ViewController.swift
//  mySlidePuzzle
//
//  Created by hiroshings on 2016/01/02.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import UIKit
import Photos

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /*-----------------------
    // MARK: - properties -
    ----------------------*/
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var myPuzzleBtn: UIButton!
    @IBOutlet weak var puzzleLevelSC: UISegmentedControl! // レベル切り替えボタン
    
    let defaults = NSUserDefaults()
    
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppearは画面遷移ごとに毎回呼ばれます。ね？")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoadは画面をインスタンス化するとき(初回)しか呼ばれないですね")
        
        // 初期値は8パズル
        defaults.registerDefaults(["level": AppConst.piece8])
        
        // userDefaultからレベル選択ボタンのカレント状態を再現する
        if let level = defaults.objectForKey("level") {
            
            switch String(level) {
            case AppConst.piece8:
                puzzleLevelSC.selectedSegmentIndex = 0
            case AppConst.piece15:
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
    
    
    /*-----------------------
    // MARK: - private -
    ----------------------*/

    /// UIImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let baseImageView = UIImageView()
        
        let currentTime = Util.getCurrentTime()
        let fileName = ".png"
        let imageName = currentTime + fileName
        
        // イメージデータを取得
        let baseImage = info[UIImagePickerControllerEditedImage] as! UIImage // editedImageにすることで編集後のイメージを使用可能
        
        baseImageView.image = baseImage
        
        // TODO: 縦横比を守ったままリサイズ
        baseImageView.frame = CGRectMake(0, 0, AppConst.boardWidth, AppConst.boardHeight)

        // デリゲートにイメージデータを渡す
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.baseImage = baseImageView
        appDelegate.puzzleImageName = imageName
        
        
        // imageディレクトリがなければ作成
        setImageDirectory()
        
        // ローカルストレージに画像データを保存
        saveImageData(baseImageView.image!, imageName: imageName) // ベースイメージ
        
        // 選択画面閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // ゲーム画面に遷移
        self.performSegueWithIdentifier("goGameView", sender: self)
    }
    
    
    /// STARTボタン押下でフォトライブラリを表示
    @IBAction func onTapStartBtn(sender: AnyObject) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch(status) {
        
        // カメラロールへのアクセスが許可されていない場合
        case PHAuthorizationStatus.Denied:
            let alert:UIAlertController = UIAlertController(
                title: "エラー",
                message: "「写真」へのアクセスが拒否されています。設定より変更してください",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel, handler: nil)
            let defaultAction:UIAlertAction = UIAlertAction(title: "設定画面へ", style: UIAlertActionStyle.Default, handler: {
                (UIAlertAction) -> Void in (self.goSettingApp())
            })
            
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            presentViewController(alert, animated: true, completion: nil)
            
        default:
            break
        }
        
        /**
        - 画像選択画面を表示
        */
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            // カメラロールが端末に存在しない場合
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
     設定アプリに遷移する
     
     - parameters:
        - none
     
     - returns: none
     */
    func goSettingApp() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    /**
     imageディレクトリを作成
     
     - parameters:
        - none
     
     - returns: imageディレクトリのパス
     */
    func setImageDirectory() {
        
        let fileManager = NSFileManager.defaultManager()
        
        let dirUrl = Util.getSubDirectory("image")
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
    func saveImageData(image: UIImage, imageName: String) {
        
        // pngデータ生成
        let _imageData = UIImagePNGRepresentation(image)
        
        let dirUrl = Util.getSubDirectory("image")
        
        // ファイル名のパスを作成する
        let path = dirUrl.URLByAppendingPathComponent(imageName).path
        
        // nilチェック
        guard let imageData = _imageData else {
            return
        }
        
        // pngデータの保存
        if imageData.writeToFile(path!, atomically: true) {
            print("Save" + imageName)
        } else {
            print("error writing file: \(path)")
        }
    }
    
    /**
     レベル変更をuserDefaultに保存
     
     - parameters:
        - sender: actionの送信元オブジェクト
     
     - returns: none
     */
    @IBAction func levelChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            case 0:
                defaults.setObject(AppConst.piece8, forKey: "level")
            case 1:
                defaults.setObject(AppConst.piece15, forKey: "level")
            default:
                break
        }
    }
}

