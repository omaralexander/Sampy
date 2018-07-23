//
//  postCell.swift
//  Sampy
//
//  Created by Omar Abbas on 6/12/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class PostCell: UICollectionViewCell{

    let postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 3//7
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill // .scaleToFill
        return imageView
    }()
    
    let viewBackground: UIView = {
        let view = UIView()
        let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false

        
        return view
    }()
    let activityIndicator: NVActivityIndicatorView = {
        let activityFrame = CGRect(x: 0, y: 0, width: 270, height: 59) // 70 59
        let color = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
        let thing = NVActivityIndicatorView(frame: activityFrame)
        thing.translatesAutoresizingMaskIntoConstraints = false
        thing.type = .ballRotateChase
        thing.color = color
        return thing
    }()

   
    let userDescription: UILabel = {
        let label = UILabel()
        let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Demibold", size: 15)
        label.textColor = blackColor
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.textAlignment = .left
        
        return label
    }()
    let userCity: UILabel = {
        let label = UILabel()
        let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        let greenColor = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Medium", size: 13)
        label.textColor = greenColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5

        return label
    }()
   
    let postTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let redColor = UIColor(red: 251/255, green: 131/255, blue: 140/255, alpha: 1)
         let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        label.font = UIFont(name: "AvenirNext-Regular", size: 13)
        label.textColor = blackColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .right
        
        return label
    }()

    override init(frame: CGRect){
        super.init(frame: frame)
        let view = viewBackground
        
        addSubview(viewBackground)
     
        view.addSubview(postImage)
        view.addSubview(userCity)
        view.addSubview(activityIndicator)
        view.addSubview(userDescription)
        view.addSubview(postTime)
        
        let screenWidth = self.frame.width
        
        view.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        view.heightAnchor.constraint(equalToConstant: self.frame.height - 5).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 13).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
     
        //152
        
       // postImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44).isActive = true//5
        postImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        postImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        postImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true //53
        postImage.bottomAnchor.constraint(equalTo: userCity.topAnchor, constant: -1).isActive = true
        
        postTime.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        postTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
        postTime.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6).isActive = true
        

      //  activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
      //  activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        //activityIndicator.widthAnchor.constraint(equalToConstant: screenWidth / 3).isActive = true
       // activityIndicator.heightAnchor.constraint(equalToConstant: screenWidth / 3).isActive = true
       // activityIndicator.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -65).isActive = true
        activityIndicator.center.x = view.center.x
        activityIndicator.center.y = postImage.center.y
        
        
        
        userCity.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        userCity.bottomAnchor.constraint(equalTo: userDescription.topAnchor, constant: 2).isActive = true
        userCity.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        userCity.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
        userDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        userDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        userDescription.bottomAnchor.constraint(equalTo: postTime.topAnchor, constant: -1).isActive = true //10
       // userDescription.topAnchor.constraint(equalTo: userCity.bottomAnchor, constant: -26).isActive = true
        
        
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
        
    }
}
