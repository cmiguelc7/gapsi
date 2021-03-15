//
//  SearchProductRouter.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation

class SearchProductRouter: SearchProductRouterProtocol {
    
    class func createModule(SearchProductView: SearchProductViewController) {
        
        let presenter: SearchProductPresenterProtocol & SearchProductOutputInteractorProtocol = SearchProductPresenter()
        SearchProductView.presenter = presenter
        SearchProductView.presenter?.router = SearchProductRouter()
        SearchProductView.presenter?.view = SearchProductView
        SearchProductView.presenter?.interactor = SearchProductInteractor()
        SearchProductView.presenter?.interactor?.presenter = presenter
        
    }
}
