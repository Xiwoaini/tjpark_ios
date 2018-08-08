//
//  MyCarController.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/27.
//  Copyright © 2017年 fut. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
//我的车辆页面展示
class MyCarController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
     var carList :[Car] = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        //去除最后一行, 底部分割线左对齐
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
       
        //获取数据,登录的情况下
        if UserDefaults.standard.string(forKey: "personId") == nil   {
               return
        }
        else {
            getCarList(customerid:UserDefaults.standard.string(forKey: "personId")!)
         
        }
       
        
        
        
    }
    
    //显示多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return carList.count
    }
    
    
    //重写显示方法，如果下拉列表发生了变化，会再次调用此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "carCell") as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.none
        self.tableView.rowHeight = 120
     
        //获取label
        let label = cell.viewWithTag(1) as! UILabel
        label.text = carList[indexPath.row].place_number
        
        //获取button状态
        let button = cell.viewWithTag(88) as! UIButton
        if carList[indexPath.row].status.elementsEqual("完成认证"){
            button.isEnabled = false
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.blue, for: .normal)
            button.setTitle(carList[indexPath.row].status, for: .normal)
        }
        else{
          button.setTitle("立即认证", for: .normal)
          button.isEnabled = true
        }

        return cell
    }
    
    
    
    //处理列表项的选中事件,编辑车牌
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                self.tableView!.deselectRow(at: indexPath, animated: true)
      var car = Car()
        car = carList[indexPath.row] as! Car
        self.performSegue(withIdentifier: "updateIdentifier", sender: car
        )

    }
    
   //添加车牌
    @IBAction func addPlate(_ sender: UIButton) {
         var car = Car()
        self.performSegue(withIdentifier: "updateIdentifier", sender: car
        )
        
    }
    
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateIdentifier"{
            let controller = segue.destination as! CarEditController
            var car = Car()
            car = sender as! Car
            controller.car = car
        }
        
    }
    

    func getCarList(customerid:String) -> Array<Car>{
        do {
            var strUrl =  String(format:TabBarController.windowIp + "/tjpark/app/AppWebservice/findPlate?customerid=%@",customerid)
            let url = URL(string: strUrl)
            let str = try NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = str.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let json = try JSON(data: jsonData)
               
                for (index,subJson):(String, JSON) in json {
                     let car = Car()
                    car.id = json[Int(index)!]["id"].stringValue
                    car.place_number = json[Int(index)!]["place_number"].stringValue
                    car.created_time = json[Int(index)!]["created_time"].stringValue
                    car.customer_id = json[Int(index)!]["customer_id"].stringValue
                    car.park_id = json[Int(index)!]["park_id"].stringValue
                    carList.append(car)
                }
            }
           return carList
        }
        catch{
              return carList
        }
 
   
        
    }
    
    //总是返回到tabbar个人信息页面
    @IBAction func close(_ sender: UIButton) {
        TestController.isFirst = true
        TabBarController.selectValue = 3
        self.performSegue(withIdentifier: "exitPersonIdentifier", sender: self)
        
    }
    
    
    //调用相机或相册
    @IBAction func renZhengBtn(_ sender: UIButton) {
        //创建菜单
        var optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //创建相机
        let cameraAction = UIAlertAction(title: "相机", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.initCameraPicker()
           
        })
        optionMenu.addAction(cameraAction)
        //创建相机
        let photoAction = UIAlertAction(title: "从相册中选择照片", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.initPhotoPicker()
        })
        optionMenu.addAction(photoAction)
        //取消
        let cancelAction = UIAlertAction(title: "取消认证", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(cancelAction)
         self.present(optionMenu, animated: true, completion: nil)
    }
    
 
    //打开相册
    func initPhotoPicker(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    
     //打开相机
    func initCameraPicker(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            //在需要的地方present出来
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            let alert=UIAlertController(title: "提示",message: "当前设备不支持拍照。",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
   
    //保存图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //获得照片
        let image:UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // 如果是拍照
//        if picker.sourceType == .camera {
//            //保存相册
//            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
//        }
        
        //将图片上传到服务器
        //转成jpg格式图片
//        guard let jpegData = UIImageJPEGRepresentation(image, 0.5) else {
//            return
//        }
        
        // 将图片转化成Data
        let imageData = UIImagePNGRepresentation(image)
     
        // 将Data转化成 base64的字符串
        var imageBase64String =  imageData?.base64EncodedString(options: .endLineWithLineFeed)
        //上传到服务器
        uploadImage(imageData: imageBase64String!)
 
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        
        if error != nil {
            
            print("保存失败")
        } else {
            print("保存成功")
            
            
        }
    }
    //图片上传服务器
    //上传图片到服务器
    func uploadImage(imageData : String){
  
        if UserDefaults.standard.string(forKey: "personId") == nil{
            let alert=UIAlertController(title: "提示",message: "请先登录。",preferredStyle: .alert )
            let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        var personId = UserDefaults.standard.string(forKey: "personId")
        Alamofire.request(TabBarController.windowIp + "/tjpark/app/UploadWebService/imgVerification", method: .post, parameters: ["imgStr": imageData,"customerId":personId]).responseJSON { (response) in
            switch response.result {
            case .success:
                //上传成功 todo 正在认证状态，刷新列表
                self.getCarList(customerid: personId!)
                self.tableView.reloadData()
                
                 let alert=UIAlertController(title: "",message: "上传成功,请等待审核。",preferredStyle: .alert )
                 let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                 alert.addAction(ok)
                 self.present(alert, animated: true, completion: nil)
                 return
            case .failure(let error):
                //上传失败
                 let alert=UIAlertController(title: "提示",message: "上传失败,请稍后再试。",preferredStyle: .alert )
                 let ok = UIAlertAction(title: "好",style: .cancel,handler: nil )
                 alert.addAction(ok)
                 self.present(alert, animated: true, completion: nil)
                 return
            }
 
            
        }
        
       
    }
    
    
}

