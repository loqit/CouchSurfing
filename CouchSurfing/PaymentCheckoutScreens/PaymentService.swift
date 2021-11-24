

import Foundation
import UIKit

class PaymentService {
    var paymentServices = [Service]()
    
    init() {
        setup()
    }
    
    func setup() {
        let paymentService1 = Service(logoImage: UIImage(named: "Google Pay")!, seviceName: "Google Pay", arrowImage: UIImage(named: "Arrow")!)
        let paymentService2 = Service(logoImage: UIImage(named: "VISA")!, seviceName: "VISA", arrowImage: UIImage(named: "Arrow")!)
        let paymentService3 = Service(logoImage: UIImage(named: "Master Card")!, seviceName: "Master Card", arrowImage: UIImage(named: "Arrow")!)
        let paymentService4 = Service(logoImage: UIImage(named: "Debit Card")!, seviceName: "Debit Card", arrowImage: UIImage(named: "Arrow")!)
        let paymentService5 = Service(logoImage: UIImage(named: "Paytm")!, seviceName: "Paytm", arrowImage: UIImage(named: "Arrow")!)
        
        self.paymentServices = [paymentService1, paymentService2, paymentService3, paymentService4, paymentService5]
    }
}
