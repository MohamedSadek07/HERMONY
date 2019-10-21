//
//  FavoritesViewController.swift
//  HERMONY
//
//  Created by Mohamed Ahmed Sadek on 5/8/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
   

    
   
    @IBOutlet weak var collectionview: UICollectionView!
    let api = BackendApi()
    var returnedProducts = RetreivedProducts()
      var selectedIndexPath : IndexPath?
    var products = [[String:Any]]()
    var results = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.delegate = self
        collectionview.dataSource = self
         getMyfavorites()
        self.title = "الاعلانات المفضله"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

    
    func getMyfavorites(){
        self.view.lock()
        let parameters = ["user_id" : User.sharedInstance.id! ]//User.sharedInstance.id]
        print("USER ID" , User.sharedInstance.id!)
        
        api.myFavorites(serviceName: ServiceName.MyFavorites.rawValue, parameters: parameters , completion: { [weak self] (response) in
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
                self!.returnedProducts.views.append(result["view"] as! Int)
                if result["image"] is [String:Any] {
                    let image = result["image"] as! [String :Any]
                    self!.returnedProducts.advertisingImages.append("http://aqary.elroily.com/Upload/Product/\(image["img"]!)")
                }else{
                    self!.returnedProducts.advertisingImages.append("https://cdn0.iconfinder.com/data/icons/elasto-online-store/26/00-ELASTOFONT-STORE-READY_user-circle-512.png")
                }
                
            }
            self!.collectionview.reloadData()
            print()
            })
        
    }
    

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(returnedProducts.titles.count)
    return  returnedProducts.titles.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductsCollectionViewCell
    print(indexPath.row)
    print(returnedProducts.titles[0])
    cell.titleLabel.text = returnedProducts.titles[indexPath.row]
    cell.dateLabel.text = convertDateFormater(returnedProducts.date[indexPath.row])
    cell.priceLabel.text = returnedProducts.prices[indexPath.row]
    cell.addressLabel.text = returnedProducts.addresses[indexPath.row]
    cell.viewsLabel.text = "\(returnedProducts.views[indexPath.row])"
    let advPictureUrl = returnedProducts.advertisingImages[indexPath.row]
    let userImage = returnedProducts.userImages[indexPath.row]
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
    return cell
}
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        print(selectedIndexPath?.row)
        performSegue(withIdentifier: "details", sender: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(selectedIndexPath?.row)
      
            let detailsVC = segue.destination as! ProductDetailsViewController
            detailsVC.id = returnedProducts.id[selectedIndexPath!.row]
            detailsVC.userId = returnedProducts.userId[selectedIndexPath!.row]
        
        
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
    
}
class RequestedProducts{
    
}
