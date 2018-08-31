//
//  OrderListController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/18.
//  Copyright © 2017年 fut. All rights reserved.
//

import UIKit
import SwiftyJSON
import LCRefresh
/**
 订单页面(tabbar订单页面绑定类)
 */
class OrderListController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //定义order数组，用于显示
    var orderList :[Order] = []
    //定义展示数组
    var orderListShow :[Order] = []
    //首次加载
    var isFirstLoad = true
    
    
    @IBOutlet weak var tableView: UITableView!
    var activityIndicator : UIActivityIndicatorView!
 
    override func viewDidLoad() {
        //加载进度条
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.white)
        activityIndicator.color = UIColor.white
        activityIndicator.frame = CGRect.init(x:self.view.frame.width/2-25,y:self.view.frame.height/2-25,width:50.0,height:50.0)
        activityIndicator.center=self.view.center
        
        activityIndicator.backgroundColor = UIColor.gray
      self.view.addSubview(activityIndicator);
        //去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        //遵循协议
        tableView.delegate = self
        tableView.dataSource = self
        //tableview下划线左对齐
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        //去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.cellLayoutMarginsFollowReadableWidth = false
        play()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //下拉刷新
        self.tableView.refreshHeader = LCRefreshHeader.init(refreshBlock: {
            weak var weakSelf = self
             weakSelf!.tableView.resetDataLoad()
            //是否刷新完成
            if weakSelf!.tableView.isHeaderRefreshing() {
                if UserDefaults.standard.string(forKey: "personId") != nil{
                    self.orderList.removeAll()
                    self.orderListShow.removeAll()
                    self.getOrderList(customerid:UserDefaults.standard.string(forKey: "personId")!)
                    self.tableView.reloadData()
                    weakSelf!.tableView.endHeaderRefreshing()
                   
                }
            }
        })
        //加载更多
        self.tableView.refreshFooter = LCRefreshFooter.init(refreshBlock: {
            //定义当前展示数组长度
            var tmpHeight = self.orderListShow.count
            //总的数据长度
            var allHeight = self.orderList.count
            //是否刷新完成
            weak var weakSelf = self
            if weakSelf!.tableView.isFooterRefreshing() {
                
                if allHeight - tmpHeight > 5 {
                    for index in tmpHeight..<tmpHeight+5  {
                        if index >= tmpHeight+5{
                            break;
                        }
                        self.orderListShow.append(self.orderList[index])
                        
                    }
                }
                else if allHeight - tmpHeight <= 5 && allHeight - tmpHeight > 0{
                    for index in tmpHeight..<allHeight  {
                        self.orderListShow.append(self.orderList[index])
                    }
                }
                else{
                 weakSelf!.tableView.endFooterRefreshing()
                    weakSelf!.tableView.setDataLoadover()
                   self.tableView.reloadData()
                    
                    return
                }
                self.tableView.reloadData()
                weakSelf!.tableView.endFooterRefreshing()
                
                
            }
            
        })
        
        
    }
      override func viewDidAppear(_ animated: Bool) {
        if  UserDefaults.standard.string(forKey: "personId") == nil{
            //        检测登录状态
            
            let alert=UIAlertController(title: "提示",message: "请先登录。",preferredStyle: .alert )
            let okAction = UIAlertAction(title: "好", style: .default, handler: {
                action in
                self.stop()
                self.tabBarController?.selectedIndex = 3
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        //判断是否有订单
        if  UserDefaults.standard.string(forKey: "personId") ==  nil || UserDefaults.standard.string(forKey: "personId") as! String ==  ""{
            return
        }
        else{
            if isFirstLoad {
                self.orderList = getOrderList(customerid:UserDefaults.standard.string(forKey: "personId")! as String!)
                isFirstLoad = false
                tableView.reloadData()
            }
   
        }
        stop()
    }
    
   
 
    //显示多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return orderListShow.count
    }
    
    
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "orderListCell") as! UITableViewCell
        self.tableView.sectionHeaderHeight = 40
        self.tableView.sectionFooterHeight = 40
        self.tableView.rowHeight = 160
        //时间
        let label1 = cell.viewWithTag(1) as! UILabel
        label1.text = "   " + orderListShow[indexPath.row].in_time

        //停车场名称
        let label2 = cell.viewWithTag(2) as! UILabel
        label2.text = orderListShow[indexPath.row].place_name

        //具体时间
        let label4 = cell.viewWithTag(4) as! UILabel
        label4.text = orderListShow[indexPath.row].park_time

        //具体费用
//        let label6 = cell.viewWithTag(6) as! UILabel
//        label6.text = orderListShow[indexPath.row].real_park_fee

        //具体号码
        let label8 = cell.viewWithTag(8) as! UILabel
        label8.text = orderListShow[indexPath.row].place_number
        //订单状态
        let label9 = cell.viewWithTag(9) as! UILabel
        label9.text = orderListShow[indexPath.row].status
 
        return cell
    }
    
    
    
    
    //处理列表项的选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          self.tableView!.deselectRow(at: indexPath, animated: true)
       
        if orderList[indexPath.row].status == "已完成"{
                let todo = orderList[indexPath.row] as! Order
            self.performSegue(withIdentifier: "successIdentifier", sender: todo
                    )
        }
        else if orderList[indexPath.row].status == "正在计时"{
             let todo = orderList[indexPath.row] as! Order
            self.performSegue(withIdentifier: "currentIdentifier", sender: todo)
        }
        else if orderList[indexPath.row].status == "待支付" {
             let todo = orderList[indexPath.row] as! Order
            self.performSegue(withIdentifier: "waitPayIdentifier", sender: todo
            )
        }

    }
    
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "successIdentifier"{
            let controller = segue.destination as! CompletePayController
            var order = Order()
            order = sender as! Order
            controller.order = order
        }
        else if segue.identifier == "currentIdentifier"{
            let controller = segue.destination as! CurrentPayController
            var order = Order()
            order = sender as! Order
            controller.order = order
        }
        else if segue.identifier == "waitPayIdentifier"{
            let controller = segue.destination as! WaitPayController
            var order = Order()
            order = sender as! Order
            controller.order = order
        }
    }
    
    
 
    
    //获取远程接口数据
    func getOrderList(customerid:String) ->  Array<Order>  {
        do {
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/findParkRecord?customerid=%@",customerid)
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try JSON(data: jsonData)
                for (index,subJson):(String, JSON) in json {
                    let order = Order()
                    order.id = json[Int(index)!]["id"].stringValue
                    order.place_id = json[Int(index)!]["place_id"].stringValue
                    order.place_name = json[Int(index)!]["place_name"].stringValue
                    order.create_time = json[Int(index)!]["create_time"].stringValue
                    order.in_time = json[Int(index)!]["in_time"].stringValue
                    order.park_fee = json[Int(index)!]["park_fee"].stringValue
                    order.real_park_fee = json[Int(index)!]["real_park_fee"].stringValue
                    order.reservation_in_id = json[Int(index)!]["reservation_in_id"].stringValue
                    order.park_time = json[Int(index)!]["park_time"].stringValue
                    order.park_type = json[Int(index)!]["park_type"].stringValue
                    order.status = json[Int(index)!]["status"].stringValue
                    order.park_id = json[Int(index)!]["park_id"].stringValue
                     order.place_number = json[Int(index)!]["place_number"].stringValue
                    order.out_time = json[Int(index)!]["out_time"].stringValue
                    order.reservation_park_fee = json[Int(index)!]["reservation_park_fee"].stringValue
                    if Int(index)! < 5{
                        orderListShow.append(order)
                    }
                    orderList.append(order)
                }
            }
           
            return orderList
        }
        catch{
            return orderList
        }
        
    }
 
    func play(){
        //进度条开始转动
        activityIndicator.startAnimating()
        
        
    }
    
    func stop(){
        //进度条停止转动
        activityIndicator.stopAnimating()
    }
    
 
       
}
