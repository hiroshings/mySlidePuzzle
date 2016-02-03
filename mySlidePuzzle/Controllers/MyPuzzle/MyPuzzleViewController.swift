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
    var myPuzzleView = MyPuzzleView()
    var pazzle = UIImageView()
    var imagePath: String = "" //画像のパス
    
    // TODO:ほぼ全画面で使うclassはどこかでまとめてインスタンス化する
    let util = Util()
    let const = AppConst()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Puzzles"
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let screenWidth = const.screenSize.width
        let myPuzzleViewHeight = const.myPuzzleViewHeight
        
        // マイパズル生成
        if let imageDataNames = util.getImageDataNames() {
            
            scrollView.contentSize = CGSizeMake(screenWidth, myPuzzleViewHeight * CGFloat(imageDataNames.count))
            
            for (index, imageDataName) in imageDataNames.enumerate() {
                
                print(imageDataName)
                // myPuzzleインスタンスを生成
                let rect = CGRectMake(0, 0, 300, 400)
                myPuzzleView = MyPuzzleView(frame: rect)
                
                // myPuzzleの画像パスを取得
                let dir = util.getSubDirectory("image")
                let path = dir.URLByAppendingPathComponent(imageDataName).path
                
                // ハイスコアを表示
                let defaults = NSUserDefaults.standardUserDefaults()
                if let highScoreData = defaults.objectForKey(imageDataName) {
                    
                    let highScore = highScoreData as! Int
                    
                    let ms = highScore % 100
                    let s = (highScore - ms) / 100 % 60
                    let m = (highScore - s - ms) / 6000 % 3600
                    
                    myPuzzleView.highScore.text = String(format: "%02d:%02d:%02d", arguments: [m, s, ms])
                    
                    print("score" + String(format: "%02d:%02d:%02d", arguments: [m, s, ms]))
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
                
                // タップ可能に
                let tap = UITapGestureRecognizer(target: self, action: "onTapPlayBtn:")
                myPuzzleView.puzzleImageView.addGestureRecognizer(tap)
                
                myPuzzleView.playBtn.addTarget(self, action: "onTapPlayBtn:", forControlEvents: .TouchUpInside)
                myPuzzleView.userInteractionEnabled = true
                
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
        let imageData = util.getImageDataNames()
        let dir = util.getSubDirectory("image")
        let path = dir.URLByAppendingPathComponent(imageData![touchPuzzleId - 1]).path
        
        // 画像ファイル名をもとにしたpuzzleIDを通知
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.puzzleImageName = imageData![touchPuzzleId - 1]
        
        // 画像データからUIImageViewを生成し、delegateに通知
        let baseImage = UIImageView()
        baseImage.image = UIImage(contentsOfFile: path!)
        baseImage.frame = CGRectMake(0, 0, const.boardWidth, const.boardHeight)
        
        appDelegate.baseImage = baseImage
        
        // ゲーム画面に遷移
        self.performSegueWithIdentifier("goGameView", sender: self)
    }
    
}
