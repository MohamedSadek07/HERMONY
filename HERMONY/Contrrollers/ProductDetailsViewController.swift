//
//  ProductDetailsViewController.swift
//  HERMONY
//
//  Created by Mohamed Ahmed Sadek on 5/1/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit
import ImageSlideshow

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var addTofevLbl: UILabel!
    @IBOutlet weak var heartImge: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var advImageView: UIImageView!
    @IBOutlet weak var sellerImageView: UIImageView!
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var phone = ""
    var lat = ""
    var lng = ""
    var id : Int?
    var userId : Int?
    let api = BackendApi()
//     var  kingfisherSource = [KingfisherSource]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        slideShow.slideshowInterval = 2.0
//        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
//        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
//        let pageControl = UIPageControl()
//        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
//        pageControl.pageIndicatorTintColor = UIColor.black
//        slideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
//        slideShow.activityIndicator = DefaultActivityIndicator()
//        slideShow.delegate = self
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
//        slideShow.setImageInputs(kingfisherSource as! [InputSource])
        getData()
    }
    
    
    
    func getData()  {
        self.view.lock()
        let parameters = ["user_id" : userId! , "id" : id!]
    print(parameters)
        api.retreivingProductDetails(serviceName: ServiceName.Productbyid.rawValue, parameters: parameters as! [String : Int]) {[weak self] (response) in
            print(response)
            self!.view.unlock()
            if response["Product"] != nil{
                let product = response["Product"] as! [String:Any]
                self!.dateLabel.text = self!.convertDateFormater((product["created_at"] as? String)!)
                self!.addressLabel.text = product["address"] as? String
                self!.priceLabel.text = "\((product["price"] as? String)!) ريال"
                self!.descriptionTextView.text = product["ar_description"] as? String
                self!.numberOfViews.text =  "\((product["view"] as? Int)!)"
                self!.titleLbl.text = product["ar_title"] as? String
                self!.lat = (product["lat"] as? String)!
                self!.lng = (product["lng"] as? String)!
                
                // handling Seller Image
                let user = product["user"] as! [String:Any]
                if  user["img"] is String {
                    self!.sellerImageView.kf.setImage(with : URL(string: "http://aqary.elroily.com/Upload/user/\((user["img"])!)"))
                } else {
                    self!.sellerImageView.kf.setImage(with: URL(string: "https://cdn0.iconfinder.com/data/icons/elasto-online-store/26/00-ELASTOFONT-STORE-READY_user-circle-512.png"))
                }
//                favorite
                var fav = product["favorite"] as! Int
                print(fav)
                if fav == 0 {
                    self!.heartImge.image = UIImage(named:"12")
                    
                }else{
                    self!.heartImge.image = UIImage(named:"iconfinder_heart_299063")
                }
                
                // handling image slider
                let images = product["images"] as! [[String:Any]]
                for image in images {
                    if  image["img"] is String {
//                        self.kingfisherSource.append(KingfisherSource(urlString:"http://aqary.elroily.com/Upload/user/\((image["img"])!)")!)
                   // self!.advImages.append(image["img"] as! String)
                    }
                    
                }
//                phone
                self!.phone = (user["phone"] as? String)!
            }
            
        }
    }
        
    @IBAction func phoneBtn(_ sender: Any) {
        print(self.phone)
         if let url = URL(string: "tel://\(self.phone)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
//        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func addressBtn(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(self.lat),\(self.lng)&directionsmode=driving")! as URL)
            
        } else {
            NSLog("Can't use comgooglemaps://");
        }
    
    }
    @IBAction func addfevBtn(_ sender: Any) {
            addFavoriteButtonAction()
        }
        
        func addFavoriteButtonAction(){
            var value = 0
            if self.heartImge.image == UIImage(named:"iconfinder_heart_299063"){
                value = 0
            }else{
                value = 1
            }
            
            
            self.view.lock()
            let parameters : [String : Any] = ["user_id" : userId!, "product_id" : id! ,"value" : value]
            api.addFavoriteProduct(serviceName: ServiceName.AddFavorite.rawValue, parameters: parameters ) { (response) in
                print(response)
                self.view.unlock()
                let code = response["code"] as! Int
                if code  == 200{
                    if self.heartImge.image == UIImage(named:"iconfinder_heart_299063"){
                        self.heartImge.image = UIImage(named:"12")
                        
                    }else{
                       self.heartImge.image = UIImage(named:"iconfinder_heart_299063")
                    }
                    self.addTofevLbl.isHidden = true
                    let alert = UIAlertController(title: "Congratulation", message: "This item is added successfully to Favorites list", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
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

//extension ProductDetailsViewController: ImageSlideshowDelegate {
//    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
//        print("current page:", page)
//    }
//}
