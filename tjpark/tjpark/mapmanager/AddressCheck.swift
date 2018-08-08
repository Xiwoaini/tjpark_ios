//
//  AddressCheck.swift
//  tjpark
//
//  Created by 潘宁 on 2018/4/27.
//  Copyright © 2018年 fut. All rights reserved.
//


import UIKit
import SwiftyJSON
class AddressCheck: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,BMKSuggestionSearchDelegate {
    
    var isShow = true
    
    @IBOutlet weak var addressSug: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    //数组的形式存储历史搜索的地址
       var addressList :[Address] = []
    var _searcher :  BMKSuggestionSearch?
    //模糊查询出来的数组
    var likeAddress:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //table协议
        tableView.delegate = self
        tableView.dataSource = self
      
        //去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        //search协议
         _searcher = BMKSuggestionSearch()
        _searcher?.delegate = self
        addressSug.delegate = self
        addressSug.becomeFirstResponder()
//           UserDefaults.standard.removeObject(forKey: "personId")
        if UserDefaults.standard.data(forKey: "address") != nil {
            
            let myModelData = UserDefaults.standard.data(forKey: "address")
            let myModel = NSKeyedUnarchiver.unarchiveObject(with: myModelData!)
            addressList = myModel.unsafelyUnwrapped as! [Address]
            
          
         
        }
  
    }
    
    //显示多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isShow{
            if addressList.count == 0 {
                return 0
            }
            return addressList.count+1
        }
        else{
             return likeAddress.count
        }
    }
 
     var label2 : UILabel!
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //显示历史记录
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "todoCell") as! UITableViewCell
      
        //历史记录
        if isShow{
            if indexPath.row == addressList.count{
                let label1 = cell.viewWithTag(1) as! UILabel
                label1.isHidden = true

                let imgView = cell.viewWithTag(3) as! UIImageView
                imgView.isHidden = true

                //删除历史记录
               
               label2 = UILabel(frame:CGRect(x: 0, y: 0, width: view.bounds.width,height: 50))
                label2.tag = 22
                label2.text = "清空历史记录"
                label2.textColor = UIColor.gray
                label2.font = UIFont.systemFont(ofSize: 13)
                label2.textAlignment = .center
                cell.addSubview(label2)
            }
            else{
            
                //位置名称
                let label1 = cell.viewWithTag(1) as! UILabel
                label1.text = addressList[indexPath.row].address_name
                //具体位置
                let label2 = cell.viewWithTag(2) as! UILabel
                label2.text = addressList[indexPath.row].address_datail
            }
        }
            //sug检索出来的地址
        else{
            label2?.isHidden = true
            let imgView = cell.viewWithTag(3) as! UIImageView
            imgView.isHidden = false
            //位置名称
            let label1 = cell.viewWithTag(1) as! UILabel
            label1.isHidden = false
            label1.text = likeAddress[indexPath.row]
        }
        return cell
    }
    
    /**
     此事件会异步返回查询到的地址信息
     */
    func onGetSuggestionResult(_ searcher: BMKSuggestionSearch!, result: BMKSuggestionResult!, errorCode: BMKSearchErrorCode) {
        //根据变量判断是否收起tableview
        
        if errorCode == BMK_SEARCH_NO_ERROR {
            likeAddress = []
            for i in 0..<result.cityList.count {
                let ad = (result.cityList[i] as! String)+(result.keyList[i] as! String)+(
                    result.districtList[i] as! String)
                likeAddress.append(ad)
                
            }
            tableView.dataSource = self
            self.tableView?.reloadData()
        } else if errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD {
            likeAddress = []
            
            self.tableView?.reloadData()
        } else {
            likeAddress = []
            
            self.tableView?.reloadData()
        }
    }
    
    //处理列表项的选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShow{
            //点击清除历史记录
            if indexPath.row == addressList.count {
                let alertController = UIAlertController(title: "提示信息",
                                                        message: "删除历史记录吗?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                    action in
                     UserDefaults.standard.removeObject(forKey: "address")
                    self.addressList.removeAll()
                    self.isShow = false
                     tableView.reloadData()
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
                //跳转
            else{
                conversionsAddress(address:addressList[indexPath.row].address_name)
             
            }
        }
        else{
            var address = Address()
            address.address_name = likeAddress[indexPath.row]
            addressList.append(address)
            let modelData = NSKeyedArchiver.archivedData(withRootObject: addressList)
            //存储Data对象
            UserDefaults.standard.set(modelData, forKey: "address");
            conversionsAddress(address:address.address_name)
           
        }
   
    }

    /**
     搜索控件内容改变的时候会触发此事件
     */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isShow = false
       
        //地址关键字搜索对象
        var  so = BMKSuggestionSearchOption()
        //缩小城市级别，主要搜索天津
        so.cityname = "天津"
        tableView?.isScrollEnabled = false
        if searchBar.text == "" {
            searchBar.resignFirstResponder()
        }

        likeAddress = []
        //将用户输入的赋给sug对象的地址关键字属性
        so.keyword = searchBar.text!
        if _searcher?.suggestionSearch(so) == true {
            
        }
        else{
            
        }
        
    }
    
  
    
    @IBAction func closeBtn(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
    }
   
    //地址转坐标
    func conversionsAddress(address:String){
        let strUrl =  String(format:"http://api.map.baidu.com/geocoder/v2/?address=%@&output=json&ak=%@&mcode=com.tjsinfo.lock",address.urlEncoded(),"PiQVscwPkLwRN1V6ZDa0kzUKbi9FG2Q9")
        do{
            let url = URL(string: strUrl);
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                //将接口返回的string转成object
                let json = JSON(jsonData as Any)
                //成功返回经纬度的情况
                let tmp = json["status"].int
                if tmp == 0 {
                    MapController.currentLon = json["result"]["location"]["lng"].double!
                    MapController.currentLat = json["result"]["location"]["lat"].double!
                  
                    TestController.isFirst = true
                    TabBarController.selectValue = 1
                    self.performSegue(withIdentifier: "resultAddressIdentifier", sender: self)
                 
                }
                    //地址没有找到情况
                else if tmp == 1 {
                    let alert=UIAlertController(title: "消息",message: "输入的地址没有找到！",preferredStyle: .alert )
                    let ok = UIAlertAction(title: "OK",style: .cancel,handler: nil )
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                    //其他错误
                else{
                    let alert=UIAlertController(title: "消息",message: "地图加载失败，请重试！",preferredStyle: .alert )
                    let ok = UIAlertAction(title: "OK",style: .cancel,handler: nil )
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
            }
        }
        catch{
            
        }
    }
 
  
  
    
}

