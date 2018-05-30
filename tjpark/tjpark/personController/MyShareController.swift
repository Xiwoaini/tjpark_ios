//
//  MyShareController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/30.
//  Copyright © 2017年 fut. All rights reserved.
//



import UIKit
import SwiftyJSON
 //查询个人信息里的共享车位信息
class MyShareController: UIViewController,UITableViewDataSource,UITableViewDelegate {
     var shareList :[MyShare] = []
    var activityIndicator : UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.gray)
        activityIndicator.center=self.view.center
        self.view.addSubview(activityIndicator);
        play()
        
       tableView.delegate = self
        tableView.dataSource = self
        //去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        
    }
    
    //显示多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       
        return shareList.count
    }
    
    
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myShareCell") as! UITableViewCell
         self.tableView.rowHeight = 200
        var myShare = shareList[indexPath.row]
        //当前是审核状态
        if myShare.status.elementsEqual("审核中"){
            //       发布时间
            let label1 = cell.viewWithTag(1) as! UILabel
            label1.text = "发布时间: " + myShare.create_time
            label1.backgroundColor =  UIColor(red: 230/255, green: 236/255, blue: 232/255, alpha: 100)
            //       停车场名称
            let label2 = cell.viewWithTag(2) as! UILabel
            label2.text = myShare.place_name
            //      车位号
            let label3 = cell.viewWithTag(6) as! UILabel
            label3.text = myShare.park_num
            //       开放时间
            let label4 = cell.viewWithTag(7) as! UILabel
            label4.text = myShare.start_time + "-" +  myShare.end_time
            //       费用
            let label5 = cell.viewWithTag(8) as! UILabel
            label5.text = myShare.park_fee + "元/小时"
            //       模式
            let label101 = cell.viewWithTag(101) as! UILabel
            label101.text = myShare.model
            //     状态
            let label6 = cell.viewWithTag(9) as! UILabel
            label6.text = myShare.status
            //   按钮状态
            let btn = cell.viewWithTag(10) as! UIButton
            btn.setTitle("取消", for: .normal)
            
        }
        else{
            //       发布时间
            let label1 = cell.viewWithTag(1) as! UILabel
            label1.text = "发布时间: " + myShare.create_time
            label1.backgroundColor =  UIColor(red: 230/255, green: 236/255, blue: 232/255, alpha: 100)
            //       停车场名称
            let label2 = cell.viewWithTag(2) as! UILabel
            label2.text = myShare.place_name
            //      车位号
            let label3 = cell.viewWithTag(6) as! UILabel
            label3.text = myShare.park_num
            //       开放时间
            let label4 = cell.viewWithTag(7) as! UILabel
            label4.text = myShare.start_time + "-" +  myShare.end_time
            //       费用
            let label5 = cell.viewWithTag(8) as! UILabel
            label5.text = myShare.park_fee + "元/小时"
            //       模式
            let label101 = cell.viewWithTag(101) as! UILabel
            label101.text = myShare.model
                //     状态
                let label6 = cell.viewWithTag(9) as! UILabel
                label6.text = myShare.share_status
          
                //   按钮状态
                let btn = cell.viewWithTag(10) as! UIButton
                btn.setTitle(myShare.buttonName, for: .normal)
 
           
 
        }
            return cell
    }
    //编辑按钮
    @IBAction func tiaoZhuanClick(_ sender: Any) {
        let btn = sender as! UIButton
        let cell = btn.superView(of: UITableViewCell.self)!
      
        let indexPath = tableView.indexPath(for: cell)
 
        
        self.performSegue(withIdentifier: "editShare", sender: shareList[(indexPath?.row)!])
 
    }
 
    //收入明细
    @IBAction func mingXiClick(_ sender: Any) {
        let btn = sender as! UIButton
        let cell = btn.superView(of: UITableViewCell.self)!
        
        let indexPath = tableView.indexPath(for: cell)
            self.performSegue(withIdentifier: "moneyDetail", sender: shareList[(indexPath?.row)!].id)
    }
 
 
    
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "moneyDetail" {
            let controller = segue.destination as! MyMoneyController
            controller.id = sender as! String
        }
        else if segue.identifier == "editShare"{
            let controller = segue.destination as! UpdateShareController
            controller.myShare = sender as! MyShare
        }
    }
    
    
    
    
    
