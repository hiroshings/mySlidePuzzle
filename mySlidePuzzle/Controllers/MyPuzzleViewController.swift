//
//  MyPuzzleViewController.swift
//  mySlidePuzzle
//
//  Created by 坂本 浩 on 2016/01/07.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import UIKit

class MyPuzzleViewController: UIViewController {
    
    /*---------------------
    // MARK: - properties -
    --------------------*/
    
    @IBOutlet weak var noimageTxt: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // pazzle
    var pazzle = UIImageView()
    var imagePath: String = "" //画像のパス
    var imageData: Array<String> = [] //画像データ格納用の配列
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Puzzles"
        
        // マイパズル生成
        if let imageData = getImageDataNames() {
            
            for (var i = 0; i < imageData.count; i++) {
                
                // myPuzzleインスタンスを生成
                let rect = CGRectMake(0, 0, 300, 400)
                let myPuzzleView = MyPuzzleView(frame: rect)
                
                // myPuzzleの画像パスを取得
                let dir = getPhotoDirectory()
                let path = dir.URLByAppendingPathComponent(imageData[i]).path
                print(path!)
                
                // 画像パスのpngファイルをmyPuzzleViewのUIImageに変換
                let pazzleImage = UIImage(contentsOfFile: path!)
                myPuzzleView.puzzleImageView.image = pazzleImage
                
                // パズルの横幅・縦幅
                let puzzleWidth = myPuzzleView.bounds.size.width
                let puzzleHeight = myPuzzleView.bounds.size.height
                
                // myPuzzleViewの位置をズラす
                myPuzzleView.frame.origin.x = self.view.bounds.width / 2 - (puzzleWidth / 2)
                myPuzzleView.frame.origin.y = (puzzleHeight * CGFloat(i)) + 20
                
                // tagの付与
                myPuzzleView.puzzleImageView.tag = (i + 1)
                myPuzzleView.playBtn.tag = (i + 1)
                
                // タップ可能に
                let tap = UITapGestureRecognizer(target: self, action: "onTapPlayBtn:")
                myPuzzleView.puzzleImageView.addGestureRecognizer(tap)
                
                myPuzzleView.playBtn.addTarget(self, action: "onTapPlayBtn:", forControlEvents: .TouchUpInside)
                myPuzzleView.userInteractionEnabled = true
                
                // 下にスクロールできるようにContentSizeを拡大
                scrollView.contentSize.height += (puzzleHeight + 20)
                print(scrollView.contentSize.height)
                
                scrollView.addSubview(myPuzzleView)
            }
            
        } else {
            
            // 画像データが0の場合、代替テキストを表示
            noimageTxt.alpha = 1.0

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     ローカルストレージのphotoディレクトリを取得
     
     - parameters:
        - none
     
     - returns: photoディレクトリまでのパス
     */
    func getPhotoDirectory() -> NSURL {
        
        let fileManager = NSFileManager.defaultManager()
        
        // NSURL型でルートディレクトリの取得
        let url = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        // photoディレクトリを参照
        let dirUrl = url.URLByAppendingPathComponent("photo")
        
        return dirUrl
    }
    
    /**
     ローカルストレージからファイル名を取得
     
     - parameters:
        - none
     
     - returns: ローカルストレージのpngファイル名
     */
    func getImageDataNames() -> Array<String>? {
        
        let fileManager = NSFileManager.defaultManager()
        
        guard let dir = getPhotoDirectory().path else {
            return nil
        }
        
        do {
            // ファイル名が格納された配列を返す
            let pngImages = try fileManager.contentsOfDirectoryAtPath(dir)
            print(pngImages)
            return pngImages
        }
        catch {
            // ファイル名がない場合、nilを返す
            return nil
        }
    }
    
    /**
     playボタン押下時のイベント
     
     - parameters:
        - none
     
     - returns: none
     */
    func onTapPlayBtn(sender: AnyObject) {
        
        // tag = 0の場合、return
        guard let touchPuzzleId = sender.tag else {
            return
        }
        if touchPuzzleId == 0 {
            return
        }
        
        // 画像データのパスを取得
        let imageData = getImageDataNames()
        let dir = getPhotoDirectory()
        let path = dir.URLByAppendingPathComponent(imageData![touchPuzzleId - 1]).path
        
        // 画像データからUIImageViewを生成し、delegateに通知
        let baseImage = UIImageView()
        baseImage.image = UIImage(contentsOfFile: path!)
        baseImage.frame = CGRectMake(0, 0, AppConst.boardWidth, AppConst.boardHeight)
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.baseImage = baseImage
        
        // ゲーム画面に遷移
        self.performSegueWithIdentifier("goGameView", sender: self)
    }
    
}
