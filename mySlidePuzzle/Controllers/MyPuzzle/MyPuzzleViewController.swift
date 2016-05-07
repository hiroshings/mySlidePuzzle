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
    
    // puzzle
    var myPuzzleView = MyPuzzleView()
    var imagePath: String = "" //画像のパス
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Puzzles"
    }
    
    override func viewWillAppear(animated: Bool) {
        
        initMypuzzleViews()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     パズル一覧を生成する
     
     - parameters:
        - none
     
     - returns: none
     */
    func initMypuzzleViews() {
        
        let screenWidth = AppConst.screenSize.width
        let myPuzzleViewHeight = AppConst.myPuzzleViewHeight
        
        if let imageDataNames = Util.getImageDataNames() {
            
            scrollView.contentSize = CGSizeMake(screenWidth, myPuzzleViewHeight * CGFloat(imageDataNames.count))
            
            if imageDataNames.isEmpty {
                
                // 画像データが0の場合、代替テキストを表示
                noimageTxt.alpha = 1.0
            }
            
            for (index, imageDataName) in imageDataNames.enumerate() {
                
                // myPuzzleインスタンスを生成
                let rect = CGRectMake(0, 0, 300, 400)
                myPuzzleView = MyPuzzleView(frame: rect)
                
                // myPuzzleの画像パスを取得
                let dir = Util.getSubDirectory("image")
                let path = dir.URLByAppendingPathComponent(imageDataName).path
                
                // ハイスコアを表示
                let defaults = NSUserDefaults.standardUserDefaults()
                
                if let highScoreData = defaults.objectForKey(imageDataName) {
                    
                    let highScore = highScoreData as! Int
                    
                    let formattedTime = Util.formatTime(highScore)
                    myPuzzleView.highScore.text = formattedTime
                    
                    print("score" + formattedTime)
                } else {
                    print("no score")
                }
                
                // 画像パスのpngファイルをmyPuzzleViewのUIImageに変換
                let pazzleImage = UIImage(contentsOfFile: path!)
                myPuzzleView.puzzleImageView.image = pazzleImage
                
                // パズルの横幅・縦幅
                let puzzleWidth = myPuzzleView.bounds.size.width
                let puzzleHeight = myPuzzleView.bounds.size.height
                
                // myPuzzleViewの位置をズラす
                myPuzzleView.frame.origin.x = self.view.bounds.width / 2 - (puzzleWidth / 2)
                myPuzzleView.frame.origin.y = (puzzleHeight * CGFloat(index)) + 20
                
                // tagの付与
                myPuzzleView.puzzleImageView.tag = (index + 1)
                myPuzzleView.playBtn.tag = (index + 1)
                myPuzzleView.deleteBtn.tag = (index + 1)
                
                // タップ可能に
                myPuzzleView.playBtn.addTarget(self, action: "onTapEventHandler:", forControlEvents: .TouchUpInside)
                myPuzzleView.deleteBtn.addTarget(self, action: "onTapEventHandler:", forControlEvents: .TouchUpInside)
                myPuzzleView.userInteractionEnabled = true
                
                scrollView.addSubview(myPuzzleView)
            }
            
        } else {
            
            // 画像データがnilの場合、代替テキストを表示
            noimageTxt.alpha = 1.0
            
        }
    }
    
    /**
     ボタンタップ時のイベントハンドラ
     
     - parameters:
        - sender
     
     - returns: none
     */
    func onTapEventHandler(sender: AnyObject) {
        
        let btnTitle: String? = sender.currentTitle
        
        guard let touchedPuzzleId = sender.tag else {
            return
        }
        if touchedPuzzleId == 0 {
            return
        }
        
        switch btnTitle! {
            case "Play":
                goGameView(touchedPuzzleId)
            case "Delete":
                deltePuzzle(touchedPuzzleId)
            default:
                break
        }
    }
    
    /**
     playボタン押下時のイベント
     
     - parameters:
     - none
     
     - returns: none
     */
    func goGameView(touchedPuzzleId: Int) {
        
        // 画像データのパスを取得
        let imageDataNames = Util.getImageDataNames()
        let dir = Util.getSubDirectory("image")
        let path = dir.URLByAppendingPathComponent(imageDataNames![touchedPuzzleId - 1]).path
        
        // 画像ファイル名をもとにしたpuzzleIDを通知
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.puzzleImageName = imageDataNames![touchedPuzzleId - 1]
        
        // 画像データからUIImageViewを生成し、delegateに通知
        let baseImage = UIImageView()
        baseImage.image = UIImage(contentsOfFile: path!)
        baseImage.frame = CGRectMake(0, 0, AppConst.boardWidth, AppConst.boardHeight)
        
        appDelegate.baseImage = baseImage
        
        // ゲーム画面に遷移
        self.performSegueWithIdentifier("goGameView", sender: self)
    }
    
    /**
    deleteボタン押下時のイベント
    
    - parameters:
        - touchedPuzzleId: タッチしたパズルのID
    
    - returns: none
    */
    func deltePuzzle(touchedPuzzleId: Int) {
        
        let fileManager = NSFileManager.defaultManager()
        
        // 画像データ名を取得
        let imageDataNames = Util.getImageDataNames()
        let imageDataName = imageDataNames![touchedPuzzleId - 1]

        // 画像のpathを取得
        let dir = Util.getSubDirectory("image")
        let path = dir.URLByAppendingPathComponent(imageDataName).path
        
        // pathが存在したら画像を削除
        if fileManager.fileExistsAtPath(path!) {
            do {
                try fileManager.removeItemAtPath(path!)
            }
            catch {
                print("Unable to delete file: \(error)")
            }
        }
        
        // ハイスコアを削除
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let _ = defaults.objectForKey(imageDataName) {
            defaults.removeObjectForKey(imageDataName)
        }
        
        let subviews = scrollView.subviews
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        initMypuzzleViews()
    }
    
}