//     开启或关闭按钮
    @IBAction func statusBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "系统提示",
                                                message: "您确定要执行此操作吗?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "否", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "是", style: .default, handler: {
            action in

            let btn = sender as! UIButton
            let cell = btn.superView(of: UITableViewCell.self)!
            
            let indexPath = self.tableView.indexPath(for: cell)
            
            //调用远程接口，修改共享信息
            self.updateMyShare(id: self.shareList[(indexPath?.row)!].id, customerid: self.shareList[(indexPath?.row)!].customer_id, status: self.shareList[(indexPath?.row)!].status,buttonName:self.shareList[(indexPath?.row)!].buttonName)
            self.shareList.removeAll()
            self.getMyShare(customerid:UserDefaults.standard.string(forKey: "personId")!)
            
            self.tableView.reloadData()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        return
    
    }
    
 
    //设置点击某行cell不变色
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        self.tableView!.deselectRow(at: indexPath, animated: true)
    }
 
    

//    调用接口查询
    func getMyShare(customerid:String){
        do {
      
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/findMySharePark?customerid=%@",customerid)
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try JSON(data: jsonData)
        
                for (index,subJson):(String, JSON) in json {
                    var  myShare = MyShare()
                    myShare.id = json[Int(index)!]["id"].stringValue
                    myShare.place_id = json[Int(index)!]["place_id"].stringValue
                    myShare.place_name = json[Int(index)!]["place_name"].stringValue
                    myShare.customer_id = json[Int(index)!]["customer_id"].stringValue
                    myShare.park_num = json[Int(index)!]["park_num"].stringValue
                    myShare.phone = json[Int(index)!]["phone"].stringValue
                    myShare.create_time = json[Int(index)!]["create_time"].stringValue
                    myShare.park_fee = json[Int(index)!]["park_fee"].stringValue
                    myShare.start_time = json[Int(index)!]["start_time"].stringValue
                    myShare.end_time = json[Int(index)!]["end_time"].stringValue
                    myShare.status = json[Int(index)!]["status"].stringValue
                    myShare.share_status = json[Int(index)!]["share_status"].stringValue
                    myShare.contacts_name = json[Int(index)!]["contacts_name"].stringValue
                    myShare.buttonName = json[Int(index)!]["buttonName"].stringValue
                    myShare.model=json[Int(index)!]["model"].stringValue
                   shareList.append(myShare)
                }
            }
            
        }
        catch{
            
        }
         stop()
        
    }
    
    func updateMyShare(id:String,customerid:String,status:String,buttonName:String)->Bool{
         do {
            var strUrl = ""
        if status == "审核中"{
           strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/updateShareStatus?id=%@&customerid=%@&status=%@",id,customerid,"取消")
        }
        else{
          strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/updateShareStatus?id=%@&customerid=%@&status=%@",id,customerid,buttonName)
        }
  
            let url = URL(string: strUrl.urlEncoded())
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
                    return true
        }
        catch{
            return false
        }
     
        
    }
    
    @IBAction func close(_ sender: UIButton) {
 
           self.dismiss(animated:true, completion:nil)
 
    }
    
    func play(){
        //进度条开始转动
        activityIndicator.startAnimating()
        getMyShare(customerid:UserDefaults.standard.string(forKey: "personId")!)
     
    }
    
    func stop(){
        //进度条停止转动
        activityIndicator.stopAnimating()
    }
}

extension UIView {
    //返回该view所在的父view
    func superView<T: UIView>(of: T.Type) -> T? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
}

