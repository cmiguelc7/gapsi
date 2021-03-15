//
//  SearchProductViewController.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 01/03/21.
//

import Foundation
import UIKit
import SDWebImage

class SearchProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, SearchProductProtocol, UISearchResultsUpdating {
    
    @IBOutlet weak var tableViewProducts: UITableView!
    
    var presenter:SearchProductPresenterProtocol?
    
    var searchController:UISearchController!
    
    var arrayLocalSearchProduct:[Product] = []
    
    var ativityIndicatorLoadInformation = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVIPER()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configVIPER(){
        SearchProductRouter.createModule(SearchProductView: self)
        presenter?.viewDidLoad()
    }
    
    func configUI(){
        
        searchBar()
      
        tableViewProducts.delegate = self
        tableViewProducts.dataSource = self
        tableViewProducts.backgroundView = ativityIndicatorLoadInformation
        tableViewProducts.tableFooterView = .init()
                
    }
    
    func searchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = "Buscar producto"
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Productos"
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    
    //MARK: FLOW SEARCH PRODUCT
    func initFlowSearchProduct(criteria:String){
        
        if Reachability.isConnectedToNetwork(){
            print("vamos a pedir la informacion")
            if arrayLocalSearchProduct.count > 0{
                arrayLocalSearchProduct.removeAll()
                tableViewProducts.reloadData()
            }
            ativityIndicatorLoadInformation.startAnimating()
            presenter?.getSearchProduct(criteria: criteria)
        }else{
            print("No tienes internet")
        }
    }
    
    func receiveSearchProduct(arraySearchProduct: Array<Product>) {
        
        self.arrayLocalSearchProduct.removeAll()
        arrayLocalSearchProduct = arraySearchProduct
        
        DispatchQueue.main.async {
            self.ativityIndicatorLoadInformation.stopAnimating()
            self.tableViewProducts.reloadData()
            self.searchController.isActive = false
        }
        
    }
    
    func showViewErrorInServer() {
        print("showViewErrorInServer")
    }
    
    func showViewErrorNoResults() {
        print("showViewErrorNoResults")
    }
    
    
    //MARK: TABLE VIEW DELEGATES
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let sectionName: String
        switch section {
            case 0:
                if arrayLocalSearchProduct.count > 0{
                    sectionName = "Lista de resultados"
                }else{
                    sectionName = ""
                }
            default:
                sectionName = ""
        }
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayLocalSearchProduct.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let productObject = arrayLocalSearchProduct[indexPath.row]
        
        cell.textLabel?.text = productObject.title
        cell.detailTextLabel?.text = productObject.id
        
        cell.imageView?.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imageView?.sd_setImage(
            with: URL(string: productObject.image!),
            placeholderImage: UIImage(named: ""),
            options: SDWebImageOptions(rawValue: 0),
            completed: { image, error, cacheType, imageURL in
                
                if (error != nil) {
                    // Failed to load image
                    cell.imageView?.image = UIImage(named: "")
                } else {
                    // Successful in loading image
                    cell.imageView?.image = image
                }
            }
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else {
            return
        }
        
        if searchText != "" {
            initFlowSearchProduct(criteria: searchText)
        }
        
    }
    
}
