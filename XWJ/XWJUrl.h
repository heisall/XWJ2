//
//  XWJUrl.h
//  XWJ
//
//  Created by Sun on 15/12/7.
//  Copyright © 2015年 Paul. All rights reserved.
//

#ifndef XWJUrl_h
#define XWJUrl_h


#define MESSAGE_CONTENT @"【信我家】您的信我家验证码为：%d，感谢您的使用！"
#define YUYUEMESSAGE_CONTENT @"《信我家》预约信息：预约产品：%@，%@，%@."
#define GOUMAIMESSAGE_CONTENT @"《信我家》您有一个订单，请尽快处理！"


//#define XWJBASEURL @"http://115.28.48.166:8100/appPhone/"
#define XWJBASEURL @"http://www.hisenseplus.com:8100/appPhone/rest/"
//admin.hisenseplus.com

//#define XWJBASEURL @"http://www.hisenseplus.com:8100/appPhone/rest/"
#define IDCODE_URL @"http://dx.qxtsms.cn/sms.aspx?action=send&userid=%@&account=hisenseplus&password=hisenseplus&mobile=%@&content=%@&sendTime=&checkcontent=1"

#define LOGIN_URL  XWJBASEURL"user/userLogin"
#define REGISTER_URL  XWJBASEURL"user/register"
#define RESETPWD_URL  XWJBASEURL"user/resetPass"

//dingdand
#define ADDORDER_URL  XWJBASEURL"order/addOrder"
#define SAVEORDER_URL  XWJBASEURL"order/saveOrder"

//car
#define ADDCAR_URL  XWJBASEURL"order/addCart"
#define GETCARLIST_URL  XWJBASEURL"order/cartList"
#define CLEANCAR_URL  XWJBASEURL"order/cleanCart"
#define GETGOODORDER_URL  XWJBASEURL"order/bookOnLine"

#define GETADDRESS_URL  XWJBASEURL"order/manegerAddress"
#define GETADDRESSLIST_URL  XWJBASEURL"order/addressList"

//life
#define GETLIFEAD_URL  XWJBASEURL"life/lifeIndex"
#define GETSHANGMENAD_URL  XWJBASEURL"life/onDoorIndex"
#define GETLIFEMORE_URL  XWJBASEURL"life/classifyIndex"
#define GETSHLIST_URL  XWJBASEURL"life/merchantList"

#define GETLIFESTORE_URL  XWJBASEURL"life/storeDetail"
#define GETGOODDETAIL_URL  XWJBASEURL"life/goodsDetail"
//find

#define GETFINDLIST_URL XWJBASEURL"find/findIndex"
#define GETFIND_URL XWJBASEURL"find/findDetail"
#define GETFINDPUBCOM_URL XWJBASEURL"user/publishComments"
#define GETFINDPUB_URL XWJBASEURL"user/saveFind"

#define GETWUYE_URL XWJBASEURL"sup/supIndex"
#define GETWUYEDETAIL_URL XWJBASEURL"sup/supDetail"

//zhangdan
#define  GETFZHANGDAN_URL XWJBASEURL"bill/findBills"
//guzhang
#define  GETFGUZHANG_URL XWJBASEURL"bill/myComplains"
#define  GETFGUZHANGDETAIL_URL XWJBASEURL"bill/complainDetail"
#define  GETFGUZHANADD_URL XWJBASEURL"bill/complainSave"
#define  GETGUZHANGPINGJIA_URL  XWJBASEURL"bill/saveEvaluate"

#define  GETGUANJIAAD_URL  XWJBASEURL"keep/keepIndex"
//xinfang
#define GETXINFANG_URL XWJBASEURL"house/newHouseIndex"
#define GETXINFANGDETAIL_URL XWJBASEURL"house/houseDetail"
#define GETXINFANGHXT_URL XWJBASEURL"house/stylePhoto"

#define GET2HAND_URL XWJBASEURL"house/oldHouseList"
#define GET2HANDDETAIL_URL XWJBASEURL"house/oldHouseDetail"
#define GET2HANDDFILTER_URL XWJBASEURL"house/houseFilter"

#define GETCHUZU_URL XWJBASEURL"house/rentHouseList"
#define GETCHUZUDETAIL_URL XWJBASEURL"house/rentHouseDetail"
#define GETCHUZUFILTER_URL XWJBASEURL"house/rentFilter"

#define GET2HANDFBFILTER_URL XWJBASEURL"house/addOldHouse"
#define GET2HANDFB_URL XWJBASEURL"house/saveOldHouse"   //put

#define GETCHUZUFBFILTER_URL XWJBASEURL"house/addRentHouse"
#define GETCHUZUFB_URL XWJBASEURL"house/saveRentHouse"  //put

#define GETXINFANGSHOUCANG_URL XWJBASEURL"house/houseCollect"
//ad
#define GETACTIVE_URL XWJBASEURL"act/findActPage"
#define GETAD_URL  XWJBASEURL"index/ads"
#define GETENROLL_URL XWJBASEURL"act/enrollAct"
#define GETDETAILAD_URL XWJBASEURL"act/actDetail"
//bind
#define GETCITY_URL  XWJBASEURL"build/getCitys"
#define GETDISTRICT_URL  XWJBASEURL"build/getSubdistrict"
#define GETBUIDING_URL  XWJBASEURL"build/getBuildings"
#define GETROOM_URL  XWJBASEURL"build/getRomes"
//#define GETROOM_URL @"http://www.hisenseplus.com:8100/appPhone/build/getRooms"
#define LOCKROOM_URL  XWJBASEURL"build/lockRooms"

//tuangou
#define GETGROUP_URL  XWJBASEURL"life/groupBuying"

//order
#define GETORDER_URL  XWJBASEURL"order/myOrders"
#define GETORDERCONFIRM_URL  XWJBASEURL"order/changeOrderStatus"
//订单详情接口
#define MYORDERDETAIL  XWJBASEURL"order/orderDetails"

//订单评价
#define PINGJIAORDER  XWJBASEURL"order/evaluateGoods"

//订单删除
#define DELEORDER  XWJBASEURL"order/delOrder"

//确认收货  修改订单状态
#define MAKESUREORDER  XWJBASEURL"order/changeOrderStatus"

//签到广告页面
#define SIGNADD  XWJBASEURL"index/signIndex"
//
#define SIGNSUCC  XWJBASEURL"user/signIn"

#define YEZHU_URL  XWJBASEURL"build/infoValidate"
#define CHANGEFANGYUAN_URL  XWJBASEURL"build/changeDefault"

//#define GETCITY_URL  XWJBASEURL"build/getCitys"
//#define GETCITY_URL  XWJBASEURL"build/getCitys"

//huodong
#define HUODONG_URL  XWJBASEURL"act/findActPage"

//zhucexiy
#define XIEYI_URL @"http://ecmall.hisenseplus.com:88/index.php?app=article&act=content_only&article_id=7"
#define AD_URL  XWJBASEURL"index/ads"


#endif /* XWJUrl_h */
