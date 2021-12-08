//
//  UserProfileViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 24.11.21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userNameTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfile()
    }
    
    private func configureProfile() {
        userNameTextView.isEditable = false
        getUserData()
    }
    
    private func getUserData() {
        let db = Firestore.firestore()
        var dict: [String: Any] = [:]
        DispatchQueue.global().async {
            db.collection("users").whereField("UserID", isEqualTo: Auth.auth().currentUser!.uid)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            dict = document.data()
                        }
                        self.updateTableView(with: dict)
                    }
            }
        }
    }
    
    func updateTableView(with data: [String: Any]) {
        DispatchQueue.main.async {
            let userName = data["Name"] as? String ?? "UserName"
            self.userNameTextView.text = userName
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        performSegue(withIdentifier: "goToRegisterLoginStoryboard", sender: nil)
    }
}
