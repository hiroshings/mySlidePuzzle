//
//  GameViewController.swift
//  mySlidePuzzle
//
//  Created by hiroshings on 2016/01/02.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var baseImage = UIImageView()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        baseImage = appDelegate.baseImage


        self.navigationItem.title = "My Slide Puzzle"
        
        /**
        - パズルの初期化
        */
        let maskedImage = maskImage()
        let pieceImage = UIImageView(frame: CGRectMake(0, 0, AppConst.pieceSize, AppConst.pieceSize))
        pieceImage.image = maskedImage
        self.view.addSubview(pieceImage)
    }
    
    
    /*-----------------------
    // MARK: - private -
    ----------------------*/
    
    /**
    画像のマスク処理
    - Returns: マスクした画像
    */
    func maskImage() -> UIImage {
        let mask:CGRect = CGRectMake(0, 0, AppConst.pieceSize, AppConst.pieceSize)
        let maskImageRef = CGImageCreateWithImageInRect(baseImage.image?.CGImage, mask)
        let maskImage = UIImage(CGImage: maskImageRef!)
//        let pieceImage = UIImageView(frame: CGRectMake(0, 0, AppConst.pieceSize, AppConst.pieceSize))
//        pieceImage.image = maskImage
        
        return maskImage
    }

}