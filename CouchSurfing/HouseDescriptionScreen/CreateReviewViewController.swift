//
//  CreateReviewViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 4.12.21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class CreateReviewViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var reviewTextField: UITextView!
    @IBOutlet weak var markTextField: UITextField!
    
    var houseID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        markTextField.delegate = self
        reviewTextField.layer.cornerRadius = 10
        reviewTextField.layer.borderWidth = 1
        reviewTextField.layer.borderColor = CSConstans.customOrange.cgColor
    }
    
    @IBAction func publishReview(_ sender: UIButton) {
        guard let houseID = houseID else { return }
        
        let reviewID = houseID + Auth.auth().currentUser!.uid
        
        let reviewDict = configureReviewDict(with: houseID, urlString: "", reviewID: reviewID)
        updateRating(with: Int(reviewDict["Mark"]!) ?? 0, houseID: houseID, reviewID: reviewID, reviewDict: reviewDict)
        
        self.titleTextField.text = nil
        self.markTextField.text = nil
        self.reviewTextField.text = nil
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelPublishing(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func configureReviewDict(with houseID: String, urlString: String, reviewID: String) -> [String: String] {
        let authorID = Auth.auth().currentUser!.uid
        let title = titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let review = reviewTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mark = markTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let markValue = Int(mark) ?? 0
        print(markValue)
        
        let reviewDict = ["ReviewID": reviewID, "Title": title, "Text": review, "Mark": mark, "HouseID": houseID, "ImageURL": urlString, "AuthorID": authorID]
        return reviewDict
    }
    
    private func updateRating(with mark: Int, houseID: String, reviewID: String, reviewDict: [String: String]) {
        if mark != 0 {
            let db = Firestore.firestore()
            let markRef = db.collection("ratings").document(houseID)
            let reviewRef = db.collection("reviews").document(reviewID)
            
            var rating: [String: Any]?
            // get marks
            markRef.getDocument { document, error in
                if let document = document, document.exists {
                    rating = document.data()
                    guard let rating = rating else {
                        return
                    }
                    var marksCount = rating["MarksCount"] as? Int ?? 0
                    var marksSum = rating["MarksSum"] as? Int ?? 0
                    var ratingValue = rating["Value"] as? Float ?? 0.0
                    
                    reviewRef.getDocument { document, error in
                        if let document = document, document.exists {
                            let oldMark = document["Mark"] as? Int ?? 1
                            marksSum -= oldMark
                            marksSum += mark
                            ratingValue = Float(marksSum / marksCount)
                            let ratingDict: [String: Any] = ["HouseID": houseID, "MarksSum": marksSum, "MarksCount": marksCount, "Value": ratingValue]
                            markRef.setData(ratingDict)
                            self.saveReview(with: reviewDict, reviewID: reviewID)
                        } else {
                            marksCount += 1
                            marksSum += mark
                            // update rating with new mark
                            ratingValue = Float(marksSum / marksCount)
                            // save rating
                            let ratingDict: [String: Any] = ["HouseID": houseID, "MarksSum": marksSum, "MarksCount": marksCount, "Value": ratingValue]
                            markRef.setData(ratingDict)
                            self.saveReview(with: reviewDict, reviewID: reviewID)
                        }
                    }
            }
            }
        }
    }
    
    // Saving review to Firestore
    private func saveReview(with reviewDict: [String: String], reviewID: String) {
        let db = Firestore.firestore()
        db.collection("reviews").document(reviewID).setData(reviewDict)
    }
}

extension CreateReviewViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"12345").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
