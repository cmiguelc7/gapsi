//
//  Counter.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation
import ObjectMapper

struct SearchProductResponse : Mappable {
    
    var items : [Product]?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        items     <- map["items"]
    }
}

struct Product: Mappable {
    
    var id:String?
    var rating:Double?
    var price:Double?
    var image:String?
    var title:String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {

        id          <- map["id"]
        rating      <- map["rating"]
        price       <- map["price"]
        image       <- map["image"]
        title       <- map["title"]
        
    }
    
}
