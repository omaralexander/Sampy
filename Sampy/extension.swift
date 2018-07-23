//
//  extension.swift
//  Sampy
//
//  Created by Omar Abbas on 5/27/17.
//  Copyright © 2017 Sampy. All rights reserved.
//


import UIKit
import NVActivityIndicatorView
import MapboxDirections

func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCachWithUrlString(urlString: String, activityIndicator: NVActivityIndicatorView) {
        activityIndicator.startAnimating()
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as UIImage?{
            activityIndicator.stopAnimating()
            self.image = cachedImage
            
            return
        }
        
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data,response,error) in
            if error != nil{
                print(error?.localizedDescription as Any)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    activityIndicator.stopAnimating()
                    self.image = downloadedImage
                    
                }
            }
            
        }).resume()
    }
    
}

extension UIView{
    func origin (_ point : CGPoint){
        frame.origin.x = point.x
        frame.origin.y = point.y
    }
}

var kIndexPathPointer = "kIndexPathPointer"

extension UICollectionView{
       
    func setToIndexPath (_ indexPath : IndexPath){
        objc_setAssociatedObject(self, &kIndexPathPointer, indexPath, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func toIndexPath () -> IndexPath {
        let index = self.contentOffset.x/self.frame.size.width
        if index > 0{
            return IndexPath(row: Int(index), section: 0)
        }else if let indexPath = objc_getAssociatedObject(self,&kIndexPathPointer) as? IndexPath {
            return indexPath
        }else{
            return IndexPath(row: 0, section: 0)
        }
    }
    
    func fromPageIndexPath () -> IndexPath{
        let index : Int = Int(self.contentOffset.x/self.frame.size.width)
        return IndexPath(row: index, section: 0)
    }
}
