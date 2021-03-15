//
//  SearchProductInteractor.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation
import UIKit

class SearchProductInteractor: SearchProductInteractorProtocol {
    
    var presenter: SearchProductOutputInteractorProtocol?
    
    func requestSearchProduct(from view: UIViewController) {
        
        var arrayResultSearchProduct:[Product] = []
        
        let id          = "5T46E4NG6PS1"
        let rating      = 4.5
        let price       = 299.0
        let image       = "https://i5.walmartimages.com/asr/afdb71df-4810-4e3e-9c3c-187e88a98619_1.9abc0f91d776fcbf0b8b580e875ed6c0.jpeg?odnHeight=200&odnWidth=200&odnBg=ffffff"
        let title       = "Nintendo Switch Console with Neon Blue & Red Joy-Con."
        
        arrayResultSearchProduct.append(Product(id: id, rating: rating, price: price, image: image, title: title))
        self.presenter?.receiveSearchProduct(arraySearchProduct: arrayResultSearchProduct)
        
     }
}
