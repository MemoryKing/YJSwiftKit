/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ 
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import UIKit

//MARK: --- 获取属性和方法
public extension NSObject {
    //MARK: --- 获取类的属性列表
    /// 获取类的属性列表
    func yi_get_class_copyPropertyList() -> [String] {
        var outCount:UInt32 = 0
        let propers:UnsafeMutablePointer<objc_property_t>! =  class_copyPropertyList(self.classForCoder, &outCount)
        let count:Int = Int(outCount);
        var names:[String] = [String]()
        for i in 0...(count-1) {
            let aPro: objc_property_t = propers[i]
            if let proName:String = String(utf8String: property_getName(aPro)){
                names.append(proName)
            }
        }
        return names
    }
    //MARK: --- 获取类的方法列表
    /// 获取类的方法列表
    func yi_get_class_copyMethodList() -> [String] {
        var outCount:UInt32
        outCount = 0
        let methods:UnsafeMutablePointer<objc_property_t>! =  class_copyMethodList(self.classForCoder, &outCount)
        let count:Int = Int(outCount);
        var names:[String] = [String]()
        for i in 0...(count-1) {
            let aMet: objc_property_t = methods[i]
            if let methodName:String = String(utf8String: property_getName(aMet)){
                names.append(methodName)
            }
        }
        return names
    }
    
    func yi_getTopViewController () -> UIViewController? {
        var root = UIApplication.shared.keyWindow?.rootViewController
        while let par = root?.presentingViewController {
            root = par
        }
        while ((root?.isKind(of: UINavigationController.self)) != nil) {
            let nav = root as! UINavigationController
            root = nav.topViewController
        }
        return root
    }
}
///比例大小
public func QYRatio(_ num: CGFloat) -> CGFloat {
    return num * QYProportion
}
///屏幕宽
public var QYScreenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}
///屏幕高
public var QYScreenHeight: CGFloat {
    return UIScreen.main.bounds.size.height
}
///屏幕比例
public var QYProportion: CGFloat {
    return UIScreen.main.bounds.size.width / 375.0
}
///导航高度
public var QYNavHeight: CGFloat {
    return 44.0
}
///tabbar栏高度
public var QYTabBarHeight: CGFloat {
    return 49.0
}
///底部安全区域
public var QYBottomHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.size.height > 20.1 ? 34.0: 0.0
}
///状态条占的高度
public var QYStatusHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.height
}
///导航栏高度 + 状态栏高度
public var QYStatusAndNavHeight: CGFloat {
    return QYStatusHeight + QYNavHeight
}
///tabbar高度 + iphoneX多出来的高度
public var QYBottomAndTabBarHeight: CGFloat {
    return QYBottomHeight + QYTabBarHeight
}
///大小
public func QYFont(_ font: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: font * QYProportion)
}
///加粗
public func QYBoldFont(_ font: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: font * QYProportion)
}
///斜体
public func QYItalicSystemFont(_ font: CGFloat) -> UIFont {
    return UIFont.italicSystemFont(ofSize: font)
}
