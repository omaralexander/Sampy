//
//  selectedUserProfile.swift
//  Sampy
//
//  Created by Omar Abbas on 7/5/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class selectedUserProfile: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    var user:MapPoints?
 
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var aboutMeProfile: UITextView!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var flagIcon: UIImageView!
    @IBOutlet weak var mainScroll: UIScrollView!
    @IBOutlet weak var usersCity: UILabel!
    
    @IBOutlet weak var badgesBorder: UITextField!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
   
    @IBOutlet weak var reportAccountButton: UIButton!
    @IBOutlet weak var topViewHolder: UIView!
    @IBOutlet weak var totalViewsLabel: UILabel!
    @IBOutlet weak var totalPostsLabel: UILabel!
    @IBOutlet weak var viewForCell: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var spacingView: UIView!
    
    @IBOutlet weak var noPostsToShow: UILabel!
    override var prefersStatusBarHidden: Bool{
        return false
    }
    var userPosts = [MapPoints]()
    var totalViewCount: Float = 0
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.child("profileImageUrl").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() == false{
                let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                let bc: UIViewController = storyboard.instantiateViewController(withIdentifier: "appStartViewController")
                self.present(bc, animated: true, completion: nil)
       
                
            }
        })
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 960:
                print("iPhone 4 or 4S")
                print(profilePicture.frame)
                profilePicture.frame.size.width = 103
            case 2436:
                print("it is the iPhone X")
               
                profilePicture.frame.size.height = 150 //159
                profilePicture.frame.size.width = 145
                viewForCell.frame.size.height = 83
                topViewHolder.frame.size.height = 69
                imageButton.frame.origin.y = 35
                flagIcon.frame.origin.y = 32
                reportAccountButton.frame.origin.y = 26
                dismissButton.frame.origin.y = 35

                aboutMeProfile.frame.origin.y = 850
              
            default:
                print("unknown")
            }
        }

        self.profilePicture.clipsToBounds = true;
        self.profilePicture.contentMode = .scaleToFill
        self.profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2;
        self.profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
        let border = CALayer()
        
        let width = CGFloat(1.0)
        
        let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        
        border.borderColor = blackColor.cgColor
        border.frame = CGRect(x: 0, y: badgesBorder.frame.size.height - width, width:  badgesBorder.frame.size.width, height: badgesBorder.frame.size.height)
        border.borderWidth = width
        
        badgesBorder.layer.addSublayer(border)
        noPostsToShow.isHidden = true
    
        
       collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        
        self.refreshControl = UIRefreshControl()
        //   refreshControl.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        
        refreshControl.addTarget(self, action: #selector(refreshProfile), for: .valueChanged)
        self.mainScroll.addSubview(refreshControl)
        
        observeUserPosts()
        
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        let usersUID = user?.userUid
       let usersRef = Database.database().reference().child("Users").child(usersUID!)
        usersRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let profileImage = dictionary["profileImageUrl"] as! String
                let aboutMe = dictionary["aboutMe"] as? String
                let usersname = dictionary["username"] as? String
                let userCity = dictionary["userCity"] as? String
                
                self.profilePicture.loadImageUsingCachWithUrlString(urlString: profileImage, activityIndicator: self.activityIndicator)
                self.userName.text = usersname
                self.aboutMeProfile.text = aboutMe
                self.usersCity.text = userCity
            }
        })
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
    var timer: Timer?
    func handleReloadTable(){
        self.collectionView.reloadData()
    }
    func refreshProfile(){
        
        observeUserPosts()
   
        
    }
    

    func observeUserPosts(){
        self.totalViewCount = 0
        self.userPosts.removeAll()
        self.topViewHolder.backgroundColor = UIColor.clear
        
        guard let uid = user?.userUid else{
            return
        }
        let ref = Database.database().reference().child("user-history-posts").child(uid)
        //queryLimited(toLast: 8)
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
        if userPosts.count == 0 {
            noPostsToShow.isHidden = false
        }
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
        Answers.logCustomEvent(withName: "user selected sample within other users profile. Activity inside selectedProfileViewController", customAttributes: [:])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reportSegue"{
            let viewController = segue.destination as? reportAccountViewController
            viewController?.userID = (user?.userUid)!
        }
        if segue.identifier == "openPost"{
            let indexPath = collectionView.indexPathsForSelectedItems?.last
            let selectedInformation: MapPoints
            
            selectedInformation = userPosts[(indexPath?.row)!]
            
            let viewController = segue.destination as! openingPostViewController
            viewController.selectedInformation = selectedInformation
        }
    }
    override func viewDidLayoutSubviews() {
        let contentSize = self.aboutMeProfile.sizeThatFits(self.aboutMeProfile.bounds.size)
        var frame = self.aboutMeProfile.frame
        frame.size.height = contentSize.height
        self.aboutMeProfile.frame = frame
        self.aboutMeProfile.isScrollEnabled = false
        
        self.mainScroll.delegate = self
        self.mainScroll.contentSize.height = self.aboutMeProfile.frame.origin.y + self.aboutMeProfile.frame.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewForCell.frame.width, height: viewForCell.frame.height )
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: spacingView.frame.width / 2, bottom: 0, right: spacingView.frame.width / 2)
    }
    func dismissView(){
        dismiss(animated: true, completion: nil)
    }
}
