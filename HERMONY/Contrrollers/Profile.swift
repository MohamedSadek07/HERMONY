//
//  ViewController.swift
//  هرموني
//
//  Created by Magdy rizk on 3/13/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import Alamofire
class Profile: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var profileCollectioView: UICollectionView!
    let api = BackendApi()
    var imagesArray = [String]()
    let pickerController = UIImagePickerController()
    
//    var isUploadImages = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print(User.sharedInstance.img)
       if User.sharedInstance.img != ""{
        let urlString = "http://aqary.elroily.com/Upload/user/\(User.sharedInstance.img)"
        
        print("IMAGE URL" , urlString)
        let url = URL(string : urlString)
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                print(url)
                self.userImageView.kf.indicatorType = .activity
                self.userImageView.kf.setImage(with: url)
            }
        }
        }else{
        
            self.userImageView.image = UIImage(named: "pic profile")
        }
        
        
       
        profileCollectioView.delegate = self
        profileCollectioView.dataSource = self
        
        userNameTextField.text = User.sharedInstance.name
        emailTextField.text = User.sharedInstance.email
        phoneNumberTextField.text = User.sharedInstance.phone
        editButton.setTitle("تعديل", for: .normal)
        
        userNameTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        phoneNumberTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
        

        
        userImageView.layer.borderWidth = 1
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.clear.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height/2 + 15
        userImageView.clipsToBounds = true
        
        
        // requesting Most Viewed Products
        self.view.lock()
        api.requestMostViewProducts { [weak self] (response) in
            let products = response["Products"] as! [[String:Any]]
            self!.view.unlock()
            for product in products {
                print(product["img"])
                self!.imagesArray.append(product["img"] as! String)
                
            }
            print(self?.imagesArray.count)
            self?.profileCollectioView.reloadData()
            //           do {
            //                let data = try JSONSerialization.data(withJSONObject: response, options: [])
            //                let obj = try JSONDecoder().decode(MostViewedProducts.self, from: data)
            //                let products = obj.Products
            //                print(products)
            //            }catch{
            //                print("Error while decoding MostViewedProducts")
            //            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = profileCollectioView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MostVisitedCollectionViewCell
        
        let urlString = "http://aqary.elroily.com/Upload/Product/\(imagesArray[indexPath.row])"
        print("IMAGE URL" , urlString)
            
//        DispatchQueue.main.async {
//            let url = URL(string : urlString)
//            print(url)
//            cell.productImageView.kf.indicatorType = .activity
//            cell.productImageView.kf.setImage(with: url)
//        }
           let url = URL(string : urlString)
        
        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
               
                            print(url)
                            cell.productImageView.kf.indicatorType = .activity
                            cell.productImageView.kf.setImage(with: url)
                }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let length = collectionView.frame.size.width / 2
        return CGSize(width: length, height: length)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }


    @IBAction func imageButtonAction(_ sender: UIButton) {
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
        DispatchQueue.main.async {
            self.present(self.pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func updateProfileButton(_ sender: UIButton) {
        if sender.titleLabel!.text == "حفظ" {
            self.uploadImage(completion: {isSuccess in
//                self.circularProgress.isHidden = true
                
                if isSuccess{
                //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification_UserInfoChanged), object: nil)
                
//                if self.isDataChanged{
////                self.editInfo()
//                }
//                else{
////                self.close(self)
//                }
                }
                else{
//                self.editBarButton.isEnabled = true
                }
            }
       ) }
        else {
            DispatchQueue.main.async {
                sender.setTitle("حفظ", for: .normal)
            }
        userNameTextField.isUserInteractionEnabled = true
        userNameTextField.becomeFirstResponder()
        emailTextField.isUserInteractionEnabled = true
        phoneNumberTextField.isUserInteractionEnabled = true
        passwordTextField.isUserInteractionEnabled = true
        }
    }
    
    func uploadImage( completion: @escaping (Bool) -> Void){
        if User.sharedInstance.phone == phoneNumberTextField.text {
            
            let alert = UIAlertController(title: "Error", message: "You should enter different number in order to proceed", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        } else {
            DispatchQueue.main.async{
                
                let urlString = "\(hostName)\(ServiceName.UpdateProfile.rawValue)"
                print("urlString:\(urlString)")
                
                
                
                
                let parameters = ["phone": self.phoneNumberTextField.text!,"name":self.userNameTextField.text!,"email": self.emailTextField.text!,"address": User.sharedInstance.address ,"user_id":User.sharedInstance.id ,"password":"123456"] 
                //            let URL = try! URLRequest(url: urlString, method: .post, headers: header)
                
                let imageName = "image_\(Date().timeIntervalSince1970).jpg"
                Alamofire.upload(multipartFormData: { (MultipartFormData) in
                    
                    if let resizedImage = self.userImageView.image{
                        if  let imageData = UIImageJPEGRepresentation(resizedImage, 0.3) {
                            MultipartFormData.append(imageData, withName: "image", fileName: imageName, mimeType: "image/jpg")
                        }
                    }
                    
                    for (key, value) in parameters {
                        MultipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
                    }
                }, to: urlString, headers: nil, encodingCompletion: { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress_) in
                            print("Upload Progress: \(progress_.fractionCompleted)")
                            
                            DispatchQueue.main.async{
//                                if !self.uploadImage{
//                                    print("Upload Progress: \(progress_.fractionCompleted)")
                                
//                                    progress(progress_.fractionCompleted)
//                                }
                            }
                        })
                        
                        upload.responseJSON { response in
                            print(response)
                            completion(true)
                        }
                        
                    case .failure(let encodingError):
                        print(encodingError)
                        self.showAlertWithTitle("Error".localized, message: "There is a problem on server".localized)
                        print("encodingError:\(encodingError)")
                        completion(false)
                    }
                    
                })
            }
            
            
            
            userNameTextField.isUserInteractionEnabled = false
            emailTextField.isUserInteractionEnabled = false
            phoneNumberTextField.isUserInteractionEnabled = false
            passwordTextField.isUserInteractionEnabled = false
        }


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Profile : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        userImageView.image = pickedImage
       
        picker.dismiss(animated: true, completion: nil)
    }
}
extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
