//
//  AddAdvertisingViewController.swift
//  HERMONY
//
//  Created by Mohamed Ahmed Sadek on 4/30/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class AddAdvertisingViewController: UIViewController ,GMSPlacePickerViewControllerDelegate {

    @IBOutlet weak var chosseImageBtn: UIButton!
    @IBOutlet weak var priceTXT: UITextField!
    @IBOutlet weak var addressTXT: UITextField!
    @IBOutlet weak var englishDescTXT: UITextField!
    @IBOutlet weak var arabicDescTXT: UITextField!
    @IBOutlet weak var engilshNameTXT: UITextField!
    
    @IBOutlet weak var arabicNameTXT: UITextField!
    @IBOutlet weak var advArabicNameLabel: UILabel!
    
    @IBOutlet weak var advArabicNameTextField: UITextField!
    
    @IBOutlet weak var firstLineLabel: UILabel!
    
    
    var lat : CLLocationDegrees = 0.0
    var lng : CLLocationDegrees = 0.0
    
    let pickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "آضف اعلانك"
        
       
        
       
    
    }
    @IBAction func addAdvBtn(_ sender: Any) {
        postAdd()
    }
    
    
    func postAdd(){
        self.view.lock()
        self.view.endEditing(true)
        DispatchQueue.main.async{
            self.view.lock()
            let parameters =   ["ar_title": self.arabicNameTXT.text!, "en_title": self.engilshNameTXT.text!,"ar_description": self.arabicDescTXT.text!, "en_description": self.englishDescTXT.text!, "cat_id": 1,"price": self.priceTXT.text!, "user_id": User.sharedInstance.id,
                                "lat": "\(self.lat)", "lng": "\(self.lng)","address": self.addressTXT.text!] as [String : Any]
           
            let api = BackendApi()
            print(parameters)
            api.perform(serviceName: ServiceName.Store_Product, parameters: parameters as [String : AnyObject]?) { (JSON, String) -> Void in
                if String != nil{
                    self.view.unlock()
                    self.showAlertWithTitle("Alert".localized, message: String!)
                }
                else{
                    print(JSON)
                    User.sharedInstance.getDateFromJSON(JSON!["userdata"])
                    User.sharedInstance.saveData()
                    
                    User.sharedInstance.setIsRegister(true)
                    print(User.sharedInstance.email)
                    print(User.sharedInstance.name)
                    print(User.sharedInstance.phone)
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.setHomeViewAsRoot()
                    
                    
                    
                }
            }
            
        }
    }
    
    
    
    @IBAction func pickPlace(_ sender: UIButton) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
        self.lat = place.coordinate.latitude
        self.lng = place.coordinate.longitude
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    
    
    
    
    
    @IBAction func imageButtonAction(_ sender: UIButton) {
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
        DispatchQueue.main.async {
            self.present(self.pickerController, animated: true, completion: nil)
        }
    }


}
extension AddAdvertisingViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        advArabicNameLabel.textColor = .red
        firstLineLabel.textColor = .red
        advArabicNameTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.advArabicNameLabel.center = CGPoint(x: self.advArabicNameLabel.center.x, y: self.advArabicNameLabel.center.y - 10 )
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        advArabicNameLabel.textColor = .blue
        firstLineLabel.textColor = .blue
    }
}
extension AddAdvertisingViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
//        userImageView.image = pickedImage
        
        picker.dismiss(animated: true, completion: nil)
    }
}
