//
//  Counter.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation

struct Product {
    
    var id:String!
    var rating:Double!
    var price:Double!
    var image:String!
    var title:String!
    
    init(id:String!, rating:Double!, price:Double!, image:String!, title:String!){
        self.id = id
        self.rating = rating
        self.price = price
        self.title = title
    }
    
}
