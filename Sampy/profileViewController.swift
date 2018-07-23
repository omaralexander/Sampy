//
//  profileViewController.swift
//  Sampy
//
//  Created by Omar Abbas on 5/27/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView


class profileViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var dismissButton: UIButton!
   
    @IBOutlet weak var editProfile: UIButton!
    
    @IBOutlet weak var totalViewsLabel: UILabel!
  
    @IBOutlet weak var totalPostsLabel: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var circleProfilePicture: UIImageView!
    
    @IBOutlet weak var noPostsToShow: UILabel!
    @IBOutlet weak var logOutButton: UILabel!
    @IBOutlet weak var mainScroll: UIScrollView!
   
    @IBOutlet weak var viewForCell: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var topViewHolder: UIView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var userCity: UILabel!
  
    @IBOutlet weak var aboutMeBio: UITextView!
    
    @IBOutlet weak var badgesBorder: UITextField!
   
    @IBOutlet weak var spacingView: UIView!

    var userPosts = [MapPoints]()
    var totalViewCount: Float = 0
   
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    loadTheView()
    }
    override func viewDidAppear(_ animated: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.child("profileImageUrl").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() == false {
                let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                let bc: UIViewController = storyboard.instantiateViewController(withIdentifier: "appStartViewController")
                self.present(bc, animated: true, completion: nil)
      
                
            }
        })
    }
    
    func editProfileFunction(){
        performSegue(withIdentifier: "editProfile", sender: self)
    }
    override func viewWillAppear(_ animated: Bool) {
         print("this is the size of the profilepicture\(self.circleProfilePicture.frame)")
    }
    func dismissViewController(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print("This is the logout error \(logoutError)")
        }
        performSegue(withIdentifier: "logOutSegue", sender: self)
    }
    var timer: Timer?
    func handleReloadTable(){
        self.collectionView.reloadData()
    }

    func observeUserPosts(){
      self.totalViewCount = 0
      self.userPosts.removeAll()
        self.topViewHolder.backgroundColor = UIColor.clear
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("user-history-posts").child(uid)
        
        ref.observe(.childAdded, with: {(snapshot) in
            let messageId = snapshot.key
            let postRef = Database.database().reference().child("HistoryOfPosts").child("post").child(messageId)
            postRef.observeSingleEvent(of: .value, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let lat = dictionary["lat"] as! Double
                    let long = dictionary["long"] as! Double
                    let image = dictionary["image"] as! String
                    let text = dictionary["text"] as! String
                    let user = dictionary["user"] as! String
                    let address = dictionary["postCity"] as! String
                    let time = dictionary["time"] as! NSNumber
                    let uid = dictionary["userUid"] as! String
                    let viewCount = dictionary["viewCount"] as! NSNumber
                    let type = dictionary["type"] as! String
                    
                    let structure = MapPoints(Latitude: lat, Longitude: long, Image: image, Text: text, User: user, PostCity: address, Time: time, userUID: uid, ViewCount: viewCount, Type: type)
                    if self.userPosts.contains(where: {$0.time == structure.time}){
                    } else {
                        self.userPosts.append(structure)
                        let formatter = NumberFormatter()
                        formatter.minimumFractionDigits = 0
                        formatter.maximumFractionDigits = 2
                     
                        let totalAmount = self.totalViewCount + (structure.viewCount?.floatValue)!
                        self.totalViewCount = totalAmount
                        self.totalViewsLabel.text = formatter.string(for: totalAmount)
                    }
        
                    let postsCount = self.userPosts.count
                    let multiplication = postsCount * 335

                    self.userPosts.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                    
                    self.collectionView.contentSize.height = CGFloat(multiplication)
                       self.topViewHolder.backgroundColor = UIColor.white
                    self.totalPostsLabel.text = String(self.userPosts.count)
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false) //repeats was false
                    self.refreshControl.endRefreshing()
                    if self.userPosts.count == 0 {
                        self.noPostsToShow.isHidden = false
                    } else {
                        self.noPostsToShow.isHidden = true
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
        
        }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MessageCell
        cell.backgroundColor = UIColor.clear
        cell.activityIndicator.frame.size.width = self.viewForCell.frame.width / 2
        cell.activityIndicator.frame.size.height = self.viewForCell.frame.height / 2
        
        let posts = userPosts[indexPath.row]
        cell.postedImage.loadImageUsingCachWithUrlString(urlString: posts.image!, activityIndicator: cell.activityIndicator)
        
        return cell
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
  performSegue(withIdentifier: "openPost", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPost"{
            let indexPath = collectionView.indexPathsForSelectedItems?.last
            let selectedInformation: MapPoints
            
            selectedInformation = userPosts[(indexPath?.row)!]
        
            let viewController = segue.destination as! openingPostViewController
            viewController.selectedInformation = selectedInformation
            }
        if segue.identifier == "logOutSegue"{
            let defaults = UserDefaults(suiteName: "group.username.SuitName")!
            
            defaults.removeObject(forKey: "FAuthDataToken")
            defaults.removeObject(forKey: "email")
            defaults.removeObject(forKey: "password")
            defaults.synchronize()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewForCell.frame.width, height: viewForCell.frame.height)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // 5 5 5 5
        //0 15
        return UIEdgeInsets(top: 0, left: spacingView.frame.width / 2, bottom: 0, right: spacingView.frame.width / 2) //16
    }
    
    func refreshProfile(){
        self.userPosts.removeAll()
        self.collectionView.reloadData()
        
        observeUserPosts()
    }
    override func viewDidLayoutSubviews() {
        let viewController = self.parent as? tabBarViewController
        let tabBarHeight = viewController?.tabBarView.frame.height
        
        let contentSize = self.aboutMeBio.sizeThatFits(self.aboutMeBio.bounds.size)
        var frame = self.aboutMeBio.frame
        frame.size.height = contentSize.height
        self.aboutMeBio.frame = frame
        self.aboutMeBio.isScrollEnabled = false
    
        self.mainScroll.delegate = self
        self.mainScroll.contentSize.height = self.aboutMeBio.frame.origin.y + self.aboutMeBio.frame.height + tabBarHeight!
    }
    func observeRemovedPosts(){
        
        let ref = Database.database().reference().child("HistoryOfPosts").child("post")
        // to limit it use this ref.queryLimited(toLast: 6)
        ref.queryOrdered(byChild: "post").observe(.childRemoved, with: {(snapshot) in
            self.refreshProfile()
            
        }, withCancel: nil)
    }
    func loadTheView(){
let uid = Auth.auth().currentUser?.uid
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                print("iPhone 4 or 4S")
                
            
                viewForCell.frame.size.width = 71
                
                circleProfilePicture.frame.size.height = 135
             
            case 1136:
                print("iPhone 5 or 5S or 5c")
            case 1334:
                print("iPhone 6 or 6s")
            case 2208:
                print("iPhone 6+ or 6S+")
            case 2436:
                print("it is the iPhone X")
               //make status bar hidden
               // View for cell 84 100
                
                circleProfilePicture.frame.size.height = 159
                viewForCell.frame.size.height = 83
                topViewHolder.frame.size.height = 69
               //add 5
                editProfile.frame.origin.y = 35
                logOutButton.frame.origin.y = 35
                dismissButton.frame.origin.y = 20
                mainScroll.contentSize.height = 1000
                aboutMeBio.frame.origin.y = 850
            default:
                print("unknown")
            }
        }
        

        
        dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        let viewController = self.parent as! tabBarViewController
        viewController.statusBarShouldBeHidden = false
        viewController.setNeedsStatusBarAppearanceUpdate()
        
    
     
       self.refreshControl = UIRefreshControl()
     //   refreshControl.attributedTitle = NSAttributedString(string: "Pull down to refresh")
      
        refreshControl.addTarget(self, action: #selector(refreshProfile), for: .valueChanged)
        self.mainScroll.addSubview(refreshControl)
        
        
        
        
        observeUserPosts()
        observeRemovedPosts()
        
        self.circleProfilePicture.clipsToBounds = true;
        self.circleProfilePicture.contentMode = .scaleToFill
        self.circleProfilePicture.layer.cornerRadius = circleProfilePicture.frame.size.width / 2;
        
        editProfile.addTarget(self, action: #selector(editProfileFunction), for: .touchUpInside)
        editProfile.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let border = CALayer()
        
        let width = CGFloat(1.0)
        
        let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        
        border.borderColor = blackColor.cgColor
        border.frame = CGRect(x: 0, y: badgesBorder.frame.size.height - width, width:  badgesBorder.frame.size.width, height: badgesBorder.frame.size.height)
        border.borderWidth = width
        border.opacity = 0.7
        badgesBorder.layer.addSublayer(border)
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true

        noPostsToShow.isHidden = true
        
        
        Database.database().reference().child("Users").child(uid!).observe(.value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                self.userName.text = dictionary["username"] as? String
                
                
                self.circleProfilePicture.loadImageUsingCachWithUrlString(urlString: dictionary["profileImageUrl"] as! String, activityIndicator: self.activityIndicator)
              
                self.aboutMeBio.text = dictionary["aboutMe"] as? String
                self.userCity.text = dictionary["userCity"] as? String
                self.view.setNeedsLayout()
            }
        } , withCancel: nil)
    }
}
