//
//  MyPuzzleViewController.swift
//  mySlidePuzzle
//
//  Created by 坂本 浩 on 2016/01/07.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import UIKit

class MyPuzzleViewController: UIViewController {
    
    @IBOutlet weak var noimageTxt: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    // 画面下の制約
    @IBOutlet weak var botomConstraint: NSLayoutConstraint!
    
    // pazzle
    var pazzle = UIImageView()
    var imagePath: String = ""
    
    // 画像データ格納用の配列
    var imageData: Array<String> = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // パズル画像をローカルストレージから読み込む
        if let imageData = loadImageData() {
            
            for (var i = 0; i < imageData.count; i++) {
                
                let rect = CGRectMake(0, AppConst.header_height, 300, 400)
                let myPuzzleView = MyPuzzleView(frame: rect)
                
                // TODO: 関数にする
                let dir = getPhotoDirectory()
                let path = dir.URLByAppendingPathComponent(imageData[i]).path
                print(path!)
                
                let pazzleImage = UIImage(contentsOfFile: path!)
                // TODO: 配列に画像データを格納する
                myPuzzleView.puzzleImageView.image = pazzleImage
                
                let width = myPuzzleView.bounds.size.width
                let height = myPuzzleView.bounds.size.height
                
                print(width)
                print(height)
                
                myPuzzleView.frame.origin.x = self.view.bounds.width / 2 - (width / 2)
                myPuzzleView.frame.origin.y = height * CGFloat(i)
                
                myPuzzleView.puzzleImageView.tag = (i + 1)
                myPuzzleView.playBtn.tag = (i + 1)
                
                // タップ可能に
                let tap = UITapGestureRecognizer(target: self, action: "onTapPlayBtn:")
                myPuzzleView.puzzleImageView.addGestureRecognizer(tap)
                
                myPuzzleView.playBtn.addTarget(self, action: "onTapPlayBtn:", forControlEvents: .TouchUpInside)
                myPuzzleView.userInteractionEnabled = true
                
                print(myPuzzleView.puzzleImageView.tag)
                print(myPuzzleView.playBtn.tag)
                
                botomConstraint.constant += height
                
                contentView.addSubview(myPuzzleView)
            }
            
        } else {
            
            noimageTxt.alpha = 1.0

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getPhotoDirectory() -> NSURL {
        
        let fileManager = NSFileManager.defaultManager()
        
        // NSURL型でルートディレクトリの取得
        let url = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        // photoディレクトリを参照
        let dirUrl = url.URLByAppendingPathComponent("photo")
        
        return dirUrl
    }
    

    func loadImageData() -> Array<String>? {
        
        let fileManager = NSFileManager.defaultManager()
        
        guard let dir = getPhotoDirectory().path else {
            return nil
        }
        
        do {
            let pngImages = try fileManager.contentsOfDirectoryAtPath(dir)
            print(pngImages)
            return pngImages
        }
        catch {
            return nil
        }
    }
    
    func onTapPlayBtn(sender: AnyObject) {
        
        guard let touchPuzzleId = sender.tag else {
            return
        }

        if touchPuzzleId == 0 {
            return
        }
        
        let imageData = loadImageData()
        let dir = getPhotoDirectory()
        let path = dir.URLByAppendingPathComponent(imageData![touchPuzzleId]).path
        
        let baseImage = UIImageView()
        baseImage.image = UIImage(contentsOfFile: path!)
        baseImage.frame = CGRectMake(0, 0, AppConst.boardWidth, AppConst.boardHeight)
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.baseImage = baseImage
        
        self.performSegueWithIdentifier("goGameView", sender: self)
    }
    
}
