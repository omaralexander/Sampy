//
//  mapPoints.swift
//  Sampy
//
//  Created by Omar Abbas on 6/6/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import Foundation

class MapPoints{
    var latitude: Double?
    var longitude: Double?
    var image: String?
    var text: String?
    var user: String?
    var postCity: String?
    var time:NSNumber?
    var viewCount:NSNumber?
    var userUid:String?
    var type: String?
    
    
    init(Latitude: Double,Longitude:Double,Image:String,Text:String,User:String,PostCity:String,Time:NSNumber,userUID:String,ViewCount:NSNumber,Type:String){
        self.time = Time
        self.latitude = Latitude
        self.longitude = Longitude
        self.image = Image
        self.text = Text
        self.user = User
        self.postCity = PostCity
        self.userUid = userUID
        self.viewCount = ViewCount
        self.type = Type
        
    }
}
