//
//  SearchProductViewController.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation
import UIKit

class SearchProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  SearchProductProtocol {
    
    
    @IBOutlet weak var tableViewProducts: UITableView!
    
    var presenter:SearchProductPresenterProtocol?
    
    var arrayLocalSearchProduct:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVIPER()
        configUI()
        initFlowSearchProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configVIPER(){
        SearchProductRouter.createModule(SearchProductView: self)
        presenter?.viewDidLoad()
    }
    
    func configUI(){
      
        tableViewProducts.delegate = self
        tableViewProducts.dataSource = self
    }
    
    
    //MARK: FLOW SEARCH PRODUCT
    func initFlowSearchProduct(){
        
        if Reachability.isConnectedToNetwork(){
            print("vamos a pedir la informacion")
            presenter?.getSearchProduct()
        }else{
            print("No tienes internet")
        }
    }
    
    func receiveSearchProduct(arraySearchProduct: Array<Product>) {
        
        self.arrayLocalSearchProduct.removeAll()
        arrayLocalSearchProduct = arraySearchProduct
        
        DispatchQueue.main.async {
            self.tableViewProducts.reloadData()
        }
        
    }
    
    func showViewErrorInServer() {
        print("showViewErrorInServer")
    }
    
    func showViewErrorNoResults() {
        print("showViewErrorNoResults")
    }
    
    
    //MARK: TABLE VIEW DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayLocalSearchProduct.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let productObject = arrayLocalSearchProduct[indexPath.row]
        
        cell.textLabel?.text = productObject.title
        cell.detailTextLabel?.text = productObject.id
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
    }
}
