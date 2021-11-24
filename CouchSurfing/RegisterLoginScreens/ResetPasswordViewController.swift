

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    
    // MARK:- IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var ResetPasswordButton: UIButton!
    
    let customOrange: UIColor = UIColor(red: 242/255, green: 65/255, blue: 49/255, alpha: 1)
    
    // MARK:- ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailView.setupShadowAndRadius()
        
        emailTextField.setupLeftImage(imageName: "Email Icon")
        
        ResetPasswordButton.layer.cornerRadius = 5
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(firstRecognizerClicked(_:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK:- IBActions
    @IBAction func ResetPasswordButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text {
            Auth.auth().languageCode = "ru"
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if error != nil {
                    let errorMessage = error?.localizedDescription ?? "Error"
                    let alertVC = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertVC.addAction(action)
                    self.present(alertVC, animated: true, completion: nil)
                } else {
                    let alertVC = UIAlertController(title: nil, message: "Check your email", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertVC.addAction(action)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
    
//    MARK:- Functions
    @objc func keyboardDidShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height + 15
    }

    @objc func keyboardDidHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }

    @objc func firstRecognizerClicked(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
