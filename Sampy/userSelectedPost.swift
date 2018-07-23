//
//  userSelectedPost.swift
//  Sampy
//
//  Created by Omar Abbas on 6/15/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Canvas



class userSelectedPost: UIViewController {
    @IBOutlet weak var selectedPicture: UIImageView!
    var postInformation: MapPoints?
    @IBOutlet weak var selectedImageView: CSAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //selectedPicture.loadImageUsingCachWithUrlString(urlString: (postInformation?.image)!)
    }
    override func viewDidAppear(_ animated: Bool) {
        selectedImageView.startCanvasAnimation()
        
        animateViewIn()
    }
    func animateViewIn(){
        UIView.animate(withDuration: 0.8){
      self.selectedImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        }
    }
}
