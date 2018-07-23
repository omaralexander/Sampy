//
//  cellForLocations.swift
//  Hooga
//
//  Created by Omar Abbas on 4/9/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//


import UIKit
import NVActivityIndicatorView

class cellForLocations: UICollectionViewCell{
    let postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5 // 7
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let userProfilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill // .scaleToFill
        return imageView
    }()

    let viewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7 //34
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.3 //0.7
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    let activityIndicator: NVActivityIndicatorView = {
        let frame = CGRect(x: 0, y: 0, width: 70, height: 59)
        let color = UIColor(red: 32/255, green: 149/255, blue: 166/255, alpha: 1)
        let thing = NVActivityIndicatorView(frame: frame)
        thing.translatesAutoresizingMaskIntoConstraints = false
        thing.type = .ballRotateChase
        thing.color = color
        return thing
    }()
       let userNameTextField: UILabel = {
        let label = UILabel()
        let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.textColor = blackColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    let distanceLabel: UILabel = {
        let label = UILabel()
        let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.textColor = blackColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textAlignment = .right
        return label
    }()

    let postTime: UILabel = {
        let label = UILabel()
        let blackColor = UIColor(red: 251/255, green: 131/255, blue: 140/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.textColor = blackColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()

    let userDescription: UILabel = {
        let label = UILabel()
        let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Regular", size: 17)
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.textColor = blackColor
        
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        let view = viewBackground
        addSubview(viewBackground)
        view.addSubview(activityIndicator)
        view.addSubview(userProfilePicture)
        view.addSubview(postImage)
        view.addSubview(userNameTextField)
        view.addSubview(userDescription)
        view.addSubview(postTime)
        view.addSubview(distanceLabel)
        
        let screenWidth = self.frame.width
        
        view.widthAnchor.constraint(equalToConstant: screenWidth - 30).isActive = true
        
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 13).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 43).isActive = true //60
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        userProfilePicture.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3).isActive = true
        userProfilePicture.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        userProfilePicture.widthAnchor.constraint(equalToConstant: 30).isActive = true
        userProfilePicture.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        postImage.topAnchor.constraint(equalTo: postTime.bottomAnchor, constant: 5).isActive = true
        postImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        postImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        postImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        
        postTime.topAnchor.constraint(equalTo: view.topAnchor, constant: 23).isActive = true
        postTime.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 47).isActive = true
        postTime.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        postTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        activityIndicator.centerXAnchor.constraint(equalTo: postImage.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: postImage.centerYAnchor, constant: 0).isActive = true

        
        userNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 47).isActive = true
        userNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        userNameTextField.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true

        userDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3).isActive = true
        userDescription.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        userDescription.widthAnchor.constraint(equalToConstant: screenWidth - 31).isActive = true
        userDescription.heightAnchor.constraint(equalToConstant: self.frame.height / 4).isActive = true
        
        distanceLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 0).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
        
    }
}
