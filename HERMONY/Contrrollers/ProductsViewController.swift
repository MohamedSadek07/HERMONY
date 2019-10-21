//
//  ProductsViewController.swift
//  HERMONY
//
//  Created by Mohamed Ahmed Sadek on 4/30/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit
import Kingfisher

class ProductsViewController: UIViewController , UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var productSearchBar: UISearchBar!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var width : CGFloat = 0.0
    let api = BackendApi()
    var returnedProducts = RetreivedProducts()
    var resultedProducts = ResultedProducts()
    var products = [[String:Any]]()
    var results = [[String:Any]]()
    var searching = false
    var categoriesArr = [String]()
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        width = ( self.view.frame.width / 2) - 25
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productSearchBar.delegate = self
        //getProdecut()
        
        
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryPickerView.isHidden = true
        getCategories()

    }
    
    func getCategories(){
        api.requestCategories(serviceName: ServiceName.Categories.rawValue) { (response) in
            let categories = response["Categories"] as! [[String : Any]]
            for category in categories {
                self.categoriesArr.append(category["ar_title"] as! String)
                
            }
            self.categoryPickerView.reloadAllComponents()
            print(self.categoriesArr)
        }
    }
    
  
    @IBAction func categoryBtnAction(_ sender: Any) {
        categoryPickerView.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        print(selectedIndexPath?.row)
        print(returnedProducts.userId.count)
        if !searching{
         let detailsVC = segue.destination as! ProductDetailsViewController
        detailsVC.id = returnedProducts.id[selectedIndexPath!.row]
            detailsVC.userId = returnedProducts.userId[selectedIndexPath!.row]
            
        }else{
            let detailsVC = segue.destination as! ProductDetailsViewController
            detailsVC.id = resultedProducts.id[selectedIndexPath!.row]
            detailsVC.userId = resultedProducts.userId[selectedIndexPath!.row]
        }
        
    }
    
    
    func getProdecut()   {
        self.view.lock()
        let parameters = ["user_id" : User.sharedInstance.id]
        print("USER ID" , User.sharedInstance.id!)
        
        api.retreivingMyProducts(serviceName: ServiceName.Products.rawValue, parameters: parameters as! [String : String], completion: { [weak self] (response) in
            self!.returnedProducts.userId.removeAll()
            self!.returnedProducts.id.removeAll()
            self!.returnedProducts.titles.removeAll()
            self!.returnedProducts.date.removeAll()
            self!.returnedProducts.prices.removeAll()
            self!.returnedProducts.addresses.removeAll()
            self!.returnedProducts.fav.removeAll()
            self!.returnedProducts.views.removeAll()
            self!.returnedProducts.advertisingImages.removeAll()
            self!.returnedProducts.userImages.removeAll()
            self!.products = response["Products"] as! [[String:Any]]
            self!.view.unlock()
            print(response)
            for result in self!.products {
                print("RESULT" , result["user"])
                
                let user = result["user"] as! [[String:Any]]
                print(user.first?["id"] as! Int)
                
                if user.first?["img"] is String {
                    self!.returnedProducts.userImages.append("http://aqary.elroily.com/Upload/user/\((user.first?["img"])!)" )
                    print("http://aqary.elroily.com/Upload/user/\((user.first?["img"])!)")
                }else {
                     self!.returnedProducts.userImages.append("https://cdn0.iconfinder.com/data/icons/elasto-online-store/26/00-ELASTOFONT-STORE-READY_user-circle-512.png")
                }
                self!.returnedProducts.userId.append(user.first?["id"] as! Int)
                self!.returnedProducts.id.append(result["id"] as! Int)
                self!.returnedProducts.titles.append(result["ar_title"] as! String)
                self!.returnedProducts.date.append(result["created_at"] as! String)
                self!.returnedProducts.prices.append( result["price"] as! String)
                self!.returnedProducts.addresses.append(result["address"] as!String)
                self!.returnedProducts.fav.append(result["favorite"] as!Int)
                self!.returnedProducts.views.append(result["view"] as! Int)
                if result["image"] is [String:Any] {
                    let image = result["image"] as! [String :Any]
                    self!.returnedProducts.advertisingImages.append("http://aqary.elroily.com/Upload/Product/\(image["img"]!)")
                }else{
                    self!.returnedProducts.advertisingImages.append("https://cdn0.iconfinder.com/data/icons/elasto-online-store/26/00-ELASTOFONT-STORE-READY_user-circle-512.png")
                }
                
                
              self!.productsCollectionView.reloadData()
         }
       }
    )}
        
    
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
 
}

class RetreivedProducts {
    var id = [Int]()
    var userId = [Int]()
    var titles = [String]()
    var date = [String]()
    var prices = [String]()
    var addresses = [String]()
    var advertisingImages = [String]()
    var sellerImages = [String]()
    var views = [Int]()
    var userImages = [String]()
    var fav = [Int]()
}
 // search
class ResultedProducts {
    var id = [Int]()
    var userId = [Int]()
    var titles = [String]()
    var date = [String]()
    var prices = [String]()
    var addresses = [String]()
    var advertisingImages = [String]()
    var sellerImages = [String]()
    var views = [Int]()
    var userImages = [String]()
    var fav = [Int]()
}


