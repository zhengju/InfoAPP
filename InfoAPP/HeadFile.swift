//
//  HeadFile.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/7.
//  Copyright © 2019 zsw. All rights reserved.
//

import UIKit

let KSCREEN_WIDTH = UIScreen.main.bounds.size.width
let KSCREEN_HEIGHT = UIScreen.main.bounds.size.height

func x(object:UIView) -> CGFloat {
    return object.frame.origin.x;
}
func y(object:UIView) -> CGFloat {
    return object.frame.origin.y;
}
func w(object:UIView) -> CGFloat {
    return object.frame.size.width;
}
func h(object:UIView) -> CGFloat {
    return object.frame.size.height;
}

func RGB_COLOR(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    
}
