//
//  NewsController.swift
//  tjpark
//
//  Created by 潘宁 on 2018/7/5.
//  Copyright © 2018年 fut. All rights reserved.
//


import UIKit
import SwiftyJSON
class NewsController: UIViewController{
    var indexNews = 0
         var newsList :[News] = []
    @IBOutlet weak var newsTitle: UILabel!
    
    @IBOutlet weak var newTime: UILabel!
    
   
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     override func viewWillAppear(_ animated: Bool) {
        do {
            newsTitle.text = newsList[indexNews].n_title
            newTime.text = "天津停车    " + newsList[indexNews].n_releasetime
            
            textView.text = newsList[indexNews].n_contail
        }
        catch{
            
        }
       
 
    }
    
    
    
    
    
   
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated:true, completion:nil)
    }
    
}
