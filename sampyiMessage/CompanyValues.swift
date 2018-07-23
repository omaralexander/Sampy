//
//  CompanyValues.swift
//  sampyiMessage
//
//  Created by Omar Abbas on 11/20/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import Foundation


class CompanyValues{

    var lat: Double?
    var long: Double?
    var companyImage: String?
    var description: String?
    var companyName: String?
    var location: String?
    var time: NSNumber?
    var companyWebsite: String?
    var type: String?

    init(Latitude: Double,Longitude:Double,CompanyImage:String,Description:String,CompanyName:String,Location:String,Time:NSNumber,CompanyWebsite:String,Type:String){
     
        self.lat = Latitude
        self.long = Longitude
        self.companyImage = CompanyImage
        self.description = Description
        self.companyName = CompanyName
        self.location = Location
        self.time = Time
        self.companyWebsite = CompanyWebsite
        self.type = Type
        
    }
}


