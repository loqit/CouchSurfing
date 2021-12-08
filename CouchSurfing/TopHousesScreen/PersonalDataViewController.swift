//
//  PersonalDataViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 6.12.21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class PersonalDataViewController: UIViewController {
    
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var oldPaswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextFiedl: UITextField!
    @IBOutlet weak var subNewPasswordTextField: UITextField!
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        
        oldPaswordTextField.isSecureTextEntry = true
        newPasswordTextFiedl.isSecureTextEntry = true
        subNewPasswordTextField.isSecureTextEntry = true
        
        subNewPasswordTextField.delegate = self
        newPasswordTextFiedl.delegate = self
        
        dissablePasswordButton()
        
        passwordButton.layer.cornerRadius = 10
        phoneButton.layer.cornerRadius = 10

    }
    
    private func dissablePasswordButton() {
        passwordButton.isEnabled = false
        passwordButton.backgroundColor = .gray
        passwordButton.tintColor = .white
    }
    
    private func enablePasswordButton() {
        passwordButton.isEnabled = true
        passwordButton.backgroundColor = .systemGreen
    }
    
    private func enablePhoneButton() {
        phoneButton.isEnabled = true
        phoneButton.backgroundColor = .systemGreen
    }
    
    @IBAction func savePhoneNumber(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).updateData(["PhoneNumber": phoneNumber])
    }
    
    @IBAction func updatePassword(_ sender: UIButton) {
        validatePasswordFields()
    }
    
    private func clearFields() {
        oldPaswordTextField.text = nil
        newPasswordTextFiedl.text = nil
        subNewPasswordTextField.text = nil
    }
    
    private func validatePasswordFields() {
        let newPassword = newPasswordTextFiedl.text
        let subNewPassword = subNewPasswordTextField.text
        guard let newPass = newPassword, newPass == subNewPassword, newPass.count >= 8 else { return }
        
        let oldPassword = oldPaswordTextField.text ?? ""
        let user = Auth.auth().currentUser
        let userEmail = user?.email ?? ""
        
        let credentials = EmailAuthProvider.credential(withEmail: userEmail, password: oldPassword)
        user?.reauthenticate(with: credentials, completion: { result, error in
            if error != nil {
                let alert = UIAlertController(title: "Wrong Password", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
                self.clearFields()
            } else {
                user?.updatePassword(to: newPass)
                self.clearFields()
            }
        })
    }
    
}

extension PersonalDataViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        enablePasswordButton()
    }
}

