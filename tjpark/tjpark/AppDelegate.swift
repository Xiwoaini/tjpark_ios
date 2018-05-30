//
//  AppDelegate.swift
//  tjpark
//
//  Created by 潘宁 on 2017/11/8.
//  Copyright © 2017年 fut. All rights reserved.


import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKGeneralDelegate{

    var window: UIWindow?
    var _mapManager: BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        /**
         百度地图部分:
         */
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = BMKMapManager()
        let ret = _mapManager?.start("ZoIrfyqzEoAMaCubKMIt8RbEpibvFfnq", generalDelegate: self)
        //微信部分
        WXApi.registerApp("wxbda31b250a331d1d")
        
        /**
         极光推送部分:
         极光推送部署
         */
        
        if #available(iOS 11.0, *){
            let entiity = JPUSHRegisterEntity()
            entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
                UNAuthorizationOptions.badge.rawValue |
                UNAuthorizationOptions.sound.rawValue)
        }else  if #available(iOS 10.0, *){
            let entiity = JPUSHRegisterEntity()
            entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
                UNAuthorizationOptions.badge.rawValue |
                UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entiity, delegate: self)
            
        } else if #available(iOS 8.0, *) {
            let types = UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
        }else {
            let type = UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
        
        JPUSHService.setup(withOption: launchOptions,
                           appKey: "7d7353ff640d2622655c7a73",
                           channel: "app store",
                           apsForProduction: true )
        ///支付宝相关配置，初始化支付管理类
        AliSdkManager.sharedManager()
        //启动时候，调用远程并获取大量数据
//        MapController().getParkList();
        return true
    }
    
    //重写支付方法，会发起回调
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // WXApiManager 需要自己创建，下面就会说到。
//        return WXApi.handleOpen(url, delegate: WXApiManager.shared)
        
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url as URL!, standbyCallback: {
                (resultDic) -> Void in
                //调起支付结果处理
//              AliSdkManager.aliSdkManager.showResult(result: resultDic! as NSDictionary);
            })
            AlipaySDK.defaultService().processOrder(withPaymentResult: url as URL!, standbyCallback: {
                (resultDic) -> Void in
                //调起支付结果处理
                AliSdkManager.aliSdkManager.showResult(result: resultDic! as NSDictionary);
            })
        }
        return true;
    }

    

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber =  0
        
        application.cancelAllLocalNotifications()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        //极光推送
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //极光推送部分(sdk注册成功后会调用此方法)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        JPUSHService.registerDeviceToken(deviceToken)
        
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        
        completionHandler(.newData)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        
    }
    //极光推送部分
}


//推送拓展

extension AppDelegate : JPUSHRegisterDelegate{
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
 
}



