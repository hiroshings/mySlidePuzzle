//
//  Puzzle.swift
//  mySlidePuzzle
//
//  Created by 坂本 浩 on 2016/01/15.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import Foundation
import UIKit

// パズルデータを一元管理
struct Puzzle {
    
    var image = UIImageView()
    var bgImage = UIImageView()
    var highScore: Float = 0.0
    
    init(image: UIImageView, bgImage: UIImageView, highScore: Float) {
        self.image = image
        self.bgImage = bgImage
        self.highScore = highScore
    }
}