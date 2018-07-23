//
//  MessagesViewController.swift
//  sampyiMessage
//
//  Created by Omar Abbas on 11/16/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Messages
import NVActivityIndicatorView
import Firebase

@available(iOS 10.0, *)
class MessagesViewController: MSMessagesAppViewController {

    @IBOutlet weak var containerView: UIView!
}
class compactCollectionViewCell: UICollectionViewCell{
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(frame: CGRect){
        super.init(frame: frame)
            addSubview(image)
        
        image.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        image.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        image.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}








class cellForCollectionViews: UICollectionViewCell{
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let text: UILabel = {
        let label = UILabel()
        let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Demibold", size: 13)
        label.textColor = blackColor
      //  label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    let viewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(image)
        addSubview(text)
        
        
        image.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        image.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        image.bottomAnchor.constraint(equalTo: text.topAnchor, constant: 0).isActive = true
       // image.heightAnchor.constraint(equalToConstant: self.frame.height / 2).isActive = true
        
        text.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        text.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        text.heightAnchor.constraint(equalToConstant: self.frame.height / 3).isActive = true
     //   text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 0).isActive = true
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}

class newCellForCollectionView: UICollectionViewCell{
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
      //  imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let text: UILabel = {
        let label = UILabel()
        let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Demibold", size: 13)
        label.textColor = blackColor
        //  label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    let view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0.9
        return view
    }()
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(image)
        addSubview(view)
        addSubview(text)
       
        
        
        image.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        image.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
      //  image.bottomAnchor.constraint(equalTo: text.topAnchor, constant: 0).isActive = true
         image.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: self.frame.height/3).isActive = true
        
        
        text.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        text.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        text.heightAnchor.constraint(equalToConstant: self.frame.height / 3).isActive = true
        //   text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 0).isActive = true
        
      
        
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}



























