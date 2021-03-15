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
    var arrayLastSearches:[String] = []
    var isSearchActive:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVIPER()
        configData()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configVIPER(){
        SearchProductRouter.createModule(SearchProductView: self)
        presenter?.viewDidLoad()
    }
    
    func configData(){
        
        arrayLastSearches = UserDefaults.standard.stringArray(forKey: UDefaults.kLastSearches.rawValue) ?? [String]()
        
    }
    
    func configUI(){
        
        searchBar()
      
        tableViewProducts.delegate = self
        tableViewProducts.dataSource = self
        let nib = UINib(nibName: "CellViewProduct", bundle: nil)
        tableViewProducts.register(nib, forCellReuseIdentifier: "CellViewProduct")
        ativityIndicatorLoadInformation.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
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
            
            hideLastSearches()
            
            ativityIndicatorLoadInformation.startAnimating()
            presenter?.getSearchProduct(criteria: criteria)
        }else{
            showAlert(message: "No tienes inernet, revisa tu conexión.")
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
        showAlert(message: "Hubo un problema en el servidor, por favor intente más tarde.")
        DispatchQueue.main.async {
            self.ativityIndicatorLoadInformation.stopAnimating()
            self.tableViewProducts.reloadData()
            self.searchController.isActive = false
        }
    }
    
    func showViewErrorNoResults() {
        print("showViewErrorNoResults")
        showAlert(message: "Sin resultados por el momento")
        DispatchQueue.main.async {
            self.ativityIndicatorLoadInformation.stopAnimating()
            self.tableViewProducts.reloadData()
            self.searchController.isActive = false
        }
    }
    
    
    //MARK: TABLE VIEW DELEGATES
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let sectionName: String
        
        if !isSearchActive {
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
        }else{
            switch section {
                case 0:
                    if arrayLastSearches.count > 0{
                        sectionName = "Últimas búsquedas"
                    }else{
                        sectionName = ""
                    }
                default:
                    sectionName = ""
            }
        }
        
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSearchActive {
            return arrayLocalSearchProduct.count
        }else{
            return arrayLastSearches.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !isSearchActive {
            return 100
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var GeneralCell:UITableViewCell!
        
        if !isSearchActive {
        
            let cellProduct = tableView.dequeueReusableCell(withIdentifier: "CellViewProduct", for: indexPath) as! CellViewProduct
            
            let productObject = arrayLocalSearchProduct[indexPath.row]
        
            cellProduct.configure(product: productObject)
            cellProduct.selectionStyle = .none
            
            GeneralCell = cellProduct
            
        }else{
            let cellLastSearches = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            let titleSearches = arrayLastSearches[indexPath.row]
            cellLastSearches.textLabel?.text = titleSearches
            
            cellLastSearches.selectionStyle = .default
            
            GeneralCell = cellLastSearches
        }
        
        return GeneralCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if !isSearchActive {
            print("didSelectRowAt over Product")
        }else{
            let stringLastSearches = arrayLastSearches[indexPath.row]
            searchController.searchBar.text = stringLastSearches
            searchController.searchBar.resignFirstResponder()
            initFlowSearchProduct(criteria: stringLastSearches)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        print("updateSearchResults")
        
        if self.searchController.isActive {
            showLastSearches()
        }else{
            hideLastSearches()
        }
        
        print("activo = \(self.searchController.isActive)")
        //showLastSearches()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else {
            return
        }
        
        if searchText != "" {
            saveInLastSearches(title: searchText)
            initFlowSearchProduct(criteria: searchText)
        }
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancelo")
        hideLastSearches()
    }
    
    func hideLastSearches(){
        isSearchActive = false
        tableViewProducts.reloadData()
    }
    
    //UserDefaults.standard.string(forKey: UDefaults.kUserId.rawValue)!
    func showLastSearches(){
        if arrayLastSearches.count > 0 {
            print("Show List Last Searches")
            isSearchActive = true
            tableViewProducts.reloadData()
            print("Quienes = \(arrayLastSearches)")
        }else{
            print("NADA de NADA")
        }
    }
    
    func saveInLastSearches(title: String) {
        
        if !arrayLastSearches.contains(title){
            arrayLastSearches.append(title)
            UserDefaults.standard.set(arrayLastSearches,forKey: UDefaults.kLastSearches.rawValue)
            print("Se guardo correctamente")
            print(arrayLastSearches)
        }else{
            print("Ya se encuentra agregado")
        }
        
    }
    
    func showAlert(title:String = "GAPSI", message: String) {
        let alertController = UIAlertController(title: title, message:
        message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
