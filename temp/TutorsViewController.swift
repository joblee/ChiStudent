//
//  TutorsViewController.swift
//  Chinessy
//
//  Created by Kit on 12/8/15.
//  Copyright (c) 2015 Kit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TutorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tutorsTableView: UITableView!
    //@IBOutlet var tutorsTableView: UITableView!
    private var tutorsList:JSON?
    
    private var blankView:UIView!
    
    var warningMsgView:UIView!
    var warningMsg:UILabel!
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func postJSON(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let loginURL = "http://\(ProjectSetting.serverLocation)/internal/teacher/find"
        let accessToken:String = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as! String
        
        let params:[String: AnyObject] = ["access_token" : accessToken]
        
        Alamofire.request(.POST, loginURL, parameters:params, encoding:.JSON) .responseJSON{
            response in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if response.result.value != nil{
                self.tutorsList = JSON(response.result.value!)
                
                print("1@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                print(self.tutorsList)
                
                if self.tutorsList!["code"].stringValue == "10000"{
                    //println(self.tutorsList)
                    self.tutorsTableView.hidden = false
                    self.blankView.hidden = true
                    dispatch_async(dispatch_get_main_queue(), {self.tutorsTableView.reloadData()})
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 3
        
        if self.tutorsList == nil{
            return 0
        }else{
            if section == 0{
                return self.tutorsList!["data"]["available"].count
            }else if section == 1{
                return self.tutorsList!["data"]["busy"].count
            }else{
                return self.tutorsList!["data"]["offline"].count
            }
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TutorTableViewCell
        
        
        var name:String!
        var spokenLanguage:String!
        var photoURL:String!
        
        if indexPath.section == 0{
            name = self.tutorsList!["data"]["available"][indexPath.row]["user_profile"]["fields"]["name"].stringValue
            spokenLanguage = self.tutorsList!["data"]["available"][indexPath.row]["user_profile"]["fields"]["spoken_languages"].stringValue
            photoURL = self.tutorsList!["data"]["available"][indexPath.row]["user_profile"]["fields"]["head_img_key"].stringValue
        }else if indexPath.section == 1{
            name = self.tutorsList!["data"]["busy"][indexPath.row]["user_profile"]["fields"]["name"].stringValue
            spokenLanguage = self.tutorsList!["data"]["busy"][indexPath.row]["user_profile"]["fields"]["spoken_languages"].stringValue
            photoURL = self.tutorsList!["data"]["busy"][indexPath.row]["user_profile"]["fields"]["head_img_key"].stringValue
        }else{
            name = self.tutorsList!["data"]["offline"][indexPath.row]["user_profile"]["fields"]["name"].stringValue
            spokenLanguage = self.tutorsList!["data"]["offline"][indexPath.row]["user_profile"]["fields"]["spoken_languages"].stringValue
            photoURL = self.tutorsList!["data"]["offline"][indexPath.row]["user_profile"]["fields"]["head_img_key"].stringValue
        }
        
        let teacherURL = "http://7xl3jz.com1.z0.glb.clouddn.com/\(photoURL)"
        
        
        
        Alamofire.request(.GET, teacherURL)
            .responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    cell.headPhoto.image = image
                    cell.headPhoto.layer.cornerRadius =  cell.headPhoto.frame.size.width / 2
                    cell.headPhoto.clipsToBounds = true
                    cell.setNeedsLayout()
                }
        }
        
        /*
        Alamofire.request(.GET, teacherURL)
            .responseImage() { (request, _, image, error) in
                if error == nil && image != nil {
                    //cell.tutorImage.image = image
                    cell.headPhoto.image = image
                    cell.headPhoto.layer.cornerRadius =  cell.headPhoto.frame.size.width / 2
                    cell.headPhoto.clipsToBounds = true
                    cell.setNeedsLayout()
                }
        }
        */
        
        // Configure the cell...
        //cell.textLabel?.text = "work"
        cell.tutorName.text = name
        cell.tutorLanguage.text = "\(spokenLanguage)"
        if indexPath.section == 0{
            cell.tutorStatus.image = UIImage(named: "dot_available")
        }else if indexPath.section == 1{
            cell.tutorStatus.image = UIImage(named: "dot_busy")
        }else{
            cell.tutorStatus.image = UIImage(named: "dot_offline")
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 10
        }else{
            return 0.00001
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 15
        }else{
            return 0.00001
        }
    }
    
    /*
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Available"
        }else if section == 1{
            return "Busy"
        }else{
            return "Offline"
        }
    }
    */
    
    //Custom the Header in each section
    /*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var textLabel:UILabel
        if section == 0{
            textLabel = UILabel(frame: CGRectMake(10, 20, 100, 30))
        }else{
            textLabel = UILabel(frame: CGRectMake(10, 0, 100, 30))
        }
        textLabel.textAlignment = NSTextAlignment.Left
        textLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        textLabel.font = UIFont.systemFontOfSize(18)
        textLabel.textColor = UIColor.lightGrayColor()
        var viewForHeader:UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        viewForHeader.addSubview(textLabel)
        return viewForHeader
    }
    */
    

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        /*
        if ((indexPath.row == 0) || (indexPath.row == 3) || (indexPath.row == 6)){
            return 50
        }else{
            return 80
        }
        */
        
        return 80
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //deselct the row after it'selected
        self.tutorsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.postJSON()
        MobClick.beginLogPageView("TutorsView")
        
        //close the panel for TutorProfileView
        //NSUserDefaults.standardUserDefaults().setObject(PanelState.Closed.description, forKey: "panelState")
    }
    
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("TutorsView")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let the "<" icon in the next push view just show the "<" without text
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        //must add this statement to make it won't be shift under navigation
        //it should be apple's bugs
        self.navigationController!.navigationBar.translucent = false
        
        //Navigation Bar
        self.navigationItem.title = "Tutors"
        //self.navigationItem.backBarButtonItem?.tintColor = UIColor.grayColor()
        
        //measurement
        let screenWidth = self.view.frame.size.width
        let screenHeight = self.view.frame.size.height
        //let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        //self.tutorsTableView.frame = CGRectMake(0, 20, screenWidth, screenHeight)
        //self.tutorsTableView.frame = CGRectMake(0, 20, screenWidth, screenHeight)
        self.tutorsTableView.frame = CGRectMake(0, -10, screenWidth, screenHeight-40)
        
        //add blank View
        self.blankView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.blankView.backgroundColor = self.UIColorFromRGB(0xEEEEEE)
        self.view.addSubview(self.blankView)
        
        //Add Warning Message
        warningMsgView=UIView(frame: CGRectMake((screenWidth-300)/2, 220, 300, 100))
        warningMsgView.backgroundColor=UIColor.blackColor()
        warningMsgView.layer.cornerRadius=5
        warningMsgView.alpha=0.8
        
        //add text message
        warningMsg = UILabel(frame: CGRectMake((300-280)/2, (100-50)/2, 280, 50))
        warningMsg.textColor = UIColor.whiteColor()
        warningMsg.text = "Warning"
        warningMsg.textAlignment = NSTextAlignment.Center
        warningMsg.font = UIFont.systemFontOfSize(18)
        
        warningMsgView.addSubview(warningMsg)
        warningMsgView.bringSubviewToFront(warningMsg)
        self.view.addSubview(warningMsgView)
        warningMsgView.alpha = 0
        
        //hidden the view
        self.blankView.hidden = false
        self.tutorsTableView.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let section = self.tutorsTableView.indexPathForSelectedRow?.section
        let row = self.tutorsTableView.indexPathForSelectedRow?.row
        
        var name:String!
        var photoURL:String!
        var status:String!
        var userID:Int!
        var education:String!
        var aboutMe:String!
        var spokenLang:String!
        
        var servedMin:String!   //served_minutes
        var score:String!       //score
        var country:String!
        
        if section == 0{
            name = self.tutorsList!["data"]["available"][row!]["user_profile"]["fields"]["name"].stringValue
            photoURL = self.tutorsList!["data"]["available"][row!]["user_profile"]["fields"]["head_img_key"].stringValue
            status = self.tutorsList!["data"]["available"][row!]["user_profile"]["fields"]["status"].stringValue
            userID = self.tutorsList!["data"]["available"][row!]["user_profile"]["fields"]["user"].intValue
            education = self.tutorsList!["data"]["available"][row!]["user_profile"]["fields"]["education"].stringValue
            aboutMe = self.tutorsList!["data"]["available"][row!]["user_profile"]["fields"]["introduction"].stringValue
            spokenLang = self.tutorsList!["data"]["available"][row!]["user_profile"]["fields"]["spoken_languages"].stringValue
            servedMin = self.tutorsList!["data"]["available"][row!]["user_profile"]["fields"]["served_minutes"].stringValue
            score = self.tutorsList!["data"]["available"][row!]["user_profile"]["fields"]["score"].stringValue
            country = self.tutorsList!["data"]["available"][row!]["user_profile"]["fields"]["country"].stringValue
        }else if section == 1{
            name = self.tutorsList!["data"]["busy"][row!]["user_profile"]["fields"]["name"].stringValue
            photoURL = self.tutorsList!["data"]["busy"][row!]["user_profile"]["fields"]["head_img_key"].stringValue
            status = self.tutorsList!["data"]["busy"][row!]["user_profile"]["fields"]["status"].stringValue
            userID = self.tutorsList!["data"]["busy"][row!]["user_profile"]["fields"]["user"].intValue
            education = self.tutorsList!["data"]["busy"][row!]["user_profile"]["fields"]["education"].stringValue
            aboutMe = self.tutorsList!["data"]["busy"][row!]["user_profile"]["fields"]["introduction"].stringValue
            spokenLang = self.tutorsList!["data"]["busy"][row!]["user_profile"]["fields"]["spoken_languages"].stringValue
            servedMin = self.tutorsList!["data"]["busy"][row!]["user_profile"]["fields"]["served_minutes"].stringValue
            score = self.tutorsList!["data"]["busy"][row!]["user_profile"]["fields"]["score"].stringValue
            country = self.tutorsList!["data"]["busy"][row!]["user_profile"]["fields"]["country"].stringValue
        }else{
            name = self.tutorsList!["data"]["offline"][row!]["user_profile"]["fields"]["name"].stringValue
            photoURL = self.tutorsList!["data"]["offline"][row!]["user_profile"]["fields"]["head_img_key"].stringValue
            status = self.tutorsList!["data"]["offline"][row!]["user_profile"]["fields"]["status"].stringValue
            userID = self.tutorsList!["data"]["offline"][row!]["user_profile"]["fields"]["user"].intValue
            education = self.tutorsList!["data"]["offline"][row!]["user_profile"]["fields"]["education"].stringValue
            aboutMe = self.tutorsList!["data"]["offline"][row!]["user_profile"]["fields"]["introduction"].stringValue
            spokenLang = self.tutorsList!["data"]["offline"][row!]["user_profile"]["fields"]["spoken_languages"].stringValue
            servedMin = self.tutorsList!["data"]["offline"][row!]["user_profile"]["fields"]["served_minutes"].stringValue
            score = self.tutorsList!["data"]["offline"][row!]["user_profile"]["fields"]["score"].stringValue
            country = self.tutorsList!["data"]["offline"][row!]["user_profile"]["fields"]["country"].stringValue
        }
        
        let nextVC = segue.destinationViewController as! TutorProfileDetailsViewController
        nextVC.name = name
        nextVC.photo = photoURL
        nextVC.status = status
        nextVC.userID = userID
        nextVC.education = education
        nextVC.aboutMe = aboutMe
        nextVC.spokenLang = spokenLang
        nextVC.score = score
        nextVC.servedMin = servedMin
        nextVC.location = country
        //println("TutorProfileView: About Me -> \(aboutMe)")
        //println("TutorProfileView: Education -> \(education)")
        //println("Do Segue")
    }
    

}
