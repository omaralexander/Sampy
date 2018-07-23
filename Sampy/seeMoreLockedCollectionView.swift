//
//  seeMoreLockedCollectionView.swift
//  Sampy
//
//  Created by Omar Abbas on 10/8/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import NVActivityIndicatorView

extension seeMoreLockedCollectionView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchBar.text!)
        
    }
}

class seeMoreLockedCollectionView: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITextFieldDelegate{
    
    
    
    @IBOutlet weak var viewForSearchBar: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewForCell: UIView!
    
    @IBOutlet weak var viewForUserProfilePicture: UIView!
    
    @IBOutlet weak var searchBar: UITextField!
 
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    
    @IBOutlet weak var noSamplesFound: UILabel!
    
    @IBAction func searchBarEditingChanged(_ sender: UITextField) {
        filterContentForSearchText(searchText: searchBar.text!)
        if users.count == 0 {
            noSamplesFound.text = "No samples found, but keep an eye out for more soon!"
            noSamplesFound.isHidden = false
        } else {
            noSamplesFound.isHidden = true
        }
        if sender.text == ""{
            noSamplesFound.isHidden = true
            
        }
        
    }
    
    var users = [CompanyValues]()
    var cellLocation = [String]()
    var locations = [CompanyValues]()
    let Cell = "Cell"
    var filterType = String()
    var refreshControl: UIRefreshControl!
    var heightForViewForCell = CGFloat()
    var widthForViewForCell = CGFloat()
    
    var searchButtonLocation = CGRect()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 

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
        noSamplesFound.text = "Loading . . ."
      
        
        self.searchBar.adjustsFontSizeToFitWidth = true
        
        
        
        searchBar.delegate = self
        
        
        let viewTemp = UIView(frame: CGRect(x: 0, y: 18, width: viewForSearchBar.frame.width, height: viewForSearchBar.frame.height))
        
        
        
