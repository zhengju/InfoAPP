//
//  HeadFile.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/7.
//  Copyright © 2019 zsw. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


let KSCREEN_WIDTH = UIScreen.main.bounds.size.width
let KSCREEN_HEIGHT = UIScreen.main.bounds.size.height

func RGB_COLOR(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}
