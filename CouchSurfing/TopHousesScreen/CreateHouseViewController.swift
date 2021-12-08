//
//  CreateHouseViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 30.11.21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class CreateHouseViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var houseImageView: UIImageView!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var descTextField: UITextView!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var capacityTextField: UITextField!
    
    
    private let storage = Storage.storage()
    private let storageRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        capacityTextField.delegate = self
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func configureUI() {
        descTextField.layer.cornerRadius = 10
        descTextField.layer.borderWidth = 1
        descTextField.layer.borderColor = CSConstans.customOrange.cgColor
    }
    
    
    @IBAction func cancelCreating(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func configurePropertyDict(with houseID: String, urlString: String) -> [String: Any] {
        
        let userOwnerID = Auth.auth().currentUser!.uid
        
        let title = titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let address = adressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let city = cityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let desc = descTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let counrty = countryTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let ratingID = UUID().uuidString
        let capacityText = capacityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let capacity = Int(capacityText) ?? 2
        let propertyDict = ["Title": title, "Country":counrty,"City":city, "Address":address, "Description": desc, "Capacity": capacity, "HouseID": houseID, "ImageURL": urlString, "LandlordID": userOwnerID] as [String : Any]
        setupRating(with: houseID, ratingID: ratingID)
        
        print(propertyDict)
        return propertyDict
    }
    
    private func setupRating(with houseID: String, ratingID: String) {
        // creating new object
        let ratingDict: [String: Any] = ["HouseID": houseID, "MarksSum": 0, "MarksCount": 0, "Value": 0.0]
        
        // saving it to db
        let db = Firestore.firestore()
        db.collection("ratings").document(houseID).setData(ratingDict)
    }
    
    @IBAction func createHouse(_ sender: UIButton) {
        
        let userOwnerID = Auth.auth().currentUser!.uid
        let houseID = UUID().uuidString
        
        let ref = CSConstans.setHouseImageRef(userOwnerID: userOwnerID, houseID: houseID)
        let imgRef = storageRef.child(ref)
        
        let image = houseImageView.image
        guard let imageData = image?.pngData() else { return }

        var imageURLString = ""
        DispatchQueue.global().async {
            // Upload image to Storage
            imgRef.putData(imageData, metadata: nil) { _, error in
                guard error == nil else { return }
                // Save image url to db
                imgRef.downloadURL { url, error in
                    guard let url = url, error == nil else { return }
                    imageURLString = url.absoluteString
                    let propertyDict = self.configurePropertyDict(with: houseID, urlString: imageURLString)
                    self.saveHouse(with: propertyDict, named: houseID)
                    self.clearFields()
                }
            }
        }
        self.dismiss(animated: true)
    }
    
    private func clearFields() {
        self.titleTextField.text = nil
        self.adressTextField.text = nil
        self.cityTextField.text = nil
        self.countryTextField.text = nil
        self.descTextField.text = nil
        self.houseImageView.image = nil
    }
    
    // Saving house to Firestore
    private func saveHouse(with propertyDict: [String: Any], named houseID: String) {
        let db = Firestore.firestore()
        db.collection("houses").document(houseID).setData(propertyDict)
        /*
        db.collection("houses").addDocument( data: propertyDict) { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not create new property", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }*/
    }
}

extension CreateHouseViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        houseImageView.image = image
        dismiss(animated: true)
    }
}

extension CreateHouseViewController: UINavigationControllerDelegate {}

extension CreateHouseViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"12345").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
