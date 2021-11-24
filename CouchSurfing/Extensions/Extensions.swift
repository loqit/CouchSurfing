//
//  Extensions.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 28.10.21.
//

import Foundation
import UIKit

// MARK:- ExtensionUITextField
extension UITextField {
    
    // Set Image on the right of text fields
    func setupRightImage(imageName:String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: imageName)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageContainerView.addSubview(imageView)
        rightView = imageContainerView
        rightViewMode = .always
        self.tintColor = .lightGray
    }
    
    //Set Image on left of text fields
    func setupLeftImage(imageName:String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: imageName)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageContainerView.addSubview(imageView)
        leftView = imageContainerView
        leftViewMode = .always
        self.tintColor = .lightGray
    }
    
    //    func setupShadowAndRadius() { // почему не срабатывает это имя?
    func setShadowAndRadius() {
        //        self.layer.cornerRadius = 5 // почему не получается задать тень для TextField
        //        self.layer.shadowColor = UIColor.gray.cgColor
        //        self.layer.shadowOpacity = 1
        //        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        //        self.layer.shadowRadius = 3
        
        //        self.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
        //        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        //        self.layer.shadowColor = UIColor.black.cgColor //Any dark color
        
        //        self.layer.masksToBounds = false
        //        self.layer.shadowRadius = 4.0
        //        self.layer.shadowColor = UIColor.black.cgColor
        //        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        //        self.layer.shadowOpacity = 1.0
        
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = false
        self.layer.shadowOpacity=0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

// MARK:- ExtensionUIView
extension UIView {
    
    // Set shadow and radius of View
    func setupShadowAndRadius() {
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3
    }
}