extension ProductsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        productSearchBar.becomeFirstResponder()
        view.endEditing(true)
//
        self.view.lock()
        let parameters = ["user_id" : User.sharedInstance.id! , "search" : productSearchBar.text!]
        print(parameters)
        api.searchMyProducts(serviceName: ServiceName.search.rawValue, parameters: parameters as [String : Any]) {[weak self] (response) in
            
            print(response)
            self!.results = response["Products"] as! [[String:Any]]
            self!.view.unlock()
            for result in self!.results {
                print(result["user"])
                let user = result["user"] as! [[String:Any]]
                self!.resultedProducts.userId.append(user.first?["id"] as! Int)
                print(user.first?["id"] as! Int)
                if user.first?["img"] is String {
                    self!.resultedProducts.userImages.append("http://aqary.elroily.com/Upload/user/\((user.first?["img"])!)" )
                    print("http://aqary.elroily.com/Upload/user/\((user.first?["img"])!)")
                }else {
                    self!.resultedProducts.userImages.append("https://cdn2.iconfinder.com/data/icons/scenarium-vol-5/128/001_home_house_building_city_urban_realty_real_estate-512.png")
                }
                
                
                self!.resultedProducts.id.append(result["id"] as! Int)
                self!.resultedProducts.fav.append(result["favorite"] as!Int)
                self!.resultedProducts.titles.append(result["ar_title"] as! String)
                self!.resultedProducts.date.append(result["created_at"] as! String)
                self!.resultedProducts.prices.append( result["price"] as! String)
                self!.resultedProducts.addresses.append(result["address"] as!String)
                self!.resultedProducts.views.append(result["view"] as! Int)
                
                if result["image"] is [String:Any] {
                    let image = result["image"] as! [String :Any]
                    self!.resultedProducts.advertisingImages.append("http://aqary.elroily.com/Upload/Product/\(image["img"]!)")
                }else{
                    self!.resultedProducts.advertisingImages.append("https://cdn2.iconfinder.com/data/icons/scenarium-vol-5/128/001_home_house_building_city_urban_realty_real_estate-512.png")
                }
            }
            self!.searching = true
            print(self!.resultedProducts.id.count)
            self!.productsCollectionView.reloadData()
            print("SEARCH RESULTS \(self!.resultedProducts.addresses)")
        }
    }
}


