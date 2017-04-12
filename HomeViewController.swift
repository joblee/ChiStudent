//
//  HomeViewController.swift
//  Chinessy
//
//  Created by Kit on 12/8/15.
//  Copyright (c) 2015 Kit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class HomeViewController: UIViewController {
    
    //private var numOf15mins:Int!
    var warningMsgView:UIView!
    var warningMsg:UILabel!
    
    @IBOutlet var minutesRemain: UILabel!
    @IBOutlet var packageExpiryDate: UILabel!
    
    private var appVersion:String! = ""
    private var appStoreURL:String! = ""
    
    private var packageMin:Int! = 0
    private var freedomMin:Int! = 0
    
    var timer : NSTimer?
    
    func convertDate(dateToBeConverted:String) -> String{
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date:NSDate = dateFormatter.dateFromString(dateToBeConverted)!
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        
        let year:Int =  components.year
        let month:Int = components.month
        let day:Int = components.day
        var monthInString:String!
        
        switch month{
        case 1:
            monthInString = "Jan"
        case 2:
            monthInString = "Feb"
        case 3:
            monthInString = "Mar"
        case 4:
            monthInString = "Apr"
        case 5:
            monthInString = "May"
        case 6:
            monthInString = "Jun"
        case 7:
            monthInString = "Jul"
        case 8:
            monthInString = "Aug"
        case 9:
            monthInString = "Sep"
        case 10:
            monthInString = "Oct"
        case 11:
            monthInString = "Nov"
        default:
            monthInString = "Dec"
        }
        
        return "\(monthInString) \(day), \(year)"
    }
    
    
    func profileEditAction() {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileView") as! EditProfileViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func gotoAddBalanceView(){
        //let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddBalanceView") as! AddBalanceViewController
        //self.navigationController?.pushViewController(nextViewController, animated: true)
        
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("AddBalancePaymentView") as! AddBalancePaymentUIViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    //force to update
    func forceUpdate(appLink:String){
        dispatch_async(dispatch_get_main_queue(), {
            let importantAlert: UIAlertController = UIAlertController(title: "This version is outdated", message: "Press OK to get the latest version.", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                print("OK Pressed")
                //let APPURL:String! = "https://itunes.apple.com/us/app/chinessy/id1033009135"
                let APPURL:NSURL = NSURL(string: appLink)!
                UIApplication.sharedApplication().openURL(APPURL)
                exit(0) //force to quit the app
            }
            
            // Add the actions
            importantAlert.addAction(okAction)
            
            self.presentViewController(importantAlert, animated: true, completion: nil)
        })
    }
    
    
    func postJSONForceToupdate(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let loginURL = "\(ProjectSetting.serverLocationPython)/internal/check_update"
        
        Alamofire.request(.POST, loginURL, encoding:.JSON) .responseJSON{
            response in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if response.result.value != nil{
                let returnData:JSON = JSON(response.result.value!)
                
                if returnData["code"].stringValue == "10000"{
                    self.appVersion = returnData["data"]["app_version"].stringValue
                    self.appStoreURL = returnData["data"]["app_store_url"].stringValue
                    
                    
                    
                    //force to update the latest version
                    let curretVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
                    let currentAPPVersion = (curretVersion as NSString).floatValue
                    let serverAPPVersion = (self.appVersion as NSString).floatValue //= ("1.41" as NSString).floatValue
                    print("Force Update, Current:\(currentAPPVersion), Server:\(serverAPPVersion)")
                    
                    if self.appVersion == ""{
                        print("Can't get the latest APP Version")
                    }else if currentAPPVersion < serverAPPVersion{    //if curretVersion !=  self.appVersion{
                        print("APP is not the most update-to-date")
                        self.forceUpdate(self.appStoreURL)
                    }else{
                        print("It's the latest version.")
                    }
                }
            }
        }
    }
    
    
    func showErrorMessage(errMsg:String!){
        self.warningMsg.text = errMsg
        self.warningMsgView.alpha = 0.8
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            //nothing to do, just wait for a while
            self.warningMsgView.alpha = 0.801
            }, completion: { finished in
                UIView.animateWithDuration(0.5, animations: {
                    self.warningMsgView.alpha = 0
                })
        })
    }
    
    func pickTutorMessage(errMsg:String!){
        self.warningMsg.text = errMsg
        self.warningMsgView.alpha = 0.8
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            //nothing to do, just wait for a while
            self.warningMsgView.alpha = 0.801
            }, completion: { finished in
                UIView.animateWithDuration(0.5, animations: {
                    self.warningMsgView.alpha = 0
                })
                //self.postJSONGetBalance()
        })
    }
    //1对1按钮
    @IBAction func oneOnOneTuorBtnClicked(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 2
    }
    
    //直播按钮
    @IBAction func liveBtnClicked(sender: AnyObject) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let rootVC = storyboard.instantiateViewControllerWithIdentifier("mainView") as! UITabBarController
