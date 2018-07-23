//
//  tabBarViewController.swift
//  Sampy
//
//  Created by Omar Abbas on 8/17/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift

class tabBarViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet var buttons: [UIButton]!
   
    @IBOutlet weak var iPhoneXBottomView: UIView!
    var settingsViewController: UIViewController!
    var mapViewController: UIViewController!
    var postViewController: UIViewController!
    var feedViewController: UIViewController!
    var profileViewController: UIViewController!
    
    var viewControllers: [UIViewController]!
    
    @IBOutlet weak var settingsPicture: UIImageView!
    @IBOutlet weak var mapPicture: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var feedPicture: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var feedButton: UIButton!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var postPicture: UIImageView!
    
    @IBOutlet weak var borderUnderIcons: UITextField!
    var selectedIndex: Int = 3
    
    @IBAction func didPressTab(_ sender: UIButton) {
        
        let greyColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)
        
        let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
        
        switch sender.tag{
        case 0:
            UIView.animate(withDuration: 0.35){
            self.borderUnderIcons.center.x = self.settingsLabel.center.x
            
            self.settingsLabel.textColor = greenColor
            self.mapLabel.textColor = greyColor
            self.postLabel.textColor = greyColor
            self.feedLabel.textColor = greyColor
            self.profileLabel.textColor = greyColor
                
            self.settingsPicture.isHighlighted = true
            self.postPicture.isHighlighted = false
            self.mapPicture.isHighlighted = false
            self.profilePicture.isHighlighted = false
            self.feedPicture.isHighlighted = false
            
            
            }
            break
        case 1:
            UIView.animate(withDuration: 0.35){
            self.borderUnderIcons.center.x = self.mapPicture.center.x
            self.mapLabel.textColor = greenColor
            self.settingsLabel.textColor = greyColor
            self.postLabel.textColor = greyColor
            self.feedLabel.textColor = greyColor
            self.profileLabel.textColor = greyColor
                
            self.settingsPicture.isHighlighted = false
            self.postPicture.isHighlighted = false
            self.mapPicture.isHighlighted = true
            self.profilePicture.isHighlighted = false
            self.feedPicture.isHighlighted = false
                
                
            }
            break
        case 2:
            UIView.animate(withDuration: 0.35){
            self.borderUnderIcons.center.x = self.postButton.center.x
            self.postLabel.textColor = greenColor
            self.settingsLabel.textColor = greyColor
            self.mapLabel.textColor = greyColor
            self.feedLabel.textColor = greyColor
            self.profileLabel.textColor = greyColor
            
                
            self.settingsPicture.isHighlighted = false
            self.mapPicture.isHighlighted = false
            self.profilePicture.isHighlighted = false
            self.feedPicture.isHighlighted = false
            self.postPicture.isHighlighted = true
                
            }
            break
        case 3:
            UIView.animate(withDuration: 0.35){
            self.borderUnderIcons.center.x = self.feedPicture.center.x
            self.feedLabel.textColor = greenColor
            self.settingsLabel.textColor = greyColor
            self.mapLabel.textColor = greyColor
            self.postLabel.textColor = greyColor
            self.profileLabel.textColor = greyColor
            
                
                
            self.settingsPicture.isHighlighted = false
            self.mapPicture.isHighlighted = false
            self.profilePicture.isHighlighted = false
            self.feedPicture.isHighlighted = true
            self.postPicture.isHighlighted = false
           
            }
            break
        case 4:
            UIView.animate(withDuration: 0.35){
            self.borderUnderIcons.center.x = self.profilePicture.center.x
            self.profileLabel.textColor = greenColor
            self.settingsLabel.textColor = greyColor
            self.mapLabel.textColor = greyColor
            self.postLabel.textColor = greyColor
            self.feedLabel.textColor = greyColor
                
                
            self.settingsPicture.isHighlighted = false
            self.mapPicture.isHighlighted = false
            self.profilePicture.isHighlighted = true
            self.feedPicture.isHighlighted = false
            self.postPicture.isHighlighted = false
            
            }
            break
        default:
            UIView.animate(withDuration: 0.35){
            self.borderUnderIcons.center.x = self.feedLabel.center.x
            self.feedLabel.textColor = greenColor
        }
    }
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        buttons[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        sender.isSelected = true
        let vc = viewControllers[selectedIndex]
        addChildViewController(vc)
        
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
  
    @IBOutlet weak var settingsLabel: UILabel!
    
    @IBOutlet weak var postLabel: UILabel!
    
    @IBOutlet weak var feedLabel: UILabel!
    
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var mapLabel: UILabel!
    var statusBarStyle:UIStatusBarStyle = .default
    var statusBarShouldBeHidden = false
    
    override var prefersStatusBarHidden: Bool{
        return statusBarShouldBeHidden
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iPhoneXBottomView.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        settingsViewController = storyboard.instantiateViewController(withIdentifier: "settingsViewController")
        
        mapViewController = storyboard.instantiateViewController(withIdentifier: "mapNavigationController") //Main
        
        postViewController = storyboard.instantiateViewController(withIdentifier: "postViewController")
        
        feedViewController = storyboard.instantiateViewController(withIdentifier: "feedNavigationController") //listFeed
        
        profileViewController = storyboard.instantiateViewController(withIdentifier: "profileViewController")
        
        viewControllers = [settingsViewController,mapViewController,postViewController,feedViewController,profileViewController]
        buttons[selectedIndex].isSelected = true
        didPressTab(buttons[selectedIndex])
    
        let border = CALayer()
        
        let width = CGFloat(2)
        
        let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
        
        border.borderColor = greenColor.cgColor
        border.frame = CGRect(x: 0, y: mapLabel.frame.size.height - width, width:  settingsLabel.frame.size.width, height: mapLabel.frame.size.height)
        border.borderWidth = width
        
        borderUnderIcons.layer.addSublayer(border)

        postButton.clipsToBounds = true
        postButton.layer.cornerRadius = postButton.frame.size.height / 2
        postButton.layer.cornerRadius = postButton.frame.size.width / 2
    //752
        //722
    //    Database.database().reference().child("Version").observeSingleEvent(of: .value, with: {(snapshot) in
      //      let dictionary = snapshot.value as? [String: AnyObject]
            
        //    let currentVersion = dictionary!["currentVersion"] as! String
            
          //  let getAppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
           // let appVersion = getAppVersion

            //if appVersion != currentVersion {

            //let updatedInformation = dictionary!["updatedFeature"] as! String

           // let infoBanner = NotificationBanner(title: "New update is available!", subtitle: updatedInformation, style: .info)
      //  infoBanner.show()
   
        //        }
        //})
        
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                print("iPhone 4 or 4S")
            case 1136:
                print("iPhone 5 or 5S or 5c")
            case 1334:
                print("iPhone 6 or 6s")
            case 2208:
                print("iPhone 6+ or 6S+")
            case 2436:
                print("it is the iPhone X")
  tabBarView.frame.origin.y = 722
                iPhoneXBottomView.isHidden = false
            default:
                print("unknown")
            }
        }
    }
    func openAppStore(){
        if let url = URL(string: ("https://itunes.apple.com/us/app/sampy/id1244437171?mt=8")){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func goToADifferentFeed(){
        
        let vc = feedViewController
        addChildViewController(vc!)
        
        vc?.view.frame = contentView.bounds
        contentView.addSubview((vc?.view)!)
        vc?.didMove(toParentViewController: self)
    }
}
