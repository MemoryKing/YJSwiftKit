/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import Foundation
import UIKit

//MARK: ---------- 设置导航 ----------
public extension UIViewController {
    @available(iOS 12.0, *)
    ///设置暗黑模式(影响当前view/viewController/window 以及它下面的任何内容。)
    var yi_interfaceStyle: UIUserInterfaceStyle {
        set {
            objc_setAssociatedObject(self, QYRuntimeKey.interfaceStyleKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            if #available(iOS 13.0, *) {
                self.overrideUserInterfaceStyle = newValue
            } else {
                // Fallback on earlier versions
            }
        }
        get {
            return objc_getAssociatedObject(self, QYRuntimeKey.interfaceStyleKey!) as! UIUserInterfaceStyle
        }
    }
    @available(iOS 12.0, *)
    ///获取当前暗黑模式
    var yi_userInterfaceStyle: UIUserInterfaceStyle {
        get {
            if #available(iOS 13.0, *) {
                return UITraitCollection.current.userInterfaceStyle
            } else {
                // Fallback on earlier versions
            }
            return .unspecified
        }
    }
    
    ///影藏底线
    var yi_isHiddenShadow: Bool {
        set {
            objc_setAssociatedObject(self, QYRuntimeKey.hiddenShadowKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            if self.navigationController == nil {
                NSLog("no navigation controller", 1)
            } else {
                if newValue {
                    self.navigationController?.navigationBar.shadowImage = UIImage()
                } else {
                    self.navigationController?.navigationBar.shadowImage = nil
                }
            }
        }
        get {
            return (objc_getAssociatedObject(self, QYRuntimeKey.hiddenShadowKey!) as! Bool)
        }
    }
    ///隐藏导航
    var yi_isNavBarHidden: Bool {
        get {
            return navigationController?.isNavigationBarHidden ?? false
        }
        set {
            navigationController?.isNavigationBarHidden = newValue
        }
    }
    ///导航透明
    func yi_navClear() {
        if self.navigationController == nil {
            NSLog("no navigation controller", 1)
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    ///返回图片
    func yi_backImage (_ img: UIImage) {
        if self.navigationController == nil {
            NSLog("no navigation controller", 1)
        } else {
            if self.navigationController!.children.count > 1 {
                self.yi_navLeftImageItem(img) {[weak self] in
                    self?.yi_goBack()
                }
            }
        }
    }
    ///导航背景色
    func yi_navBackground (_ color:UIColor) {
        if self.navigationController == nil {
            NSLog("no navigation controller", 1)
        } else {
            self.navigationController?.navigationBar.barTintColor = color
            self.navigationController?.navigationBar.isTranslucent = false
        }
    }
    ///文本
    func yi_navTitle (_ title: String,
                      _ font: CGFloat? = nil,
                      _ color: UIColor? = nil) {
        if self.navigationController == nil {
            NSLog("no navigation controller", 1)
        } else {
            self.navigationItem.title = title
            let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: color ?? UIColor.black,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font ?? 18)]
            self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key: AnyObject]
        }
    }
    ///左文本按钮
    func yi_navLeftTitleItem (_ title: String,
                              _ color: UIColor? = nil,
                              _ navBlk: @escaping()->()) {
        let leftItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(navLeftItemClick))
        leftItem.tintColor = color ?? UIColor.black
        self.navigationItem.leftBarButtonItem = leftItem
        leftNavBlock = navBlk
    }
    
    ///左图片按钮
    func yi_navLeftImageItem (_ image: UIImage,
                              _ navBlk: @escaping()->()) {
        let leftItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(navLeftItemClick))
        self.navigationItem.leftBarButtonItem = leftItem
        leftNavBlock = navBlk
    }
    
    ///左图文
    func yi_navLeftTitleAndImageItem (_ title: String? ,
                                      _ color: UIColor? = nil,
                                      _ font: UIFont? = nil,
                                      _ image: UIImage? = nil,
                                      _ navBlk: @escaping()->()) {
        let item = self._customBarButtonItem(title, color ?? UIColor.black, font ?? UIFont.systemFont(ofSize: 17), image, #selector(navLeftItemClick))
        self.navigationItem.leftBarButtonItem = item
        leftNavBlock = navBlk
    }

    ///右文本按钮
    func yi_navRightTitleItem (_ title: String,
                               _ color: UIColor? = nil,
                               _ navBlk: @escaping()->()) {
        let rightItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(navRightItemClick))
        rightItem.tintColor = color ?? UIColor.black
        self.navigationItem.rightBarButtonItem = rightItem
        rightNavBlock = navBlk
    }
    
    ///右图片按钮
    func yi_navRightImageItem (_ image: UIImage,_ navBlk: @escaping()->()) {
        let rightItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(navRightItemClick))
        self.navigationItem.rightBarButtonItem = rightItem
        rightNavBlock = navBlk
    }
    
    ///右图文
    func yi_navRightTitleAndImageItem (_ title: String?,
                                       _ color: UIColor? = nil,
                                       _ font: UIFont? = nil,
                                       _ image: UIImage? = nil,_ navBlk: @escaping()->()) {
        let item = self._customBarButtonItem(title, color ?? UIColor.black, font ?? UIFont.systemFont(ofSize: 17), image, #selector(navRightItemClick))
        self.navigationItem.rightBarButtonItem = item
        rightNavBlock = navBlk
    }
}
//MARK: --- 功能
public extension UIViewController {
    ///背景图
    func yi_backgroundImage(_ named: String) {
        let image = UIImage(named: named)
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    ///背景图
    func yi_backgroundImage(_ image: UIImage) {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    ///将指定的视图控制器添加为当前视图控制器的子视图控制器
    func yi_addChildViewController(_ vc: UIViewController, toView: UIView) {
        self.addChild(vc)
        toView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
}

//MARK: --- 跳转
public extension UIViewController {
    ///跳转
    func yi_push(_ viewController: UIViewController,_ animated: Bool = true) {
        if self.navigationController == nil {
            NSLog("no navigation controller", 1)
        } else {
            if self.navigationController!.children.count > 0 {
                viewController.hidesBottomBarWhenPushed = true
            }
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    ///返回
    func yi_goBack (_ ani: Bool = true) {
        if self.navigationController == nil {
            NSLog("no navigation controller", 1)
        } else {
            if ((self.navigationController?.viewControllers.count)! > 1) {
                self.navigationController?.popViewController(animated: ani)
            }
            else if ((self.presentingViewController) != nil) {
                self.dismiss(animated: ani, completion: nil)
            }
        }
    }

    ///返回某视图
    func yi_goBackToVC (_ num: Int = 0,_ ani: Bool = true) {
        if self.navigationController == nil {
            NSLog("no navigation controller", 1)
        } else {
            guard let vc = self.navigationController?.viewControllers[num] else { return }
            self.navigationController?.popToViewController(vc, animated: ani)
        }
    }
    
    ///返回首页
    func yi_backToRootControlelr (_ ani: Bool = true) {
        if self.navigationController == nil {
            NSLog("no navigation controller", 1)
        } else {
            if ((self.navigationController?.viewControllers.count)! > 1) {
                self.navigationController?.popToRootViewController(animated: ani)
            }
            else if ((self.presentingViewController) != nil) {
                self.dismiss(animated: ani, completion: nil)
            }
        }
    }
}

//MARK: --- 私有
private extension UIViewController {
    private struct QYRuntimeKey {
        static let leftKey = UnsafeRawPointer.init(bitPattern: "leftKey".hashValue)
        static let rightKey = UnsafeRawPointer.init(bitPattern: "rightKey".hashValue)
        static let titleColorKey = UnsafeRawPointer.init(bitPattern: "titleColorKey".hashValue)
        static let hiddenShadowKey = UnsafeRawPointer.init(bitPattern: "hiddenShadowKey".hashValue)
        static let interfaceStyleKey = UnsafeRawPointer.init(bitPattern: "interfaceStyleKey".hashValue)
    }
    
    private var leftNavBlock: (() ->())? {
        set {
            objc_setAssociatedObject(self, QYRuntimeKey.leftKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  (objc_getAssociatedObject(self, QYRuntimeKey.leftKey!) as! (() ->()))
        }
    }
    
    private var rightNavBlock: (() ->())? {
        set {
            objc_setAssociatedObject(self, QYRuntimeKey.rightKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, QYRuntimeKey.rightKey!) as! (() ->()))
        }
    }
    
    @objc private func navLeftItemClick() {
        if let block = leftNavBlock {
            block()
        }
    }
    
    @objc private func navRightItemClick() {
        if let block = rightNavBlock {
            block()
        }
    }
    
    //自定义barItem
    private func _customBarButtonItem (_ title: String? ,
                                       _ color: UIColor? = nil,
                                       _ font: UIFont? = nil,
                                       _ image: UIImage? = nil,
                                       _ block: Selector) -> UIBarButtonItem {
        let button = UIButton().yi_then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(color ?? UIColor.black, for: .normal)
            $0.setBackgroundImage(image, for: .normal)
            $0.titleLabel?.font = font ?? UIFont.systemFont(ofSize: 17)
            $0.addTarget(self, action: block, for: .touchUpInside)
        }
        return UIBarButtonItem.init(customView: button)
    }
}