@available(iOS 10.0, *)
class CompactViewController: MSMessagesAppViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var userPostsButton: UIButton!
    @IBOutlet weak var companyPostsButton: UIButton!
    @IBOutlet weak var viewForCell: UIView!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    @IBOutlet weak var yourPostsButton: UIButton!
    @IBOutlet weak var greenBorder: UITextField!
    
    @IBOutlet var notLoggedInView: UIView!
    @IBOutlet weak var backToAppButton: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var containerView: UIView!
    let Cell = "Cell"
    var foodArray = [MapPoints]()
    var effect: UIVisualEffect!
    
    var companyPostButtonSelected = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.effect = self.visualEffectView.effect
        self.visualEffectView.effect = nil
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
  
        self.containerView.isUserInteractionEnabled = false
        foodCollectionView.register(compactCollectionViewCell.self, forCellWithReuseIdentifier: Cell)
       
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.alwaysBounceVertical = true
        
        foodArray.removeAll()
       
        
        foodCollectionView.reloadData()
        foodCollectionView.frame.size.width = UIScreen.main.bounds.width
        let width = CGFloat(1.5) //1.5
        let borderForButtons = CALayer()
        let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
        
        borderForButtons.borderColor = greenColor.cgColor
        borderForButtons.frame = CGRect(x: 0, y: greenBorder.frame.size.height - width, width:  greenBorder.frame.size.width, height: greenBorder.frame.size.height)
        borderForButtons.borderWidth = width
        borderForButtons.opacity = 0.7
        greenBorder.layer.masksToBounds = true
        greenBorder.layer.addSublayer(borderForButtons)
        
        userPostsButton.addTarget(self, action: #selector(userPostsFuction), for: .touchUpInside)
        companyPostsButton.addTarget(self, action: #selector(companyPostsFunction), for: .touchUpInside)
        yourPostsButton.addTarget(self, action: #selector(yourPostsFunction), for: .touchUpInside)
        
        
        yourPostsButton.setTitleColor(greenColor, for: .normal)
        self.greenBorder.center.x = self.yourPostsButton.center.x

        observeUserPosts()
        handleReloadTable()
        foodCollectionView.backgroundColor = UIColor.blue
        
    }

    var timer: Timer?
    func handleReloadTable(){
        self.foodCollectionView.reloadData()
    }
    func observeUserPosts(){
        self.foodArray.removeAll()
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
                    self.foodArray.append(structure)
            
                    self.foodArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                    
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false) //repeats was false
                   
                }
            }, withCancel: nil)
        }, withCancel: nil)
        
    }
    
    func userPostsFuction(){
   
        self.companyPostButtonSelected = false
        print("inside of userPostsfunction \(self.companyPostButtonSelected)")
        self.requestPresentationStyle(MSMessagesAppPresentationStyle.expanded)
    }
    func companyPostsFunction(){
      
        self.companyPostButtonSelected = true
        print("inside companypostsfunction \(self.companyPostButtonSelected)")
        self.requestPresentationStyle(MSMessagesAppPresentationStyle.expanded)
    }
    func yourPostsFunction(){

        UIView.animate(withDuration: 0.35){
            
            //  self.containerView.isHidden = false
            let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
            let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
            
            self.companyPostsButton.setTitleColor(blackColor, for: .normal)
            self.userPostsButton.setTitleColor(blackColor, for: .normal)
            self.yourPostsButton.setTitleColor(greenColor, for: .normal)
            
            self.greenBorder.center.x = self.yourPostsButton.center.x
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodArray.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width / 4.25
        collectionViewSize.height = collectionViewSize.height / 7
        
        return collectionViewSize
        
        //  return CGSize(width: viewForCell.frame.width, height: viewForCell.frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // 5 5 5 5
        //0 15
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) //16
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! compactCollectionViewCell
        
        
        if collectionView == self.foodCollectionView{
            cell.backgroundColor = UIColor.clear
            let postInformation: MapPoints
            
            postInformation = foodArray[indexPath.row]
            if postInformation.text == "test"{
                cell.isUserInteractionEnabled = false
                cell.image.image = UIImage(named:"noPostToShow")
              
            } else {
                let color = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
                let frame = CGRect(x: cell.image.center.x, y: cell.image.center.y, width: cell.image.frame.width / 3, height: cell.image.frame.height / 3)
                let activityIndicator = NVActivityIndicatorView(frame: frame)
                activityIndicator.type = .ballRotateChase
                activityIndicator.color = color
                cell.isUserInteractionEnabled = true
                cell.image.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: activityIndicator)
            }
        }
     
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.foodCollectionView {
            performSegue(withIdentifier: "openPost", sender: self)
        }
    }
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        super.willBecomeActive(with: conversation)
        print("the view became active")
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        if Auth.auth().currentUser?.email == nil{
            logUserIn()
        }
    }
        func noAccountAnimateIn(){
            self.view.addSubview(notLoggedInView)
            notLoggedInView.center = self.view.center
            notLoggedInView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            notLoggedInView.alpha = 0
            UIView.animate(withDuration: 0.4){
                self.visualEffectView.effect = self.effect
                self.notLoggedInView.alpha = 1
                self.notLoggedInView.transform = CGAffineTransform.identity
            }
        }
    func noAccountAnimateOut(){
        UIView.animate(withDuration: 0.4, animations:{
            self.notLoggedInView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.notLoggedInView.alpha = 0
            self.visualEffectView.effect = nil
        }){(success:Bool) in
            self.notLoggedInView.removeFromSuperview()
        }
    }
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        
        // Use this method to prepare for the change in presentation style.
        guard let conversation = activeConversation else {
            fatalError("Expected the active conversation")
        }
        
        presentVC(for: conversation, with: presentationStyle)

    }
    func logUserIn(){
        let defaults = UserDefaults(suiteName: "group.username.SuitName")!
        // Grab the auth token
        //let authToken = defaults.string(forKey: "FAuthDataToken")! as AuthCredential
        
        let authToken = defaults.object(forKey: "FAuthDataToken") as! String
        let email = defaults.object(forKey: "email") as! String
        let password = defaults.object(forKey: "password") as? String
        // Authenticate with the token from the NSUserDefaults object
        print("this is the auth token \(authToken)")
        // let credential:AuthCredential = UserDefaults(suiteName: "group.username.SuitName")! as AuthCredential
        
        if password != nil {
            
            // Auth.auth().signIn(with: authToken, completion: { (user, error) in
            Auth.auth().signIn(withEmail: email, password: password!, completion: { (user, error) in
                
                //     Auth.auth().signIn(withCustomToken: authToken, completion: { (user, error) in
                
                if user != nil {
                    print("Authenticated inside of the iMessage App!")
                    print(user?.displayName, user?.email)
                    self.noAccountAnimateOut()
                } else {
                    print("Not authenticated")
                    print(error?.localizedDescription)
                    self.noAccountAnimateIn()
                }})
        } else{
            self.noAccountAnimateIn()
        }
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
    
    private func presentVC(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        let controller: UIViewController
        
        if presentationStyle == .compact {
            controller = instantiateCompactVC()
        } else {
            controller = instantiateExpandedVC()
        }
        
        addChildViewController(controller)
        
        // ...constraints and view setup...
        
        // containerView.frame = UIScreen.main.bounds
    
        controller.view.frame = containerView.bounds
        containerView.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    private func instantiateCompactVC() -> UIViewController {
        guard let compactVC = storyboard?.instantiateViewController(withIdentifier: "CompactVC") as? CompactViewController else {
            fatalError("Can't instantiate CompactViewController")
        }
        self.containerView.isUserInteractionEnabled = true
        return compactVC
    }
    
    private func instantiateExpandedVC() -> UIViewController {
        guard let expandedVC = storyboard?.instantiateViewController(withIdentifier: "ExpandedVC") as? ExpandedViewController else {
            fatalError("Can't instantiate ExpandedViewController")
        }
        print("before the transition \(self.companyPostButtonSelected)")
        self.containerView.isUserInteractionEnabled = true
        expandedVC.companyPostButtonSelected = self.companyPostButtonSelected
        expandedVC.userPosts = foodArray
        return expandedVC
            }
        }





































class ExpandedViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userPostsButton: UIButton!
    @IBOutlet weak var companyPostsButton: UIButton!
    @IBOutlet weak var yourPostsButton: UIButton!
    
    @IBOutlet weak var viewForCell: UIView!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var activityCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var clothesAndSalesCollectionView: UICollectionView!
    
    @IBOutlet weak var clothesLabel: UILabel!
    @IBOutlet weak var productsLabel: UILabel!
    @IBOutlet weak var activitesLabel: UILabel!
    
    @IBOutlet weak var greenBorder: UITextField!
    
    @IBOutlet weak var containerForUserPosts: UIView!
    @IBOutlet weak var containerForCompanyPosts: UIView!
    
    let Cell = "Cell"
    var foodArray = [MapPoints]()
    var activityArray = [MapPoints]()
    var productArray = [MapPoints]()
    var clothesandSalesArray = [MapPoints]()
    
    
    var selectedCollectionView = Int()
    var companyPostButtonSelected = Bool()
    
    var userPosts = [MapPoints]()
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        // Do any additional setup after loading the view.
        
        foodCollectionView.isScrollEnabled = false
        activityCollectionView.isScrollEnabled = false
        productCollectionView.isScrollEnabled = false
        clothesAndSalesCollectionView.isScrollEnabled = false
        
        foodCollectionView.register(cellForCollectionViews.self, forCellWithReuseIdentifier: Cell)
        activityCollectionView.register(cellForCollectionViews.self, forCellWithReuseIdentifier: Cell)
        productCollectionView.register(cellForCollectionViews.self, forCellWithReuseIdentifier: Cell)
        clothesAndSalesCollectionView.register(cellForCollectionViews.self, forCellWithReuseIdentifier: Cell)
        
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        clothesAndSalesCollectionView.delegate = self
        clothesAndSalesCollectionView.dataSource = self
        
        foodCollectionView.tag = 1
        activityCollectionView.tag = 2
        productCollectionView.tag = 3
        clothesAndSalesCollectionView.tag = 4
        
        foodArray.removeAll()
        activityArray.removeAll()
        productArray.removeAll()
        clothesandSalesArray.removeAll()
        
        foodCollectionView.reloadData()
        activityCollectionView.reloadData()
        productCollectionView.reloadData()
        clothesAndSalesCollectionView.reloadData()
        
        
        self.scrollView.contentSize.height = clothesAndSalesCollectionView.frame.height * 1.5 + clothesAndSalesCollectionView.frame.origin.y
        
   
        
        let width = CGFloat(1.5) //1.5
        let borderForButtons = CALayer()
        let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
        
        borderForButtons.borderColor = greenColor.cgColor
        borderForButtons.frame = CGRect(x: 0, y: greenBorder.frame.size.height - width, width:  greenBorder.frame.size.width, height: greenBorder.frame.size.height)
        borderForButtons.borderWidth = width
        borderForButtons.opacity = 0.7
        greenBorder.layer.masksToBounds = true
        greenBorder.layer.addSublayer(borderForButtons)
        
  activityCollectionView.frame.origin.y = foodCollectionView.frame.height + foodCollectionView.frame.origin.y + 8
  productCollectionView.frame.origin.y = activityCollectionView.frame.height + activityCollectionView.frame.origin.y + 8
 clothesAndSalesCollectionView.frame.origin.y = productCollectionView.frame.height + productCollectionView.frame.origin.y + 8
    
    activitesLabel.frame.origin.y = activityCollectionView.frame.origin.y - activitesLabel.frame.height - 2
    productsLabel.frame.origin.y = productCollectionView.frame.origin.y - productsLabel.frame.height - 2
    clothesLabel.frame.origin.y = clothesAndSalesCollectionView.frame.origin.y - clothesLabel.frame.height - 2

        userPostsButton.addTarget(self, action: #selector(userPostsFuction), for: .touchUpInside)
        companyPostsButton.addTarget(self, action: #selector(companyPostsFunction), for: .touchUpInside)
        yourPostsButton.addTarget(self, action: #selector(yourPostsFunction), for: .touchUpInside)
        
        print("In the view did load",companyPostButtonSelected)
        if companyPostButtonSelected == true{
            companyPostsButton.setTitleColor(greenColor, for: .normal)
            self.greenBorder.center.x = self.companyPostsButton.center.x
            self.containerForCompanyPosts.frame.origin.x = 0
            self.containerForUserPosts.frame.origin.x = UIScreen.main.bounds.width + 500
        }
        if companyPostButtonSelected == false{
        userPostsButton.setTitleColor(greenColor, for: .normal)
        self.greenBorder.center.x = self.userPostsButton.center.x
        self.containerForCompanyPosts.frame.origin.x = UIScreen.main.bounds.width + 500
        self.containerForUserPosts.frame.origin.x = UIScreen.main.bounds.width + 500
        }
        fetchUser()
        observeRemovedPosts()
    }
    func observeRemovedPosts(){
        
        let ref = Database.database().reference().child("SamplePost").child("post")
        // to limit it use this ref.queryLimited(toLast: 6)
        ref.queryOrdered(byChild: "post").observe(.childRemoved, with: {(snapshot) in
            self.refreshProfile()
            
        }, withCancel: nil)
    }
    func refreshProfile(){
        foodArray.removeAll()
        productArray.removeAll()
        activityArray.removeAll()
        clothesandSalesArray.removeAll()
        
        foodCollectionView.reloadData()
        activityCollectionView.reloadData()
        productCollectionView.reloadData()
        clothesAndSalesCollectionView.reloadData()
        
        fetchUser()
    }
    var timer: Timer?
    func handleReloadTable(){
        self.foodCollectionView.reloadData()
        self.activityCollectionView.reloadData()
        self.productCollectionView.reloadData()
        self.clothesAndSalesCollectionView.reloadData()
    }
    func fetchUser(){
        foodCollectionView.reloadData()
        activityCollectionView.reloadData()
        productCollectionView.reloadData()
        clothesAndSalesCollectionView.reloadData()
        let ref = Database.database().reference().child("SamplePost").child("post")
        // to limit it use this ref.queryLimited(toLast: 6)
        ref.queryOrdered(byChild: "post").observe(.childAdded, with: {(snapshot) in
            
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
                
                if structure.type == "Food"{
                    self.foodArray.append(structure)
                    self.foodArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                
                if structure.type == "Activity"{
                    self.activityArray.append(structure)
                    self.activityArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                
                if structure.type == "Product"{
                    self.productArray.append(structure)
                    self.productArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                
                if structure.type == "Clothing"{
                    self.clothesandSalesArray.append(structure)
                    self.clothesandSalesArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                //  self.refreshControl.endRefreshing()
            }
        }, withCancel: nil)
    }
    func userPostsFuction(){
        UIView.animate(withDuration: 0.35){
            let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
            let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)

            self.containerForCompanyPosts.frame.origin.x = UIScreen.main.bounds.width + 500
            self.containerForUserPosts.frame.origin.x = UIScreen.main.bounds.width + 500
            
            self.userPostsButton.setTitleColor(greenColor, for: .normal)
            self.companyPostsButton.setTitleColor(blackColor, for: .normal)
            self.yourPostsButton.setTitleColor(blackColor, for: .normal)
            
            self.greenBorder.center.x = self.userPostsButton.center.x
            
        }
    }
    func companyPostsFunction(){
        UIView.animate(withDuration: 0.35){
            
     
            let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
            let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
            
            self.containerForCompanyPosts.frame.origin.x = 0
            self.containerForUserPosts.frame.origin.x = UIScreen.main.bounds.width + 500
            
            self.companyPostsButton.setTitleColor(greenColor, for: .normal)
            self.userPostsButton.setTitleColor(blackColor, for: .normal)
            self.yourPostsButton.setTitleColor(blackColor, for: .normal)
            
            self.greenBorder.center.x = self.companyPostsButton.center.x
        }
    }
    func yourPostsFunction(){
        UIView.animate(withDuration: 0.35){
            
            //  self.containerView.isHidden = false
            let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
            let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
            
            self.containerForCompanyPosts.frame.origin.x = UIScreen.main.bounds.width + 500
            self.containerForUserPosts.frame.origin.x = 0
            
            self.companyPostsButton.setTitleColor(blackColor, for: .normal)
            self.userPostsButton.setTitleColor(blackColor, for: .normal)
            self.yourPostsButton.setTitleColor(greenColor, for: .normal)
            self.greenBorder.center.x = self.yourPostsButton.center.x
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count:Int?
        if collectionView == self.foodCollectionView {
            if foodArray.count < 6 {
                let amount = 6-foodArray.count
                count = increaseArray(increaseAmountBy: amount)
            }
            count = foodArray.count
        }
        if collectionView == self.activityCollectionView {
            if activityArray.count < 6 {
                let amount = 6-activityArray.count
                count = increaseActivityArray(increaseAmountBy: amount)
            }
            count = activityArray.count
        }
        if collectionView == self.productCollectionView{
            if productArray.count < 6 {
                let amount = 6-productArray.count
                count = increaseProductArray(increaseAmountBy: amount)
            }
            count = productArray.count
        }
        if collectionView == self.clothesAndSalesCollectionView{
            if clothesandSalesArray.count < 6 {
                let amount = 6-clothesandSalesArray.count
                count = increaseClothesAndSalesArray(increaseAmountBy: amount)
            }
            count = clothesandSalesArray.count
        }
        return count!
    }
    override func viewDidAppear(_ animated: Bool) {
         print("in view did appear",companyPostButtonSelected)
    }
    
    func increaseArray(increaseAmountBy: Int ) -> Int{
        let emptyStructure = MapPoints(Latitude: 0, Longitude: 0, Image: "test", Text: "test", User: "test", PostCity: "test", Time: 0, userUID: "test", ViewCount: 0, Type: "test")
        for _ in 0..<(increaseAmountBy){
            
            foodArray.append(emptyStructure)
            
        }
        return foodArray.count
    }
    func increaseActivityArray(increaseAmountBy: Int ) -> Int{
        let emptyStructure = MapPoints(Latitude: 0, Longitude: 0, Image: "test", Text: "test", User: "test", PostCity: "test", Time: 0, userUID: "test", ViewCount: 0, Type: "test")
        for _ in 0..<(increaseAmountBy){
            
            activityArray.append(emptyStructure)
            
        }
        return activityArray.count
    }
    func increaseProductArray(increaseAmountBy: Int ) -> Int{
        let emptyStructure = MapPoints(Latitude: 0, Longitude: 0, Image: "test", Text: "test", User: "test", PostCity: "test", Time: 0, userUID: "test", ViewCount: 0, Type: "test")
        for _ in 0..<(increaseAmountBy){
            
            productArray.append(emptyStructure)
            
        }
        return productArray.count
    }
    func increaseClothesAndSalesArray(increaseAmountBy: Int ) -> Int{
        let emptyStructure = MapPoints(Latitude: 0, Longitude: 0, Image: "test", Text: "test", User: "test", PostCity: "test", Time: 0, userUID: "test", ViewCount: 0, Type: "test")
        for _ in 0..<(increaseAmountBy){
            
            clothesandSalesArray.append(emptyStructure)
            
        }
        return clothesandSalesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        return CGSize(width: viewForCell.frame.width, height: viewForCell.frame.height )
    
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! cellForCollectionViews
        
        
        if collectionView == self.foodCollectionView{
            cell.backgroundColor = UIColor.clear
            let postInformation: MapPoints
            
            postInformation = foodArray[indexPath.row]
            if postInformation.text == "test"{
                cell.isUserInteractionEnabled = false
                cell.image.image = UIImage(named:"noPostToShow")
                cell.text.text = "No post yet, but come back soon!"
            } else {
                let color = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
                let frame = CGRect(x: cell.image.center.x, y: cell.image.center.y, width: cell.image.frame.width / 3, height: cell.image.frame.height / 3)
                let activityIndicator = NVActivityIndicatorView(frame: frame)
                activityIndicator.type = .ballRotateChase
                activityIndicator.color = color
                cell.isUserInteractionEnabled = true
                cell.text.text = postInformation.text
                cell.image.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: activityIndicator)
            }
        }
        if collectionView == self.activityCollectionView{
            cell.backgroundColor = UIColor.clear
            let postInformation: MapPoints
            
            postInformation = activityArray[indexPath.row]
            if postInformation.text == "test" {
                cell.isUserInteractionEnabled = false
                cell.image.image = UIImage(named:"noPostToShow")
                
                cell.text.text = "No post yet, but come back soon!"
                
            }else{
                let color = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
                let frame = CGRect(x: cell.image.center.x, y: cell.image.center.y, width: cell.image.frame.width / 3, height: cell.image.frame.height / 3)
                let activityIndicator = NVActivityIndicatorView(frame: frame)
                activityIndicator.type = .ballRotateChase
                activityIndicator.color = color
                cell.isUserInteractionEnabled = true
                cell.text.text = postInformation.text
                cell.image.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: activityIndicator)
                
            }
        }
        if collectionView == self.productCollectionView{
            cell.backgroundColor = UIColor.clear
            let postInformation: MapPoints
            postInformation = productArray[indexPath.row]
            if postInformation.text == "test"{
                cell.isUserInteractionEnabled = false
                cell.image.image = UIImage(named:"noPostToShow")
                
                cell.text.text = "No post yet, but come back soon!"
                
            }else{
                let color = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
                let frame = CGRect(x: cell.image.center.x, y: cell.image.center.y, width: cell.image.frame.width / 3, height: cell.image.frame.height / 3)
                let activityIndicator = NVActivityIndicatorView(frame: frame)
                activityIndicator.type = .ballRotateChase
                activityIndicator.color = color
                cell.isUserInteractionEnabled = true
                cell.text.text = postInformation.text
                cell.image.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: activityIndicator)
                
            }
        }
        if collectionView == self.clothesAndSalesCollectionView{
            cell.backgroundColor = UIColor.clear
            let postInformation: MapPoints
            postInformation = clothesandSalesArray[indexPath.row]
            if postInformation.text == "test"{
                cell.isUserInteractionEnabled = false
                cell.image.image = UIImage(named:"noPostToShow")
                cell.text.text =  "No post yet, but come back soon!"
                
            }else{
                let color = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
                let frame = CGRect(x: cell.image.center.x, y: cell.image.center.y, width: cell.image.frame.width / 3, height: cell.image.frame.height / 3)
                let activityIndicator = NVActivityIndicatorView(frame: frame)
                activityIndicator.type = .ballRotateChase
                activityIndicator.color = color
                cell.isUserInteractionEnabled = true
                cell.text.text = postInformation.text
                cell.image.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: activityIndicator)
                
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.foodCollectionView {
            
            self.selectedCollectionView = foodCollectionView.tag
            
            performSegue(withIdentifier: "openPost", sender: self)
        }
        
        if collectionView == self.activityCollectionView {
            
            self.selectedCollectionView = activityCollectionView.tag
            
            performSegue(withIdentifier: "openPost", sender: self)
        }
        
        if collectionView == self.productCollectionView{
            
            self.selectedCollectionView = productCollectionView.tag
            
            performSegue(withIdentifier: "openPost", sender: self)
        }
        
        if collectionView == self.clothesAndSalesCollectionView{
            
            self.selectedCollectionView = clothesAndSalesCollectionView.tag
            
            performSegue(withIdentifier: "openPost", sender: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        //self.view.contentInset.top =
  self.view.frame.origin.y = self.topLayoutGuide.length - self.topLayoutGuide.length/3.9
        self.containerForUserPosts.frame = self.scrollView.frame
        self.containerForCompanyPosts.frame = self.scrollView.frame
   
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userPosts"{
            let viewController = segue.destination as! yourPostsViewController
            viewController.foodArray = self.userPosts
        }
    }
    
}















class CompanyViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewForCell: UIView!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var activityCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var clothesAndSalesCollectionView: UICollectionView!
    
    @IBOutlet weak var clothesLabel: UILabel!
    @IBOutlet weak var productsLabel: UILabel!
    @IBOutlet weak var activitesLabel: UILabel!
    
    
    let Cell = "Cell"
    var foodArray = [MapPoints]()
    var activityArray = [MapPoints]()
    var productArray = [MapPoints]()
    var clothesandSalesArray = [MapPoints]()
    
    
    var selectedCollectionView = Int()
    var companyPostButtonSelected = Bool()
    
    var userPosts = [MapPoints]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        foodCollectionView.isScrollEnabled = false
        activityCollectionView.isScrollEnabled = false
        productCollectionView.isScrollEnabled = false
        clothesAndSalesCollectionView.isScrollEnabled = false
        
        foodCollectionView.register(cellForCollectionViews.self, forCellWithReuseIdentifier: Cell)
        activityCollectionView.register(cellForCollectionViews.self, forCellWithReuseIdentifier: Cell)
        productCollectionView.register(cellForCollectionViews.self, forCellWithReuseIdentifier: Cell)
        clothesAndSalesCollectionView.register(cellForCollectionViews.self, forCellWithReuseIdentifier: Cell)
        
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        clothesAndSalesCollectionView.delegate = self
        clothesAndSalesCollectionView.dataSource = self
        
        foodCollectionView.tag = 1
        activityCollectionView.tag = 2
        productCollectionView.tag = 3
        clothesAndSalesCollectionView.tag = 4
        
        foodArray.removeAll()
        activityArray.removeAll()
        productArray.removeAll()
        clothesandSalesArray.removeAll()
        
        foodCollectionView.reloadData()
        activityCollectionView.reloadData()
        productCollectionView.reloadData()
        clothesAndSalesCollectionView.reloadData()
        
        
        self.scrollView.contentSize.height = clothesAndSalesCollectionView.frame.height * 1.5 + clothesAndSalesCollectionView.frame.origin.y
        
        activityCollectionView.frame.origin.y = foodCollectionView.frame.height + foodCollectionView.frame.origin.y + 8
        productCollectionView.frame.origin.y = activityCollectionView.frame.height + activityCollectionView.frame.origin.y + 8
        clothesAndSalesCollectionView.frame.origin.y = productCollectionView.frame.height + productCollectionView.frame.origin.y + 8
        
        activitesLabel.frame.origin.y = activityCollectionView.frame.origin.y - activitesLabel.frame.height - 2
        productsLabel.frame.origin.y = productCollectionView.frame.origin.y - productsLabel.frame.height - 2
        clothesLabel.frame.origin.y = clothesAndSalesCollectionView.frame.origin.y - clothesLabel.frame.height - 2
       fetchUser()
    }
    var timer: Timer?
    func handleReloadTable(){
        self.foodCollectionView.reloadData()
        self.activityCollectionView.reloadData()
        self.productCollectionView.reloadData()
        self.clothesAndSalesCollectionView.reloadData()
    }
    func fetchUser(){
        foodCollectionView.reloadData()
        activityCollectionView.reloadData()
        productCollectionView.reloadData()
        clothesAndSalesCollectionView.reloadData()
        let ref = Database.database().reference().child("PermaPost").child("post")
        //to limit the appended amount use this ref.queryLimited(toLast:6)
        ref.queryOrdered(byChild: "post").observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let lat = dictionary["lat"] as! Double
                let long = dictionary["long"] as! Double
                let image = dictionary["companyImage"] as! String
                let text = dictionary["description"] as! String
                let user = dictionary["companyName"] as! String
                let address = dictionary["location"] as! String
                let time = dictionary["time"] as! NSNumber
                let uid = dictionary["companyWebsite"] as! String
                let type = dictionary["type"] as! String
                let viewCount = 0 as NSNumber
                
                let structure = MapPoints(Latitude: lat, Longitude: long, Image: image, Text: text, User: user, PostCity: address, Time: time, userUID: uid, ViewCount: viewCount, Type: type)
                
                if structure.type == "Food"{
                    self.foodArray.append(structure)
                    self.foodArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                
                if structure.type == "Activity"{
                    self.activityArray.append(structure)
                    self.activityArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                
                if structure.type == "Product"{
                    self.productArray.append(structure)
                    self.productArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                
                if structure.type == "Clothing"{
                    self.clothesandSalesArray.append(structure)
                    self.clothesandSalesArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                // self.refreshControl.endRefreshing()
            }
            
        }, withCancel: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count:Int?
        if collectionView == self.foodCollectionView {
            if foodArray.count < 6 {
                let amount = 6-foodArray.count
                count = increaseArray(increaseAmountBy: amount)
            }
            count = foodArray.count
        }
        if collectionView == self.activityCollectionView {
            if activityArray.count < 6 {
                let amount = 6-activityArray.count
                count = increaseActivityArray(increaseAmountBy: amount)
            }
            count = activityArray.count
        }
        if collectionView == self.productCollectionView{
            if productArray.count < 6 {
                let amount = 6-productArray.count
                count = increaseProductArray(increaseAmountBy: amount)
            }
            count = productArray.count
        }
        if collectionView == self.clothesAndSalesCollectionView{
            if clothesandSalesArray.count < 6 {
                let amount = 6-clothesandSalesArray.count
                count = increaseClothesAndSalesArray(increaseAmountBy: amount)
            }
            count = clothesandSalesArray.count
        }
        return count!
    }
    override func viewDidAppear(_ animated: Bool) {
        print("in view did appear",companyPostButtonSelected)
    }
    
    func increaseArray(increaseAmountBy: Int ) -> Int{
        let emptyStructure = MapPoints(Latitude: 0, Longitude: 0, Image: "test", Text: "test", User: "test", PostCity: "test", Time: 0, userUID: "test", ViewCount: 0, Type: "test")
        for _ in 0..<(increaseAmountBy){
            
            foodArray.append(emptyStructure)
            
        }
        return foodArray.count
    }
    func increaseActivityArray(increaseAmountBy: Int ) -> Int{
        let emptyStructure = MapPoints(Latitude: 0, Longitude: 0, Image: "test", Text: "test", User: "test", PostCity: "test", Time: 0, userUID: "test", ViewCount: 0, Type: "test")
        for _ in 0..<(increaseAmountBy){
            
            activityArray.append(emptyStructure)
            
        }
        return activityArray.count
    }
    func increaseProductArray(increaseAmountBy: Int ) -> Int{
        let emptyStructure = MapPoints(Latitude: 0, Longitude: 0, Image: "test", Text: "test", User: "test", PostCity: "test", Time: 0, userUID: "test", ViewCount: 0, Type: "test")
        for _ in 0..<(increaseAmountBy){
            
            productArray.append(emptyStructure)
            
        }
        return productArray.count
    }
    func increaseClothesAndSalesArray(increaseAmountBy: Int ) -> Int{
        let emptyStructure = MapPoints(Latitude: 0, Longitude: 0, Image: "test", Text: "test", User: "test", PostCity: "test", Time: 0, userUID: "test", ViewCount: 0, Type: "test")
        for _ in 0..<(increaseAmountBy){
            
            clothesandSalesArray.append(emptyStructure)
            
        }
        return clothesandSalesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: viewForCell.frame.width, height: viewForCell.frame.height )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! cellForCollectionViews
        
        
        if collectionView == self.foodCollectionView{
            cell.backgroundColor = UIColor.clear
            let postInformation: MapPoints
            
            postInformation = foodArray[indexPath.row]
            if postInformation.text == "test"{
                cell.isUserInteractionEnabled = false
                cell.image.image = UIImage(named:"noPostToShow")
                cell.text.text = "No post yet, but come back soon!"
            } else {
                let color = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
                let frame = CGRect(x: cell.image.center.x, y: cell.image.center.y, width: cell.image.frame.width / 3, height: cell.image.frame.height / 3)
                let activityIndicator = NVActivityIndicatorView(frame: frame)
                activityIndicator.type = .ballRotateChase
                activityIndicator.color = color
                cell.isUserInteractionEnabled = true
                cell.text.text = postInformation.text
                cell.image.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: activityIndicator)
            }
        }
        if collectionView == self.activityCollectionView{
            cell.backgroundColor = UIColor.clear
            let postInformation: MapPoints
            
            postInformation = activityArray[indexPath.row]
            if postInformation.text == "test" {
                cell.isUserInteractionEnabled = false
                cell.image.image = UIImage(named:"noPostToShow")
                
                cell.text.text = "No post yet, but come back soon!"
                
            }else{
                let color = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
                let frame = CGRect(x: cell.image.center.x, y: cell.image.center.y, width: cell.image.frame.width / 3, height: cell.image.frame.height / 3)
                let activityIndicator = NVActivityIndicatorView(frame: frame)
                activityIndicator.type = .ballRotateChase
                activityIndicator.color = color
                cell.isUserInteractionEnabled = true
                cell.text.text = postInformation.text
                cell.image.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: activityIndicator)
                
            }
        }
        if collectionView == self.productCollectionView{
            cell.backgroundColor = UIColor.clear
            let postInformation: MapPoints
            postInformation = productArray[indexPath.row]
            if postInformation.text == "test"{
                cell.isUserInteractionEnabled = false
                cell.image.image = UIImage(named:"noPostToShow")
                
                cell.text.text = "No post yet, but come back soon!"
                
            }else{
                let color = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
                let frame = CGRect(x: cell.image.center.x, y: cell.image.center.y, width: cell.image.frame.width / 3, height: cell.image.frame.height / 3)
                let activityIndicator = NVActivityIndicatorView(frame: frame)
                activityIndicator.type = .ballRotateChase
                activityIndicator.color = color
                cell.isUserInteractionEnabled = true
                cell.text.text = postInformation.text
                cell.image.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: activityIndicator)
                
            }
        }
        if collectionView == self.clothesAndSalesCollectionView{
            cell.backgroundColor = UIColor.clear
            let postInformation: MapPoints
            postInformation = clothesandSalesArray[indexPath.row]
            if postInformation.text == "test"{
                cell.isUserInteractionEnabled = false
                cell.image.image = UIImage(named:"noPostToShow")
                cell.text.text =  "No post yet, but come back soon!"
                
            }else{
                let color = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
                let frame = CGRect(x: cell.image.center.x, y: cell.image.center.y, width: cell.image.frame.width / 3, height: cell.image.frame.height / 3)
                let activityIndicator = NVActivityIndicatorView(frame: frame)
                activityIndicator.type = .ballRotateChase
                activityIndicator.color = color
                cell.isUserInteractionEnabled = true
                cell.text.text = postInformation.text
                cell.image.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: activityIndicator)
                
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.foodCollectionView {
            
            self.selectedCollectionView = foodCollectionView.tag
            
            performSegue(withIdentifier: "openPost", sender: self)
        }
        
        if collectionView == self.activityCollectionView {
            
            self.selectedCollectionView = activityCollectionView.tag
            
            performSegue(withIdentifier: "openPost", sender: self)
        }
        
        if collectionView == self.productCollectionView{
            
            self.selectedCollectionView = productCollectionView.tag
            
            performSegue(withIdentifier: "openPost", sender: self)
        }
        
        if collectionView == self.clothesAndSalesCollectionView{
            
            self.selectedCollectionView = clothesAndSalesCollectionView.tag
            
            performSegue(withIdentifier: "openPost", sender: self)
        }
    }
}


















class yourPostsViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var foodCollectionView: UICollectionView!
    let Cell = "Cell"
    var foodArray = [MapPoints]()
    var companyPostButtonSelected = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        foodCollectionView.register(compactCollectionViewCell.self, forCellWithReuseIdentifier: Cell)
        
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.alwaysBounceVertical = true
        
        foodArray.removeAll()
        
        
        foodCollectionView.reloadData()
   
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return foodArray.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width / 4.25
        collectionViewSize.height = collectionViewSize.height / 2.5
        
        return collectionViewSize
        
        //  return CGSize(width: viewForCell.frame.width, height: viewForCell.frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // 5 5 5 5
        //0 15
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) //16
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! compactCollectionViewCell
        
        
        if collectionView == self.foodCollectionView{
            cell.backgroundColor = UIColor.clear
            let postInformation: MapPoints
            
            postInformation = foodArray[indexPath.row]
            if postInformation.text == "test"{
                cell.isUserInteractionEnabled = false
                cell.image.image = UIImage(named:"noPostToShow")
                
            } else {
                let color = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
                let frame = CGRect(x: cell.image.center.x, y: cell.image.center.y, width: cell.image.frame.width / 3, height: cell.image.frame.height / 3)
                let activityIndicator = NVActivityIndicatorView(frame: frame)
                activityIndicator.type = .ballRotateChase
                activityIndicator.color = color
                cell.isUserInteractionEnabled = true
                cell.image.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: activityIndicator)
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.foodCollectionView {
            performSegue(withIdentifier: "openPost", sender: self)
        }
    }
}


