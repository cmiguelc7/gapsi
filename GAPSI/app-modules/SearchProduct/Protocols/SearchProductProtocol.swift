//
//  SearchProductProtocol.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import UIKit

protocol SearchProductProtocol: class {
    //PRESENTER -> VIEW
    func receiveSearchProduct(arraySearchProduct:Array<Product>)
    func showViewErrorInServer()
    func showViewErrorNoResults()
}


protocol SearchProductPresenterProtocol: class {
    //View -> Presenter
    
    var interactor: SearchProductInteractorProtocol? {get set}
    var view: SearchProductProtocol? {get set}
    var router: SearchProductRouterProtocol? {get set}
    
    func viewDidLoad()
    func getSearchProduct()

}

protocol SearchProductInteractorProtocol: class {
    //Presenter -> Interactor
    var presenter: SearchProductOutputInteractorProtocol? {get set}
    func requestSearchProduct(from view: UIViewController)
}

protocol SearchProductOutputInteractorProtocol: class {
    //Interactor -> PresenterOutput
    
    func receiveSearchProduct(arraySearchProduct: Array<Product>)
    func showViewErrorInServer()
    func showViewErrorNoResults()
}


protocol SearchProductRouterProtocol: class {
    static func createModule(SearchProductView: SearchProductViewController)
}