extension ProductsViewController :  UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(returnedProducts.titles.count)
        print(resultedProducts.titles.count)
        if searching{
            return results.count
        }
        return products.count
    }
    
    @IBAction func ChangeWidth(_ sender: Any) {
        if width == (( self.view.frame.width / 2) - 25){
            width = (self.view.frame.width - 35)
        }else{
            width =  (( self.view.frame.width / 2) - 25)
        }
        productsCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductsCollectionViewCell
        if searching{
            cell.titleLabel.text = resultedProducts.titles[indexPath.row]
            cell.dateLabel.text = convertDateFormater(resultedProducts.date[indexPath.row])
            cell.priceLabel.text = resultedProducts.prices[indexPath.row]
            cell.addressLabel.text = resultedProducts.addresses[indexPath.row]
            cell.viewsLabel.text = "\(resultedProducts.views[indexPath.row])"
            let advPictureUrl = resultedProducts.advertisingImages[indexPath.row]
            let userImage = resultedProducts.userImages[indexPath.row]
            if resultedProducts.fav[indexPath.row] == 0 {
                cell.favBtn.setImage(UIImage(named:"12"), for: .normal)
                
            }else{
                cell.favBtn.setImage(UIImage(named:"iconfinder_heart_299063"), for: .normal)
                
            }
            DispatchQueue.main.async {
                let url = URL(string : advPictureUrl)
                cell.advImageView.kf.indicatorType = .activity
                cell.advImageView.kf.setImage(with: url)
                
                let userUrl = URL(string: userImage)
                cell.sellerImageView.kf.indicatorType = .activity
                cell.sellerImageView.kf.setImage(with: userUrl)
                cell.sellerImageView.layer.borderWidth = 1
                cell.sellerImageView.layer.masksToBounds = false
                cell.sellerImageView.layer.borderColor = UIColor.clear.cgColor
                cell.sellerImageView.layer.cornerRadius = cell.sellerImageView.frame.height/2
                cell.sellerImageView.clipsToBounds = true
            }
            cell.favBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action:#selector(favButtonAction), for: .touchUpInside)
        }
        else{
            cell.titleLabel.text = returnedProducts.titles[indexPath.row]
            cell.dateLabel.text = convertDateFormater(returnedProducts.date[indexPath.row])
            cell.priceLabel.text = returnedProducts.prices[indexPath.row]
            cell.addressLabel.text = returnedProducts.addresses[indexPath.row]
            cell.viewsLabel.text = "\(returnedProducts.views[indexPath.row])"
            let advPictureUrl = returnedProducts.advertisingImages[indexPath.row]
            let userImage = returnedProducts.userImages[indexPath.row]
            if returnedProducts.fav[indexPath.row] == 0 {
                cell.favBtn.setImage(UIImage(named:"12"), for: .normal)
                
            }else{
                cell.favBtn.setImage(UIImage(named:"iconfinder_heart_299063"), for: .normal)
                
            }
            DispatchQueue.main.async {
                let url = URL(string : advPictureUrl)
                cell.advImageView.kf.indicatorType = .activity
                cell.advImageView.kf.setImage(with: url)
                
                let userUrl = URL(string: userImage)
                cell.sellerImageView.kf.indicatorType = .activity
                cell.sellerImageView.kf.setImage(with: userUrl)
                cell.sellerImageView.layer.borderWidth = 1
                cell.sellerImageView.layer.masksToBounds = true
                cell.sellerImageView.layer.borderColor = UIColor.clear.cgColor
                cell.sellerImageView.layer.cornerRadius = cell.sellerImageView.frame.height/2
                cell.sellerImageView.clipsToBounds = true
                
                
            }
            cell.favBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action:#selector(favButtonAction), for: .touchUpInside)
        }
        
        return cell
    }
    @objc func favButtonAction(_ sender : UIButton) {
        var id = returnedProducts.id[sender.tag]
        
        if searching{
            id = resultedProducts.id[sender.tag]
        }else{
            id = returnedProducts.id[sender.tag]
        }
        
        
        print(returnedProducts.id[sender.tag])
        
        var value = 0
        if sender.imageView?.image == UIImage(named:"iconfinder_heart_299063"){
            value = 0
        }else{
            value = 1
        }
        
        
        self.view.lock()
        let parameters : [String : Any] = ["user_id" : User.sharedInstance.id!, "product_id" : id ,"value" : value]
        print(parameters)
        api.addFavoriteProduct(serviceName: ServiceName.AddFavorite.rawValue, parameters: parameters ) { (response) in
            print(response)
            self.view.unlock()
            let code = response["code"] as! Int
            if code  == 200{
                self.getProdecut()
                let alert = UIAlertController(title: "Congratulation", message: "This item is added successfully to Favorites list", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        print(selectedIndexPath?.row)
        performSegue(withIdentifier: "productDetailsScene", sender: nil)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print( ( self.view.frame.width / 2) - 50)
        return CGSize(width: self.width , height: 300)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        getProdecut()
    }
}


// PickerView Functions
extension ProductsViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("CATEGORIES" , categoriesArr)
        return categoriesArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isHidden = true
        view.lock()
        
        let parameters : [String:Any] = ["cat_id" : 1 , "user_id" : User.sharedInstance.id!]
        api.findByCategory(serviceName: ServiceName.searchByCategory.rawValue, parameters: parameters  ) { [weak self](response) in
            self!.view.unlock()
            
            self!.returnedProducts.userId.removeAll()
            self!.returnedProducts.id.removeAll()
            self!.returnedProducts.titles.removeAll()
            self!.returnedProducts.date.removeAll()
            self!.returnedProducts.prices.removeAll()
            self!.returnedProducts.addresses.removeAll()
            self!.returnedProducts.fav.removeAll()
            self!.returnedProducts.views.removeAll()
            self!.returnedProducts.advertisingImages.removeAll()
            self!.returnedProducts.userImages.removeAll()
            self!.products = response["Products"] as! [[String:Any]]
            self!.view.unlock()
            print(response)
            for result in self!.products {
                print("RESULT" , result["user"])
                
                let user = result["user"] as! [[String:Any]]
                print(user.first?["id"] as! Int)
                
                if user.first?["img"] is String {
                    self!.returnedProducts.userImages.append("http://aqary.elroily.com/Upload/user/\((user.first?["img"])!)" )
                    print("http://aqary.elroily.com/Upload/user/\((user.first?["img"])!)")
                }else {
                    self!.returnedProducts.userImages.append("https://cdn0.iconfinder.com/data/icons/elasto-online-store/26/00-ELASTOFONT-STORE-READY_user-circle-512.png")
                }
                self!.returnedProducts.userId.append(user.first?["id"] as! Int)
                self!.returnedProducts.id.append(result["id"] as! Int)
                print("ID" ,  self!.returnedProducts.id)
                self!.returnedProducts.titles.append(result["ar_title"] as! String)
                self!.returnedProducts.date.append(result["created_at"] as! String)
                self!.returnedProducts.prices.append( result["price"] as! String)
                self!.returnedProducts.addresses.append(result["address"] as!String)
                self!.returnedProducts.fav.append(result["favorite"] as!Int)
                self!.returnedProducts.views.append(result["view"] as! Int)
                if result["image"] is [String:Any] {
                    let image = result["image"] as! [String :Any]
                    self!.returnedProducts.advertisingImages.append("http://aqary.elroily.com/Upload/Product/\(image["img"]!)")
                }else{
                    self!.returnedProducts.advertisingImages.append("https://cdn0.iconfinder.com/data/icons/elasto-online-store/26/00-ELASTOFONT-STORE-READY_user-circle-512.png")
                }
                self!.productsCollectionView.reloadData()
            }
        }
    }
}
