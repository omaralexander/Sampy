//
//  newCellForCollectionView.swift
//  sampyiMessage
//
//  Created by Omar Abbas on 11/26/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit

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
