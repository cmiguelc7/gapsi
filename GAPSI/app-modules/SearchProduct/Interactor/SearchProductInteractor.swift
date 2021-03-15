//
//  SearchProductInteractor.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper

class SearchProductInteractor: SearchProductInteractorProtocol {
    
    var presenter: SearchProductOutputInteractorProtocol?
    var alamoFireManager : SessionManager?
    
    func requestSearchProduct(criteria: String) {
        
        var url = String(format: "https://00672285.us-south.apigw.appdomain.cloud/demo-gapsi/search?&query=[%@]", criteria)
        
        url = url.replacingOccurrences(of: " ", with: "-")

        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-IBM-Client-Id": "adb8204d-d574-4394-8c1a-53226a40876e"
        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60.0
        configuration.timeoutIntervalForResource = 60.0
        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        
        alamoFireManager!.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            
            
            switch (response.result) {
                case .success:
                                    
                    if response.response?.statusCode == 200 {
                        
                        let result = response.result.value
                        
                        if result != nil && result is NSDictionary {
                            
                            let JSON = response.result.value as! NSDictionary
                            let totalResults =  JSON.value(forKey: "totalResults") as! Int
                            
                            if totalResults > 0 {
                                
                                var arrayResultSearchProduct:[Product] = []
                                
                                let brastlewarkResponse = Mapper<SearchProductResponse>().map(JSONObject:response.result.value)
                                let productsArray = brastlewarkResponse?.items
                                
                                for i in 0..<productsArray!.count{
                                    if let newProduct = productsArray?[i]{
                                        arrayResultSearchProduct.append(newProduct)
                                    }
                                }
                                
                                self.presenter?.receiveSearchProduct(arraySearchProduct: arrayResultSearchProduct)
                                
                            }else{
                                self.presenter?.showViewErrorNoResults()
                            }
                        }
                        
                    } else {
                        self.presenter?.showViewErrorInServer()
                    }
                    break
            case .failure(let error):
                print("error tipificado ☹️ \(error.localizedDescription)")
                self.presenter?.showViewErrorInServer()
                break
            
            }
        }
        
     }
}
