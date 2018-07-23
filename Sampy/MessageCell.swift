//
//  MessageCell.swift
//  Sampy
//
//  Created by Omar Abbas on 6/7/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MessageCell: UICollectionViewCell{

    let viewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
       
        return view
    }()
    
    let postedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
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

    override init(frame: CGRect){
        super.init(frame: frame)
        
        let view = viewBackground
        addSubview(viewBackground)
        addSubview(activityIndicator)
        view.addSubview(postedImage)
        let screenWidth = self.frame.width
       

        
        view.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true //constant 13
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
       
        postedImage.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        postedImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        postedImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        postedImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        postedImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: postedImage.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: postedImage.centerYAnchor, constant: 0).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: screenWidth / 3).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: self.frame.height / 3).isActive = true
        
            }
    required init?(coder aDecoder:NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