        searchBar.adjustsFontSizeToFitWidth = true
        viewForSearchBar.frame = CGRect(x:0, y: -4, width: viewForSearchBar.frame.width, height: viewForSearchBar.frame.height)
        

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboardOnSwipeUp))
        swipeDown.direction = .down
        
        view.addGestureRecognizer(swipeDown)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.keyboardAppearance = .light
        viewTemp.addSubview(self.searchBar)
        
        viewForSearchBar.addSubview(viewTemp)
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                print("iPhone 4 or 4S")
                viewForCell.frame.size.height = 190
                viewForCell.frame.size.width = 132
                collectionView.frame.origin.y = viewForSearchBar.frame.height + viewForSearchBar.frame.origin.y + 30
            case 1136:
                print("iPhone 5 or 5S or 5c")
            case 1334:
                print("iPhone 6 or 6s")
            case 2208:
                print("iPhone 6+ or 6S+")
            case 2436:
                print("it is the iPhone X")
                viewForCell.frame.size.height = 190
                
                //     viewForUserProfilePicture.frame.size.height = 36
                
                   viewForSearchBar.frame.origin.y = 10
            
                
                
            default:
                print("unknown")
            }
        }
        self.refreshControl = UIRefreshControl()
        //   refreshControl.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        
        refreshControl.addTarget(self, action: #selector(refreshProfile), for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
        
        
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: Cell)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        imageButton.center.y = viewTemp.center.y
        dismissButton.center.y = imageButton.center.y
        
        viewForCell.frame.size.height = heightForViewForCell
        viewForCell.frame.size.width = widthForViewForCell
        
        users.removeAll()
        collectionView.reloadData()
        fetchUser()
        displayLabel()
    }
    func refreshProfile(){
        users.removeAll()
        locations.removeAll()
    
        fetchUser()
  
    }
    
    
    func moveView(){
        let viewTemp = UIView(frame: CGRect(x: 0, y: 10, width: viewForSearchBar.frame.width, height: viewForSearchBar.frame.height))
        viewTemp.addSubview(self.searchBar)
        
        viewForSearchBar.addSubview(viewTemp)
        
    }
    func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUser(){
        let ref = Database.database().reference().child("PermaPost").child("post")
        ref.queryOrdered(byChild: "post").observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let lat = dictionary["lat"] as! Double
                let long = dictionary["long"] as! Double
                let companyImage = dictionary["companyImage"] as! String
                let description = dictionary["description"] as! String
                let companyName = dictionary["companyName"] as! String
                let location = dictionary["location"] as! String
                let time = dictionary["time"] as! NSNumber
                let companyWebsite = dictionary["companyWebsite"] as! String
                let type = dictionary["type"] as! String
                //let viewCount = 0 as NSNumber
                
                let structure = CompanyValues(Latitude: lat, Longitude: long, CompanyImage: companyImage, Description: description, CompanyName: companyName, Location: location, Time: time, CompanyWebsite: companyWebsite, Type: type)
                
                if structure.type == self.filterType{
                    
                    self.users.append(structure)
                    self.locations.append(structure)
                    self.users.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                    self.locations.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                      self.refreshControl.endRefreshing()
            }
            
        }, withCancel: nil)
    }
    func displayLabel(){
        let ref = Database.database().reference().child("PermaPost").child("post")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() == false {
                self.noSamplesFound.text = "No samples found, but keep an eye out for more soon!"
                self.noSamplesFound.isHidden = false
            } else {
                self.noSamplesFound.isHidden = true
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.filterType = ""
        let viewController = self.parent as? listViewController
        viewController?.borderForButtons.center.y = (viewController?.hrfeedbutton.center.y)!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideKeyboardOnSwipeUp()
    }
    
    func dismissViewController(){
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchBar.isEditing == true && searchBar.text != "" {
            return users.count
        }else{
            return self.locations.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewForCell.frame.width, height: viewForCell.frame.height )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 5, bottom: 20, right: 31) //16
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PostCell
        
        cell.backgroundColor = UIColor.clear
        let postInformation: CompanyValues
        if searchBar.isEditing == true && searchBar.text != ""{
            postInformation = users[indexPath.row]
        } else {
            postInformation = locations[indexPath.row]
        }
        
        cell.userDescription.text = postInformation.description
        let seconds = postInformation.time?.doubleValue
        let timestampDate = NSDate(timeIntervalSince1970:seconds!)
        let previousDate = timestampDate as Date
        let value:String = self.timeAgoStringFromDate(date: previousDate)!
        let array = ["Posted ",value]
        let joined = array.joined()
        cell.userCity.text = joined
        cell.postImage.loadImageUsingCachWithUrlString(urlString: postInformation.companyImage!, activityIndicator: cell.activityIndicator)
        cell.activityIndicator.frame.size.width = self.viewForCell.frame.width / 3
        cell.activityIndicator.frame.size.height = self.viewForCell.frame.height / 3
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openPost", sender: self)
        Answers.logCustomEvent(withName: "user selected perma sample for more information inside permaFeedViewController", customAttributes: [:])
    }
    
    var timer: Timer?
    func handleReloadTable(){
        self.collectionView.reloadData()
    }
    
    func hideKeyboardOnSwipeUp(){
        view.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "openPost" {
            
            let indexPath = collectionView.indexPathsForSelectedItems?.last
            let selectedInformation: CompanyValues
            
            if searchBar.isEditing == true && searchBar.text != "" {
                selectedInformation = users[(indexPath?.row)!]
            }else{
                selectedInformation = locations[(indexPath?.row)!]
            }
            
            let viewController = segue.destination as! openingCompanyPost
            viewController.selectedInformation = selectedInformation
        }
    }
    
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        let candies = locations
        users = candies.filter { candy in
            let categoryMatch = (candy.description?.lowercased().contains(searchText.lowercased()))!||(candy.companyName?.lowercased().contains(searchText.lowercased()))!
            
            return categoryMatch
            
        }
        collectionView.reloadData()
    }
    func timeAgoStringFromDate(date: Date) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        let now = Date()
        
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year,.month,.weekOfMonth,.day,.hour,.minute,.second], from: date, to: now)
        
        
        
        if components.year! > 0 {
            formatter.allowedUnits = .year
        } else if components.month! > 0 {
            formatter.allowedUnits = .month
        } else if components.weekOfMonth! > 0 {
            formatter.allowedUnits = .weekOfMonth
        } else if components.day! > 0 {
            formatter.allowedUnits = .day
        } else if components.hour! > 0 {
            formatter.allowedUnits = .hour
        } else if components.minute! > 0 {
            formatter.allowedUnits = .minute
        } else {
            formatter.allowedUnits = .second
        }
        
        let formatString = NSLocalizedString("%@ ago", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
        
        guard let timeString = formatter.string(from: components) else {
            return nil
        }
        return String(format: formatString, timeString)
    }
}
