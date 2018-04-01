//
//  LifeData.swift
//  Parsegram
//
//  Created by David Heffernan on 11/1/17.
//  Copyright © 2017 David Heffernan. All rights reserved.
//

import Foundation

class LifeData {
    
    static var myAuthor : String = "preLoad Author"
    static var myID: String = "prelaod myID"
    static var mySchool: SchoolData = SchoolData(name: "preload name", zip: "preload zip", address: "preload address", id: "preload id")
   
   
    //For testing purposed only: Inits values that otherwise would have been determined by loginview controller
    static func testInit(){
        myAuthor = "Creator"
        myID = "testID"
        mySchool = SchoolData(name: "Groton", zip: "01450", address: "703 Chiccoppee Row", id: "localID")
    }
    
}

struct SchoolData {
    var name : String
    var zip : String
    var address: String
    var id: String
    
    
    
}
