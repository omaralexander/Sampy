//
//  permaCell.swift
//  Sampy
//
//  Created by Omar Abbas on 7/19/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import Foundation
import NVActivityIndicatorView


class permaCell: UICollectionViewCell{
    var cellLocationY = CGFloat()
    var cellLocationX = CGFloat()
    
    let postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 7
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    let viewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
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
    
    let userNameTextField: UILabel = {
        let label = UILabel()
        let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Medium", size: 17)
        label.textColor = blackColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    let userCity: UILabel = {
        let label = UILabel()
        let blackColor = UIColor(red: 251/255, green: 131/255, blue: 140/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:  "AvenirNext-Regular", size: 14)
        label.textColor = blackColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    let userDescription: UILabel = {
        let label = UILabel()
        let blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Regular", size: 15)
        label.numberOfLines = 2 //3
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.textColor = blackColor
        
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        let view = viewBackground
        addSubview(viewBackground)
        addSubview(activityIndicator)
        view.addSubview(postImage)
        view.addSubview(userNameTextField)
        view.addSubview(userDescription)
        view.addSubview(userCity)
        
        let screenWidth = self.frame.width
        
        view.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        view.heightAnchor.constraint(equalToConstant: self.frame.height - 5).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 13).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        
        
        postImage.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        postImage.bottomAnchor.constraint(equalTo: userNameTextField.topAnchor, constant: -3).isActive = true//5
        postImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        postImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        
        
        
        
        activityIndicator.centerXAnchor.constraint(equalTo: postImage.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: postImage.centerYAnchor, constant: 0).isActive = true
        
        
        userNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        userNameTextField.bottomAnchor.constraint(equalTo: userCity.topAnchor, constant: 0).isActive = true//33
        userNameTextField.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        userCity.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        userCity.bottomAnchor.constraint(equalTo: userDescription.topAnchor, constant: 15).isActive = true
        userCity.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        userCity.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        userDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        userDescription.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5).isActive = true
        userDescription.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        userDescription.heightAnchor.constraint(equalToConstant: self.frame.height / 4).isActive = true
        
        
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
        
    }
}
