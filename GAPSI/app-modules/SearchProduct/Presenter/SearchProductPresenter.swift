//
//  SearchProductPresenter.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import UIKit

class SearchProductPresenter: SearchProductPresenterProtocol {
    
    var router: SearchProductRouterProtocol?
    var view: SearchProductProtocol?
    var interactor: SearchProductInteractorProtocol?
    var presenter: SearchProductPresenterProtocol?
    
    func viewDidLoad() { }
    
    func getSearchProduct() {
        interactor?.requestSearchProduct(from: view as! UIViewController)
    }
        
}

extension SearchProductPresenter: SearchProductOutputInteractorProtocol {
    
    func receiveSearchProduct(arraySearchProduct: Array<Product>) {
        view?.receiveSearchProduct(arraySearchProduct: arraySearchProduct)
    }
    
    func showViewErrorInServer() {
        self.view?.showViewErrorInServer()
    }
    
    func showViewErrorNoResults() {
        self.view?.showViewErrorNoResults()
    }

}