//        print(rootVC.selectedIndex)
        self.tabBarController?.selectedIndex = 1
    }
    
    
//    func postJSONGetMinRemain(){
//        print("postJSONGetMinRemain")
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//        let loginURL = "http://\(ProjectSetting.serverLocation)/internal/remain_minutes/get"
//        let accessToken:String = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as! String
//        
//        let params:[String: AnyObject] = ["access_token" : accessToken]
//        
//        Alamofire.request(.POST, loginURL, parameters:params, encoding:.JSON) .responseJSON{
//            response in
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//            
//            if response.result.value != nil{
//                let returnData:JSON = JSON(response.result.value!)
//                //println("Remain Minute: \(returnData)")
//                if returnData["code"].stringValue == "10000"{
//                    print(returnData)
//                    //self.numOf15mins = returnData["data"]["num_of_15_minutes"].intValue
//                    self.freedomMin = returnData["data"]["balance_free"].intValue
//                    self.packageMin = returnData["data"]["balance_package"].intValue
//                    self.minutesRemain.text = "\(self.freedomMin+self.packageMin)"
//                    self.minutesRemain.textColor = UIColor(red: 250.0/255.0, green: 149.0/255.0, blue: 47.0/255.0, alpha: 1)
//                    self.minutesRemain.font = UIFont.boldSystemFontOfSize(20)
//                    
//                    print("Free:\(self.freedomMin), Package:\(self.packageMin)")
//                    
//                    let postPackageExpire:String = returnData["data"]["user_balance_package"]["fields"]["end_at"].stringValue
//                    let postPackageMin:String = returnData["data"]["user_balance_package"]["fields"]["minutes"].stringValue
//                    //println("Package Minutes ==== \(count(postPackageExpire))")
//                    //if count(postPackageExpire) == 0{
//                    if postPackageExpire.characters.count == 0{
//                        dispatch_async(dispatch_get_main_queue(), {
//                            self.packageExpiryDate.hidden = true
//                        })
//                    }else{
//                        dispatch_async(dispatch_get_main_queue(), {
//                            self.packageExpiryDate.hidden = false
//                            self.packageExpiryDate.text = "\(postPackageMin)mins/day, Expired on \(self.convertDate(postPackageExpire))"
//                        })
//                    }
//                }
//            }
//        }
//    }
    
    func initStudentInfoData()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let loginURL = "\(ProjectSetting.serverLocationPHPLive)Home/Index/getMoneyInfo"
        
        // accessToken
        let userId = NSUserDefaults.standardUserDefaults().objectForKey("user_id") as! String
        
        if userId.characters.count < 1 {
            return
        }
        let params:[String: AnyObject] = ["userId" : userId]
        
        Alamofire.request(.POST, loginURL, parameters:params, encoding:.URL) .responseJSON{
            response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            print("Service Duration: \(response.result)")
            
            if response.result.value != nil
            {
                let downloadResults:JSON! = JSON(response.result.value!)
                
                print("Servie Duration: \(downloadResults)")
                
                if downloadResults["status"] == "true"
                {
                    // allBindingTime
                    let time:String = downloadResults["data"]["allTime"].stringValue
                    let beans:String = downloadResults["data"]["beans"].stringValue
                    
                    self.packageExpiryDate.text = "\(beans) beans & \(time) mins remaining"
                }
                else
                {
                    print("Connection Problem")
                }
            }
        }
        
    }

    func postJSONProfileName(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let loginURL = "\(ProjectSetting.serverLocationPython)/internal/user_profile/update"
        let accessToken:String = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as! String
        
        
        let params:[String: AnyObject] = ["access_token" : accessToken]
        
        Alamofire.request(.POST, loginURL, parameters:params, encoding:.JSON) .responseJSON{
            response in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if response.result.value != nil{
                let returnData:JSON = JSON(response.result.value!)
                
                //println(returnData)
                
                if returnData["code"].stringValue == "10000"{
                    ProjectSetting.studentName = returnData["data"]["fields"]["name"].stringValue
                    print("Project Setting: \(ProjectSetting.studentName)")
                }
            }
            
            
        }
    }

    
    /*
    func postJSONGetBalance(){
        println("postJSONGetBalance")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let loginURL = "http://\(ProjectSetting.serverLocation)/internal/remain_minutes/get"
        let accessToken:String = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as! String
        
        let params:[String: AnyObject] = ["access_token" : accessToken]
        
        Alamofire.request(.POST, loginURL, parameters:params, encoding: .JSON) .responseJSON{
            (request, response, data, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            if data != nil{
                let returnData:JSON = JSON(data!)
                //println(returnData)
                if returnData["code"].stringValue == "10000"{
                    self.numOf15mins = returnData["data"]["num_of_15_minutes"].intValue
                    self.postJSON()
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.showErrorMessage("手机号未被登记")
                    })
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.showErrorMessage("No Internet Connection")
                })
            }
        }
    }
    */
    
    
    func postJSON(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let loginURL = "\(ProjectSetting.serverLocationPython)/internal/teacher/random"
        let accessToken:String = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as! String
        
        
        
        let params:[String: AnyObject] = ["access_token" : accessToken]
        
        Alamofire.request(.POST, loginURL, parameters:params, encoding:.JSON) .responseJSON{
            response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            if response.result.value != nil{
                let result:JSON = JSON(response.result.value!)
                
                print("Home: \(result)")
                
                if result["code"].stringValue == "10000"{
                    
                    let name = result["data"]["teacher_profile"]["fields"]["name"].stringValue
                    let photoURL = result["data"]["teacher_profile"]["fields"]["head_img_key"].stringValue
                    let status = result["data"]["teacher_profile"]["fields"]["status"].stringValue
                    let userID = result["data"]["teacher_profile"]["fields"]["user"].intValue
                    
                    let education = result["data"]["teacher_profile"]["fields"]["education"].stringValue
                    let aboutMe = result["data"]["teacher_profile"]["fields"]["introduction"].stringValue
                    let spokenLang = result["data"]["teacher_profile"]["fields"]["spoken_languages"].stringValue
                    
                    let score = result["data"]["teacher_profile"]["fields"]["score"].stringValue
                    let country = result["data"]["teacher_profile"]["fields"]["country"].stringValue
                    let servedMin = result["data"]["teacher_profile"]["fields"]["served_minutes"].stringValue
                    
                    let email = result["data"]["teacher"]["fields"]["email"].stringValue
                    let favourite:Int! = (result["data"]["favourite_tutor"]["fields"] == nil) ? 0:1

                    print("Home Tutor \(result)")
                    //miss email and favourite
                    
                    
                    let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("TutorProfileDetails") as! TutorProfileDetailsViewController
                    nextVC.name = name
                    nextVC.status = status
                    nextVC.photo = photoURL
                    nextVC.userID = userID
                    nextVC.education = education
                    nextVC.aboutMe = aboutMe
                    nextVC.spokenLang = spokenLang
                    //nextVC.numOf15mins = 1  //this parameter will not use in later version
                    nextVC.popPanelImmediately = true
                    nextVC.score = score
                    nextVC.servedMin = servedMin
                    nextVC.location = country
                    nextVC.favourite = favourite
                    nextVC.email = email
                    
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    /*
                    dispatch_async(dispatch_get_main_queue(), {
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    })
                    */
                    
                }else if result["code"].stringValue == "20002"{
                    //println("Time conflict")
                    //dispatch_async(dispatch_get_main_queue(), {
                    //self.showErrorMessage("Reservation Failed! Time Conflict!")
                    //})
                    
                }else if result["code"].stringValue == "20004"{
                    //println("No available tutor")
                    
                    
                    let delay = 1 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.showErrorMessage("No tutor available")
                    }
                    //self.showErrorMessage("No tutor available")
                }
            }
            
        }
    }

    

    @IBAction func getMoreMinutes(sender: AnyObject) {
        /*
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("AddBalanceView") as! AddBalanceViewController
        self.navigationController?.pushViewController(next, animated: true)
        */
        //AddBalancePaymentView
        let ctl = MeAddBalanceController()
        ctl.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ctl, animated: true)
    }
    
    @IBAction func practiceNow(sender: AnyObject) {

        let userPhoneNum = NSUserDefaults.standardUserDefaults().objectForKey("phone") as? String
        print("Main page practice now pressed \(userPhoneNum)")
        
        /*
        if userPhoneNum == nil || userPhoneNum! == ""{
            self.phoneEditAction()
            return
        }
        */
        
        //let studentName = NSUserDefaults.standardUserDefaults().objectForKey("studentName") as? String
        //if studentName == nil || studentName! == ""{
        //    self.profileEditAction()
        //    return
        //}
        
        if self.packageMin == 0 && self.freedomMin == 0{
            self.gotoAddBalanceView()
            return
        }
        
        self.pickTutorMessage("Picking up a\ntutor for you...")
        self.postJSON()
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        //check if the version is the most updated
        self.postJSONForceToupdate()
        //Display the updated remaining minute in the home
//        self.postJSONGetMinRemain()
        self.initStudentInfoData()
        MobClick.beginLogPageView("HomeView")
        
        //get the Student Name from Server
        self.postJSONProfileName()

    }
    
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("HomeView")
    }
    func showLiveBadge(notification:NSNotification) {
        self.tabBarController?.tabBar.showBadgeOnItemIndex(1)
    }
    func showTutorsBadge(notification:NSNotification) {
        self.tabBarController?.tabBar.showBadgeOnItemIndex(2)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.showLiveBadge(_:)), name: "showLiveBadgeNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.showTutorsBadge(_:)), name: "showTutorsBadgeNotification", object: nil)
        //println(ProjectSetting.serverLocation)
        
        //must add this statement to make it won't be shift under navigation
        //it should be apple's bugs
        self.navigationController!.navigationBar.translucent = false

        // Do any additional setup after loading the view.
        
        //Navigation Bar
        self.navigationItem.title = "Chinessy"
        
        //let the "<" icon in the next push view just show the "<" without text
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        //measurement
        let screenWidth = self.view.frame.size.width
        //let screenHeight = self.view.frame.size.height
        //let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        //Add Warning Message
        warningMsgView=UIView(frame: CGRectMake((screenWidth-220)/2, 180, 220, 100))
        warningMsgView.backgroundColor=UIColor.blackColor()
        warningMsgView.layer.cornerRadius=5
        warningMsgView.alpha=0.8
        
        //add text message
        warningMsg = UILabel(frame: CGRectMake((220-200)/2, (100-50)/2, 200, 50))
        warningMsg.textColor = UIColor.whiteColor()
        warningMsg.text = "Warning"
        warningMsg.textAlignment = NSTextAlignment.Center
        warningMsg.font = UIFont.systemFontOfSize(18)
        warningMsg.numberOfLines = 0
        
        warningMsgView.addSubview(warningMsg)
        warningMsgView.bringSubviewToFront(warningMsg)
        self.view.addSubview(warningMsgView)
        warningMsgView.alpha = 0
        
        // 每秒钟刷新一次
        // 定时器
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(isAppointmentOverTime), userInfo: nil, repeats: true);
        timer?.fireDate = NSDate.distantPast()
    }

    func isAppointmentOverTime()
    {
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
       
        // accessToken
        //        let userId = NSUserDefaults.standardUserDefaults().objectForKey("user_id")
        
        let loginURL = "\(ProjectSetting.serverLocationPHP)home/live/overdue"
        let userId = NSUserDefaults.standardUserDefaults().objectForKey("user_id")
        
        //        let params:[String: AnyObject] = ["s_id" : userId!, "t_id" : userID]
        let params:[String: AnyObject] = ["s_id" : userId!]
      
//        print(loginURL)
        
        Alamofire.request(.GET, loginURL, parameters:params, encoding:.URL) .responseJSON{
            response in
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            //print("Service Duration: \(response.result)")
            
            if response.result.value != nil
            {
                let downloadResults:JSON! = JSON(response.result.value!)
                
//                print("Servie Duration: \(downloadResults.rawValue)")
//                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//                NSError *err;
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                    options:NSJSONReadingMutableContainers
//                    error:&err]; self.tutorsList!["code"].stringValue
                let model = PushInfoModel()
                model.status = downloadResults["status"].stringValue
                model.msg = downloadResults["msg"].stringValue
                model.student_id = downloadResults["data"][0]["student_id"].stringValue
                model.teacher_id = downloadResults["data"][0]["teacher_id"].stringValue
                model.push_time = downloadResults["data"][0]["push_time"].stringValue
                
                
                // 发送通知
                NSNotificationCenter.defaultCenter().postNotificationName("RefreshPerSecond",
                    object: self, userInfo: ["model" : model])
            }
        }
    }
    
    deinit
    {
        timer?.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
