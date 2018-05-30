//
//  Bridging-Header.h
//  tjpark
//
//  Created by 潘宁 on 2017/11/17.
//  Copyright © 2017年 fut. All rights reserved.
//

#ifndef BMKSwiftDemo_Bridging_Header_h
#define BMKSwiftDemo_Bridging_Header_h
//百度地图部分
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import "BMKClusterManager.h"
//支付宝
#import <AlipaySDK/AlipaySDK.h>
#import "APOrderInfo.h"
#import "APRSASigner.h"
//微信
#import "WXApi.h"

//刷新控件
//#import "MJRefresh.h"
//加载控件
//#import "SVProgressHUD.h"

//极光推送部分
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>



#endif /* BMKSwiftDemo_Bridging_Header_h */
