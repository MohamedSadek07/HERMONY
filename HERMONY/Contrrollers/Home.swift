//
//  ViewController.swift
//  هرموني
//
//  Created by Magdy rizk on 3/13/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit

class Home: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource  ,UICollectionViewDelegateFlowLayout{
    
  
    @IBOutlet weak var productSearchBar: UISearchBar!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var homeCollectioView: UICollectionView!
    let api = BackendApi()
    var returnedProducts = ReturnedProducts()
    var selectedIndexPath : IndexPath?
    //var selectedForDelete : Int?
    var neededForDelete = [IndexPath]()
    var products = [[String:Any]]()
    var searchedProducts = SearchedProducts()
    var results = [[String:Any]]()
    var searching = false
     let dateFormatter = DateFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "اعلاناتك"
        homeCollectioView.delegate = self
        homeCollectioView.dataSource = self
       
        
        //        productSearchBar.delegate = self
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            menuButton.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if !searching {
           return products.count
         }
          else {
           return results.count
         }
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = homeCollectioView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyProductsCollectionViewCell
        if  !searching {
            
            
//        cell.dateLabel.text = convertDateFormater(returnedProducts.dateCreated[indexPath.row])
        cell.addressLabel.text = returnedProducts.addesses[indexPath.row]
        cell.priceLabel.text = returnedProducts.prices[indexPath.row]
        cell.descriptionTextView.text = returnedProducts.descriptions[indexPath.row]
            cell.titleLbl.text = returnedProducts.titles[indexPath.row]
            DispatchQueue.main.async {
                let url = URL(string : self.returnedProducts.images[indexPath.row])
                cell.advImageView.kf.indicatorType = .activity
                cell.advImageView.kf.setImage(with: url)
                
            }
//        cell.indexPath = indexPath
//        cell.delegate = self
            cell.deletBtn.tag = indexPath.row
            cell.deletBtn.addTarget(self, action:#selector(deleteButtonAction), for: .touchUpInside)
        }
        else {
            cell.dateLabel.text = searchedProducts.dateCreated[indexPath.row]
            cell.addressLabel.text = searchedProducts.addesses[indexPath.row]
            cell.priceLabel.text = searchedProducts.prices[indexPath.row]
            cell.descriptionTextView.text = searchedProducts.descriptions[indexPath.row]
            cell.titleLbl.text = searchedProducts.titles[indexPath.row]
            DispatchQueue.main.async {
                let url = URL(string : self.searchedProducts.images[indexPath.row])
                cell.advImageView.kf.indicatorType = .activity
                cell.advImageView.kf.setImage(with: url)
            }
             cell.deletBtn.tag = indexPath.row
            cell.deletBtn.addTarget(self, action:#selector(deleteButtonAction), for: .touchUpInside)
           
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        print(selectedIndexPath?.row)
        performSegue(withIdentifier: "detailsfrommyadds", sender: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(selectedIndexPath?.row)
        
        let detailsVC = segue.destination as! ProductDetailsViewController
        detailsVC.id = returnedProducts.id[selectedIndexPath!.row]
        detailsVC.userId = returnedProducts.userId[selectedIndexPath!.row]
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMypro()
    
    }
    func getMypro()  {
        self.view.lock()
        let parameters = ["user_id" : User.sharedInstance.id]
        returnedProducts.id.removeAll()
        returnedProducts.addesses.removeAll()
        returnedProducts.dateCreated.removeAll()
        returnedProducts.images.removeAll()
        returnedProducts.prices.removeAll()
        returnedProducts.descriptions.removeAll()
        
        
        
        api.retreivingMyProducts(serviceName : ServiceName.MyProducts.rawValue ,parameters: parameters as! [String : String]) {[weak self] (response) in
            self!.view.unlock()
            print(response)
            self!.products = response["Products"] as! [[String:Any]]
            for product in self!.products {
                let user = product["user"] as! [[String:Any]]
                self!.returnedProducts.userId.append(user.first?["id"] as! Int)
                self!.returnedProducts.id.append(product["id"] as! Int)
                self!.returnedProducts.dateCreated.append(product["created_at"] as! String)
                self!.returnedProducts.prices.append(product["price"] as! String)
                self!.returnedProducts.descriptions.append(product["ar_description"] as! String)
                self!.returnedProducts.addesses.append(product["address"] as! String)
                self!.returnedProducts.titles.append(product["ar_title"] as! String)
                if product["image"] is [String:Any] {
                    let image = product["image"] as! [String :Any]
                    self!.returnedProducts.images.append("http://aqary.elroily.com/Upload/Product/\(image["img"]!)")
                }else{
                    self!.returnedProducts.images.append("https://cdn0.iconfinder.com/data/icons/elasto-online-store/26/00-ELASTOFONT-STORE-READY_user-circle-512.png")
                }
                self!.homeCollectioView.reloadData()
                
            }
            print(self!.returnedProducts.id.count)
            self!.homeCollectioView.reloadData()
        }
    }
    
    
    
    
    @objc func deleteButtonAction(_ sender : UIButton) {
        let id = returnedProducts.id[sender.tag]
        print(returnedProducts.id[sender.tag])
        
        let alert = UIAlertController(title: "Warning", message: "Are you sure , you want to delete \(returnedProducts.descriptions[sender.tag])", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) {[weak self] (alert) in
            let parameters = ["id" : id]
            print(parameters)
            self!.view.lock()
            self!.api.deleteProduct(serviceName: ServiceName.Delete_Product.rawValue, parameters: parameters ) { (response) in
                let code = response["code"] as! Int
              self!.view.unlock()
                if code == 200 {
                    let alert = UIAlertController(title: "Message", message: "this item \(self!.returnedProducts.descriptions[sender.tag]) is deleted", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self!.present(alert, animated: true, completion: nil)
                }
            }
            
            self!.getMypro()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
  
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
   
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAdvButtonAction(_ sender: Any) {
        let addAdvVC = storyboard?.instantiateViewController(withIdentifier: "addProductScene") as! AddAdvertisingViewController
        navigationController?.pushViewController(addAdvVC, animated: true)
    }
}


class ReturnedProducts {
    var dateCreated = [String]()
    var prices = [String]()
    var titles = [String]()
    var descriptions = [String]()
    var images = [String]()
    var addesses = [String]()
    var id = [Int]()
    var userId = [Int]()
}

class SearchedProducts {
    var dateCreated = [String]()
    var prices = [String]()
    var titles = [String]()
    var descriptions = [String]()
    var images = [String]()
    var addesses = [String]()
    var id = [Int]()
    var userId = [Int]()
}

extension Home : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
      productSearchBar.becomeFirstResponder()
        view.endEditing(true)
       let parameters = ["user_id" : User.sharedInstance.id , "search" : productSearchBar.text]
        self.view.lock()
        api.searchMyProducts(serviceName: ServiceName.search.rawValue, parameters: parameters as [String : Any]) {[weak self] (response) in
           self!.view.unlock()
            self!.results = response["Products"] as! [[String:Any]]
            for result in self!.results {
                let user = result["user"] as! [[String:Any]]
                self!.searchedProducts.userId.append(user.first?["id"] as! Int)
                self!.searchedProducts.id.append(result["id"] as! Int)
                self!.searchedProducts.dateCreated.append(result["created_at"] as! String)
                self!.searchedProducts.prices.append(result["price"] as! String)
                self!.searchedProducts.descriptions.append(result["ar_description"] as! String)
                self!.searchedProducts.addesses.append(result["result"] as! String)
                self!.searchedProducts.titles.append(result["ar_title"] as! String)
                if result["image"] is [String:Any] {
                    let image = result["image"] as! [String :Any]
                    self!.searchedProducts.images.append("http://aqary.elroily.com/Upload/Product/\(image["img"]!)")
                }else{
                    self!.searchedProducts.images.append("https://cdn0.iconfinder.com/data/icons/elasto-online-store/26/00-ELASTOFONT-STORE-READY_user-circle-512.png")
                }
            }
            print("SEARCH RESULTS \(self!.results)")
        }
        searching = true
        homeCollectioView.reloadData()
    }
}


extension Home : transferData {
    func deleteProduct(index: Int) {
//        deleteButtonAction(selectedForDelete: index)
        homeCollectioView.reloadData()
    }
    
    
}
