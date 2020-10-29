/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import UIKit
import SnapKit

open class QYBaseViewController: UIViewController {
    //MARK: --- 状态栏
    private var _barStyle: UIStatusBarStyle?
    ///状态栏
    public var yi_barStyle: UIStatusBarStyle {
        set {
            _barStyle = newValue
            setNeedsStatusBarAppearanceUpdate()
        }
        get {
            return _barStyle ?? UIStatusBarStyle.default
        }
    }
    
    //MARK: --- 返回手势
    private var _openPopGecognizer: Bool?
    ///返回手势
    public var yi_openPopGecognizer: Bool {
        set {
            _openPopGecognizer = newValue
            self.navigationController?.yi_openPopGecognizer = newValue
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = newValue
        }
        get {
            return _openPopGecognizer ?? false
        }
    }
    ///区头区尾悬停
    public var isHover: Bool?
    public var mainTableView: QYBaseTableView?
    public var mainCollection: QYBaseCollectionView?
    //MARK: --- viewDidLoad
    open override func viewDidLoad() {
        super.viewDidLoad()

        //防止自动下移64
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.yi_openPopGecognizer = true
        
        self.view.backgroundColor = QYF5Color
        yi_InterfaceLayout()
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    ///界面布局
    open func yi_InterfaceLayout() {
        
    }
    
    //MARK: --- 添加表视图
    ///添加表视图
    public func yi_addTableView(_ style: UITableView.Style? = nil, _ block: ((QYBaseTableView) -> Void)? = nil) {
        if self.mainCollection != nil {
            self.mainCollection?.removeFromSuperview()
            self.mainCollection = nil
        }
        
        self.mainTableView = QYBaseTableView(frame: .zero, style: style ?? .plain)
        self.mainTableView!.showsVerticalScrollIndicator = false
        self.mainTableView!.showsHorizontalScrollIndicator = false
        self.mainTableView!.backgroundColor = QYF5Color
        self.mainTableView!.separatorStyle = .none
        self.mainTableView!.estimatedRowHeight = 44
        self.mainTableView!.estimatedSectionFooterHeight = 0
        self.mainTableView!.estimatedSectionHeaderHeight = 0
        self.view.addSubview(self.mainTableView!)
        var top: CGFloat
        var bottom: CGFloat
        if (self.navigationController != nil) {
            top = QYStatusAndNavHeight
        } else {
            top = QYStatusHeight
        }
        if self.tabBarController != nil {
            bottom = QYBottomAndTabBarHeight
        } else {
            bottom = QYBottomHeight
        }
        self.mainTableView!.snp.makeConstraints {
            $0.top.equalTo(top)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(-bottom)
        }
        block?(self.mainTableView!)
    }
    
    //MARK:-注册表视图cell
    ///注册表视图cell
    public func yi_registerCell(cells:[AnyClass],cellName:[String]) {
        for index in 0..<cells.count {
            self.mainTableView?.register(cells[index], forCellReuseIdentifier: cellName[index])
        }
    }
    ///注册表视图cell
    public func yi_registerCell(cell:AnyClass,cellName:String) {
        self.mainTableView?.register(cell, forCellReuseIdentifier: cellName)
    }
    ///注册表视图nib cell
    public func yi_registerCell(cellNib:String,cellNameNib:String) {
        self.mainTableView?.register(UINib.init(nibName: cellNib, bundle: nil), forCellReuseIdentifier: cellNameNib)
    }
    ///注册表视图nib cell
    public func yi_registerCell(cellNibs:[String],cellNibName:[String]) {
        for index in 0 ..< cellNibs.count {
            self.mainTableView?.register(UINib.init(nibName: cellNibs[index], bundle: nil), forCellReuseIdentifier: cellNibName[index])
        }
    }
    
    
    //MARK: --- 添加集合视图
    ///添加集合视图
    public func yi_addCollectionView(_ block: ((UICollectionViewFlowLayout,QYBaseCollectionView) -> Void)? = nil) {
        if self.mainTableView != nil {
            self.mainTableView?.removeFromSuperview()
            self.mainTableView = nil
        }
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize.init(width: 100, height: 100)
        self.mainCollection = QYBaseCollectionView.init(frame: .init(), collectionViewLayout: layout)
        self.mainCollection!.showsVerticalScrollIndicator = false
        self.mainCollection!.showsHorizontalScrollIndicator = false
        self.mainCollection!.backgroundColor = QYF5Color
        self.view.addSubview(self.mainCollection!)
        self.mainCollection!.snp.makeConstraints {
            $0.top.equalTo(QYStatusAndNavHeight)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(-QYBottomHeight)
        }
        block?(layout,self.mainCollection!)
    }
    
    //MARK:-注册集合视图cell
    ///注册集合视图cell
    public func yi_registerCollectionCell(cell:AnyClass,cellName:String) {
        self.mainCollection?.register(cell, forCellWithReuseIdentifier: cellName)
    }
    ///注册集合视图cell
    public func yi_registerCollectionCell(cells:[AnyClass],cellName:[String]) {
        for index in 0..<cells.count {
            self.mainCollection?.register(cells[index], forCellWithReuseIdentifier: cellName[index])
        }
    }
    ///注册集合视图nib cell
    public func yi_registerCollectionCell(cellNib:String,cellNameNib:String) {
        self.mainCollection?.register(UINib.init(nibName: cellNib, bundle: nil), forCellWithReuseIdentifier: cellNameNib)
    }
    ///注册集合视图nib cell
    public func yi_registerCollectionCell(cellNibs:[String],cellNibName:[String]) {
        for index in 0 ..< cellNibs.count {
            self.mainCollection?.register(UINib.init(nibName: cellNibs[index], bundle: nil), forCellWithReuseIdentifier: cellNibName[index])
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.yi_barStyle
    }
}

extension QYBaseViewController : UIScrollViewDelegate {
    //MARK: --- header、footer均不悬停
    //header、footer均不悬停
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isHover ?? false {
            //组头高度
            let sectionHeaderHeight:CGFloat = 30
            //组尾高度
            let sectionFooterHeight:CGFloat = 30
             
            //获取是否有默认调整的内边距
            let defaultEdgeTop:CGFloat = navigationController?.navigationBar != nil
                && self.automaticallyAdjustsScrollViewInsets ? 64 : 0
             
            //上边距相关
            var edgeTop = defaultEdgeTop
            if scrollView.contentOffset.y >= -defaultEdgeTop &&
                scrollView.contentOffset.y <= sectionHeaderHeight - defaultEdgeTop  {
                edgeTop = -scrollView.contentOffset.y
            }
            else if (scrollView.contentOffset.y>=sectionHeaderHeight - defaultEdgeTop) {
                edgeTop = -sectionHeaderHeight + defaultEdgeTop
            }
             
            //下边距相关
            var edgeBottom:CGFloat = 0
            let b = scrollView.contentOffset.y + scrollView.frame.height
            let h = scrollView.contentSize.height - sectionFooterHeight
             
            if b <= h {
                edgeBottom = -30
            }else if b > h && b < scrollView.contentSize.height {
                edgeBottom = b - h - 30
            }
             
            //设置内边距
            scrollView.contentInset = UIEdgeInsets(top: edgeTop, left: 0, bottom: edgeBottom, right: 0)
        }
    }
}