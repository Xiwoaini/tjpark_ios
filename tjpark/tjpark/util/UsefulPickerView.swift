//
//  UsefulPickerView.swift
//  lockCall
//
//  Created by 潘宁 on 2017/10/24.
//  Copyright © 2017年 fut. All rights reserved.
//

import UIKit
//下拉菜单工具
open class UsefulPickerView: UIView {
    
    public typealias BtnAction = () -> Void
    public typealias SingleDoneAction = (_ selectedIndex: Int, _ selectedValue: String) -> Void
    public typealias MultipleDoneAction = (_ selectedIndexs: [Int], _ selectedValues: [String]) -> Void
    public typealias DateDoneAction = (_ selectedDate: Date) -> Void
    
    public typealias MultipleAssociatedDataType = [[[String: [String]?]]]
    
    fileprivate var pickerView: PickerView!
    //MARK:- 常量
    fileprivate let pickerViewHeight:CGFloat = 260.0
    
    fileprivate let screenWidth = UIScreen.main.bounds.size.width
    fileprivate let screenHeight = UIScreen.main.bounds.size.height
    fileprivate var hideFrame: CGRect {
        return CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: pickerViewHeight)
    }
    fileprivate var showFrame: CGRect {
        return CGRect(x: 0.0, y: screenHeight - pickerViewHeight, width: screenWidth, height: pickerViewHeight)
    }
    
    ///  使用NSArray 可以存任何"东西", 如果使用 [Any], 那么当
    /// let a = ["1", "2"] var b:[Any] = a 会报错
    
    // MARK:- 初始化
    // 单列
    convenience init(frame: CGRect, toolBarTitle: String, singleColData: [String], defaultSelectedIndex: Int?, doneAction: SingleDoneAction?) {
        
        self.init(frame: frame)
        pickerView = PickerView.singleColPicker(toolBarTitle, singleColData: singleColData, defaultIndex: defaultSelectedIndex, cancelAction: {[unowned self] in
            // 点击取消的时候移除
            self.hidePicker()
            
            }, doneAction: {[unowned self] (selectedIndex, selectedValue) in
                doneAction?(selectedIndex, selectedValue)
                self.hidePicker()
                
        })
        pickerView.frame = hideFrame
        addSubview(pickerView)
        
        // 点击背景移除self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
        
    }
    // 多列不关联
    convenience init(frame: CGRect, toolBarTitle: String, multipleColsData: [[String]], defaultSelectedIndexs: [Int]?, doneAction: MultipleDoneAction?) {
        
        self.init(frame: frame)
        
        pickerView = PickerView.multipleCosPicker(toolBarTitle, multipleColsData: multipleColsData, defaultSelectedIndexs: defaultSelectedIndexs, cancelAction: {[unowned self] in
            // 点击取消的时候移除
            self.hidePicker()
            
            }, doneAction: {[unowned self] (selectedIndexs, selectedValues) in
                doneAction?(selectedIndexs, selectedValues)
                self.hidePicker()
        })
        pickerView.frame = hideFrame
        addSubview(pickerView)
        
        // 点击背景移除self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
        
    }
    // 多列关联
    convenience init(frame: CGRect, toolBarTitle: String, multipleAssociatedColsData: MultipleAssociatedDataType, defaultSelectedValues: [String]?, doneAction: MultipleDoneAction?) {
        
        self.init(frame: frame)
        
        pickerView = PickerView.multipleAssociatedCosPicker(toolBarTitle, multipleAssociatedColsData: multipleAssociatedColsData, defaultSelectedValues: defaultSelectedValues, cancelAction: {[unowned self] in
            // 点击取消的时候移除
            self.hidePicker()
            
            }, doneAction: {[unowned self] (selectedIndexs, selectedValues) in
                doneAction?(selectedIndexs, selectedValues)
                self.hidePicker()
        })
        
        pickerView.frame = hideFrame
        addSubview(pickerView)
        
        // 点击背景移除self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
        
    }
    //  选择器
    convenience init(frame: CGRect, toolBarTitle: String, defaultSelectedValues: [String]?, doneAction: MultipleDoneAction?, selectTopLevel: Bool = false) {
        
        self.init(frame: frame)
        
        pickerView = PickerView.citiesPicker(toolBarTitle, defaultSelectedValues: defaultSelectedValues,  cancelAction: {[unowned self] in
            // 点击取消的时候移除
            self.hidePicker()
            
            }, doneAction: {[unowned self] (selectedIndexs, selectedValues) in
                doneAction?(selectedIndexs, selectedValues)
                self.hidePicker()
            }, selectTopLevel: selectTopLevel)
        
        pickerView.frame = hideFrame
        addSubview(pickerView)
        
        // 点击背景移除self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
        
    }
    // 日期选择器
    convenience init(frame: CGRect, toolBarTitle: String, datePickerSetting: DatePickerSetting, doneAction: DateDoneAction?) {
        
        self.init(frame: frame)
        
        pickerView = PickerView.datePicker(toolBarTitle, datePickerSetting: datePickerSetting, cancelAction:  {[unowned self] in
            // 点击取消的时候移除
            self.hidePicker()
            
            }, doneAction: {[unowned self] (selectedDate) in
                doneAction?(selectedDate)
                self.hidePicker()
        })
        
        pickerView.frame = hideFrame
        addSubview(pickerView)
        
        // 点击背景移除self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addOrentationObserver()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
}

// MARK:- selector
extension UsefulPickerView {
    
    fileprivate func addOrentationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusBarOrientationChange), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
        
    }
    // 屏幕旋转时移除pickerView
    @objc  func statusBarOrientationChange() {
        removeFromSuperview()
    }
    @objc  func tapAction(_ tap: UITapGestureRecognizer) {
        let location = tap.location(in: self)
        // 点击空白背景移除self
        if location.y <= screenHeight - pickerViewHeight {
            self.hidePicker()
        }
    }
}

// MARK:- 弹出和移除self
extension UsefulPickerView {
    
    fileprivate func showPicker() {
        // 通过window 弹出view
        let window = UIApplication.shared.keyWindow
        guard let currentWindow = window else { return }
        currentWindow.addSubview(self)
        
        
        
        UIView.animate(withDuration: 0.25, animations: {[unowned self] in
            self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
            self.pickerView.frame = self.showFrame
            }, completion: nil)
        
        
    }
    
    func hidePicker() {
        // 把self从window中移除
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.backgroundColor = UIColor.clear
            self.pickerView.frame = self.hideFrame
            
            }, completion: {[unowned self] (_) in
                self.removeFromSuperview()
        })
    }
}

// MARK: -  快速使用方法
extension UsefulPickerView {
    
    /// 单列选择器                                 ///  @author ZeroJ, 16-04-23 18:04:59
    ///
    ///  - parameter title:                      标题
    ///  - parameter data:                       数据
    ///  - parameter defaultSeletedIndex:        默认选中的行数
    ///  - parameter doneAction:                 响应完成的Closure
    ///
    ///  - returns:
    public class func showSingleColPicker(_ toolBarTitle: String, data: [String], defaultSelectedIndex: Int?,  doneAction: SingleDoneAction?) {
        let window = UIApplication.shared.keyWindow
        guard let currentWindow = window else { return }
        
        let testView = UsefulPickerView(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, singleColData: data,defaultSelectedIndex: defaultSelectedIndex ,doneAction: doneAction)
        
        testView.showPicker()
        
    }
    
    
    
}


