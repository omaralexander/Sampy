//
//  newCompanyPostsViewController.swift
//  sampyiMessage
//
//  Created by Omar Abbas on 11/20/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

extension newCompanyPostsViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchBar.text!)
    }
}


class newCompanyPostsViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
@IBOutlet weak var foodCollectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewForCollectionView: UIView!
    var foodArray = [CompanyValues]()
    var filteredArray = [CompanyValues]()
    var searchBarIsEditing = Bool()
    var collectionViewSize = CGSize()
    override func viewDidLoad() {
        super.viewDidLoad()
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
   
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.register(newCellForCollectionView.self, forCellWithReuseIdentifier: "Cell")
        foodCollectionView.isScrollEnabled = true
        foodCollectionView.alwaysBounceVertical = true
        searchBar.delegate = self
        searchBar.keyboardAppearance = .light
        foodCollectionView.keyboardDismissMode = .onDrag
        
        observeUserPosts()
    }
    var timer: Timer?
    func handleReloadTable(){
        self.foodCollectionView.reloadData()
    }
    func observeUserPosts(){
        self.foodArray.removeAll()
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
              
                let structure = CompanyValues(Latitude: lat, Longitude: long, CompanyImage: companyImage, Description: description, CompanyName: companyName, Location: location, Time: time, CompanyWebsite: companyWebsite, Type: type)
                
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
        if collectionViewSize.width == 0 && collectionViewSize.height == 0 {
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
            let postInformation: CompanyValues
            
            if searchBarIsEditing == true && searchBar.text != ""{
                postInformation = filteredArray[indexPath.row]
            } else{
            postInformation = foodArray[indexPath.row]
            }
                if postInformation.description == "test"{
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
                cell.text.text = postInformation.description
                cell.image.loadImageUsingCachWithUrlString(urlString: postInformation.companyImage!, activityIndicator: activityIndicator)
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       performSegue(withIdentifier: "companyPostSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "companyPostSegue"{
            let viewController = segue.destination as! openingCompanyPost
            let indexPath = foodCollectionView.indexPathsForSelectedItems?.last
            let selectedInformation: CompanyValues
            if searchBarIsEditing == true && searchBar.text != ""{
                selectedInformation = filteredArray[(indexPath?.row)!]
            } else{
            selectedInformation = foodArray[(indexPath?.row)!]
            }
            viewController.selectedInformation = selectedInformation
            
            let parent = self.parent as? newViewController
            parent?.requestPresentationStyle(.expanded)
        }
    }
    override func viewDidLayoutSubviews() {
print("loaded")
        let viewController = self.parent as? newViewController
       // self.view.frame.origin.y = self.topLayoutGuide.length
        
        self.foodCollectionView.frame.origin.y = (viewController?.userPostsButton.frame.origin.y)! + (viewController?.userPostsButton.frame.height)! + 10
        foodCollectionView.frame.size.height = viewForCollectionView.frame.height
    }
    func filterContentForSearchText(searchText: String) {
        let candies = foodArray
        filteredArray = candies.filter { candy in
            let categoryMatch = (candy.description?.lowercased().contains(searchText.lowercased()))!||(candy.companyName?.lowercased().contains(searchText.lowercased()))!
            return categoryMatch
        }
        foodCollectionView.reloadData()
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
}
