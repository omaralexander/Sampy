//
//  newViewController.swift
//  sampyiMessage
//
//  Created by Omar Abbas on 11/19/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import CoreLocation
import Messages
import Firebase
import NVActivityIndicatorView

extension newViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchBar.text!)
    }
}



@available(iOS 10.0, *)
class newViewController: MSMessagesAppViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    @IBOutlet weak var userPostsButton: UIButton!
    @IBOutlet weak var companyPostsButton: UIButton!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    @IBOutlet weak var greenBorder: UITextField!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var notLoggedInView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backToAppButton: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!

    @IBOutlet weak var viewForCollectionView: UIView!
    let Cell = "Cell"
    var foodArray = [MapPoints]()
    var filteredArray = [MapPoints]()
    var effect: UIVisualEffect!
    var collectionViewSize = CGSize()
    var searchBarIsEditing = Bool()
    @IBAction func backToNewViewController(segue:UIStoryboardSegue){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.effect = self.visualEffectView.effect
        self.visualEffectView.effect = nil
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        containerView.frame.origin.x = UIScreen.main.bounds.width + 500
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.isScrollEnabled = true
        foodCollectionView.alwaysBounceVertical = true
        
       foodCollectionView.keyboardDismissMode = .onDrag
    foodCollectionView.register(newCellForCollectionView.self, forCellWithReuseIdentifier: Cell)
        let width = CGFloat(1.5) //1.5
        let borderForButtons = CALayer()
        let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
        
        userPostsButton.addTarget(self, action: #selector(userPostsFuction), for: .touchUpInside)
        companyPostsButton.addTarget(self, action: #selector(companyPostsFunction), for: .touchUpInside)
        searchBar.delegate = self
        searchBar.keyboardAppearance = .light
        
        borderForButtons.borderColor = greenColor.cgColor
        borderForButtons.frame = CGRect(x: 0, y: greenBorder.frame.size.height - width, width:  greenBorder.frame.size.width, height: greenBorder.frame.size.height)
        borderForButtons.borderWidth = width
        borderForButtons.opacity = 0.7
        greenBorder.layer.masksToBounds = true
        greenBorder.layer.addSublayer(borderForButtons)
        self.userPostsButton.setTitleColor(greenColor, for: .normal)
        self.backToAppButton.addTarget(self, action: #selector(goBackToAppfunction), for: .touchUpInside)
        foodArray.removeAll()
         observeUserPosts()
        
    }
    var timer: Timer?
    func handleReloadTable(){
        self.foodCollectionView.reloadData()
        
    }
    
    func userPostsFuction(){
        UIView.animate(withDuration: 0.35){
            
            self.containerView.frame.origin.x = UIScreen.main.bounds.width + 500
            let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
            let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
            
            self.companyPostsButton.setTitleColor(blackColor, for: .normal)
            self.userPostsButton.setTitleColor(greenColor, for: .normal)
         
            self.greenBorder.center.x = self.userPostsButton.center.x
        }
    }
    func companyPostsFunction(){
        UIView.animate(withDuration: 0.35){
            
            self.containerView.frame.origin.x = 0
            let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
            let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
            
            self.companyPostsButton.setTitleColor(greenColor, for: .normal)
            self.userPostsButton.setTitleColor(blackColor, for: .normal)
            
            self.greenBorder.center.x = self.companyPostsButton.center.x
        }
    }
    func observeUserPosts(){
        self.foodArray.removeAll()
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
                
                    self.foodArray.append(structure)
                    
                    self.foodArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                    
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false) //repeats was false
                    
                }
            }, withCancel: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchBarIsEditing == true && searchBar.text != ""{
            return filteredArray.count
        }
        return foodArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionViewSize.width == 0 && collectionViewSize.height == 0{
        collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width / 2.1
        collectionViewSize.height = collectionViewSize.height / 1.7
        }
        return collectionViewSize
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // 5 5 5 5
        //0 15
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8) //16
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! newCellForCollectionView
        
        
        if collectionView == self.foodCollectionView{
            cell.backgroundColor = UIColor.clear
            let postInformation: MapPoints
            if searchBarIsEditing == true && searchBar.text != ""{
                postInformation = filteredArray[indexPath.row]
            } else{
            postInformation = foodArray[indexPath.row]
            }
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
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     performSegue(withIdentifier: "userPostsSegue", sender: self)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userPostsSegue"{
            let viewController = segue.destination as? openingUserPost
            let indexPath = foodCollectionView.indexPathsForSelectedItems?.last
            let selectedInformation:MapPoints
            if searchBarIsEditing == true && searchBar.text != ""{
                selectedInformation = filteredArray[(indexPath?.row)!]
            } else{
            selectedInformation = foodArray[(indexPath?.row)!]
            }
            viewController?.selectedInformation = selectedInformation
            self.requestPresentationStyle(MSMessagesAppPresentationStyle.expanded)
        }
    }
    override func viewDidLayoutSubviews() {
        //self.view.contentInset.top =
    
        containerView.frame.origin.y = 0
        self.view.frame.origin.y = self.topLayoutGuide.length  //self.topLayoutGuide.length/5.5
        
        self.foodCollectionView.frame.origin.y = self.userPostsButton.frame.origin.y + self.userPostsButton.frame.height + 10
        foodCollectionView.frame.size.height = viewForCollectionView.frame.height
       
       
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
        if presentationStyle != .expanded{
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeView"), object: nil)
        print("changed type")
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
        let defaults = UserDefaults(suiteName: "group.username.SuitName")!
        let email = defaults.object(forKey: "email") as? String
        
         //Auth.auth().currentUser?.email == nil{
        if email == nil || email == ""{
        logUserIn()
        }
    }
    func logUserIn(){
        let defaults = UserDefaults(suiteName: "group.username.SuitName")!
        // Grab the auth token
        //let authToken = defaults.string(forKey: "FAuthDataToken")! as AuthCredential
        
        let authToken = defaults.object(forKey: "FAuthDataToken") as? String
        let email = defaults.object(forKey: "email") as? String
        let password = defaults.object(forKey: "password") as? String
        // Authenticate with the token from the NSUserDefaults object
        print("this is the auth token \(authToken)")
        // let credential:AuthCredential = UserDefaults(suiteName: "group.username.SuitName")! as AuthCredential
        
        if password != nil {
            
            // Auth.auth().signIn(with: authToken, completion: { (user, error) in
            Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
                
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
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        guard let url: URL = URL(string: "Sampy://") else { return }
      
        self.extensionContext?.open(url, completionHandler: { (success: Bool) in
            
        })
    }
    func goBackToAppfunction(){
        guard let url: URL = URL(string: "Sampy://") else { return }
        
        self.extensionContext?.open(url, completionHandler: { (success: Bool) in
            
        })
    }
    func sharePost(selectedInformation:MapPoints,image:UIImage){
        let lat = selectedInformation.latitude
        let long = selectedInformation.longitude
        let city = CLGeocoder()
        let coordinates = CLLocation(latitude: lat!, longitude: long!)
        city.reverseGeocodeLocation(coordinates, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            let placeArray = placemarks as [CLPlacemark]!
            var placeMark: CLPlacemark
            placeMark = (placeArray?[0])!
            
            var state = String()
            var city = String()
            var name = String()
            var textArray = [String]()
            state = placeMark.addressDictionary?["State"] as! String
            city = placeMark.addressDictionary?["City"] as! String
            name = placeMark.addressDictionary?["Name"] as! String
       
            textArray = [name,", ",city,", ",state]
       
            let layout = MSMessageTemplateLayout()
            layout.image = image
            
            layout.caption = selectedInformation.text
            layout.subcaption = textArray.joined()
             self.requestPresentationStyle(MSMessagesAppPresentationStyle.compact)
            let message = MSMessage()
            message.layout = layout
        
            self.activeConversation?.insert(message) { error in
                if let error = error {
                    print(error)
                }
            }
        })
    }
    func shareCompanyPost(selectedInformation:CompanyValues,image:UIImage){
        if selectedInformation.location != "Online only"{
        let lat = selectedInformation.lat
        let long = selectedInformation.long
        let city = CLGeocoder()
        let coordinates = CLLocation(latitude: lat!, longitude: long!)
        city.reverseGeocodeLocation(coordinates, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            let placeArray = placemarks as [CLPlacemark]!
            var placeMark: CLPlacemark
            placeMark = (placeArray?[0])!
            
            var state = String()
            var city = String()
            var name = String()
            var textArray = [String]()
            state = placeMark.addressDictionary?["State"] as! String
            city = placeMark.addressDictionary?["City"] as! String
            name = placeMark.addressDictionary?["Name"] as! String
            
            textArray = [name,", ",city,", ",state]
            
            let layout = MSMessageTemplateLayout()
            layout.image = image
            layout.imageTitle = selectedInformation.companyName
            layout.caption = selectedInformation.description
            layout.subcaption = textArray.joined()
            self.requestPresentationStyle(MSMessagesAppPresentationStyle.compact)
            let message = MSMessage()
            message.layout = layout
            
            self.activeConversation?.insert(message) { error in
                if let error = error {
                    print(error)
                }
            }
        })
        } else{
            let layout = MSMessageTemplateLayout()
            layout.image = image
            layout.imageTitle = selectedInformation.companyName
            layout.caption = selectedInformation.description
            layout.subcaption = selectedInformation.companyWebsite
            self.requestPresentationStyle(MSMessagesAppPresentationStyle.compact)
            let message = MSMessage()
            message.layout = layout
            
            self.activeConversation?.insert(message) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarIsEditing = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarIsEditing = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchBar.text!)
    }
    func filterContentForSearchText(searchText: String) {
        let candies = foodArray
        filteredArray = candies.filter { candy in
            let categoryMatch = (candy.text?.lowercased().contains(searchText.lowercased()))!||(candy.postCity?.lowercased().contains(searchText.lowercased()))!
            return categoryMatch
        }
        foodCollectionView.reloadData()
    }
}
