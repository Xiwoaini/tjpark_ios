//
//  ChargeParkDetail.swift
//  tjpark
//
//  Created by 潘宁 on 2018/6/27.
//  Copyright © 2018年 fut. All rights reserved.
//


import UIKit
import SwiftyJSON

class ChargeParkDetail: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var PileDetailArray : [PileDetail] = []
    var parkPileId : String?
    var placeName : String?
    
         var parkDetail = ParkDetail()
     var chargePark = ChargePark()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getParkDetail()
        tableView.delegate = self
        tableView.dataSource = self
        let placeName = self.view.viewWithTag(66) as! UILabel
        placeName.text = chargePark.place_name
        
    }
    //显示多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return PileDetailArray.count
    }
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
         let cell = self.tableView.dequeueReusableCell(withIdentifier: "todoCell") as! UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
             self.tableView.rowHeight = 250
            //充电桩号
            let label1 = cell.viewWithTag(1) as! UILabel
 
        label1.text = String(PileDetailArray[indexPath.row].number.suffix(3))
        
         //序列号
                let label2 = cell.viewWithTag(2) as! UILabel
                label2.text = PileDetailArray[indexPath.row].number
        
        //工作状态
        let label3 = cell.viewWithTag(3) as! UILabel
       
        //离网
            if PileDetailArray[indexPath.row].status.elementsEqual("0"){
                   label3.text = "离网"
            }
                   //空闲
        else if PileDetailArray[indexPath.row].status.elementsEqual("1"){
              label3.text = "空闲"
        }
                     //占用(未充电)
            else if PileDetailArray[indexPath.row].status.elementsEqual("2"){
                    label3.text = "占用"
        }
                     //占用(充电中)
            else if PileDetailArray[indexPath.row].status.elementsEqual("3"){
                   label3.text = "占用"
        }
                     //占用(预约锁定)
            else if PileDetailArray[indexPath.row].status.elementsEqual("4"){
                    label3.text = "占用"
        }
                     //故障
            else if PileDetailArray[indexPath.row].status.elementsEqual("255"){
                 label3.text = "故障"
        }
        return cell
    }
 
    
    @IBAction func closeBtn(_ sender: Any) {
         self.dismiss(animated:true, completion:nil)  
    }
    
    //得到具体车位信息
        func getParkDetail(){
            var strUrl2 =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/findPileParkByPileId?parkPileId=%@",parkPileId!)
    
            do {
                let url2 = URL(string: strUrl2)
                let str2 = try NSString(contentsOf: url2!, encoding: String.Encoding.utf8.rawValue)
                if let jsonData2 = str2.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                    let json = try JSON(data: jsonData2)
                    for (index,subJson):(String, JSON) in json {
                        var pileDetail = PileDetail()
                      pileDetail.number = json[Int(index)!]["number"].stringValue
                        pileDetail.status = json[Int(index)!]["status"].stringValue
                        PileDetailArray.append(pileDetail)
                    }
                }
            }
            catch{
                print("error")
            }
    
        }
    
    
    
}
