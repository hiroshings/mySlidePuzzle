//
//  MyPuzzleView.swift
//  mySlidePuzzle
//
//  Created by 坂本 浩 on 2016/01/07.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import UIKit

class MyPuzzleView: UIView {
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var puzzleImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }
    
    func viewInit() {
        
        // xibからカスタムviewをロードする
        let nib = UINib(nibName: "myPuzzleView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        addSubview(view)
        
        
        // カスタムViewのサイズをあわせる
        view.translatesAutoresizingMaskIntoConstraints = false
        var bindings = [String: AnyObject]()
        bindings["view"] = view
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
    }

}
