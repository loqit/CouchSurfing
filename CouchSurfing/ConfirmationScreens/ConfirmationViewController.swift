

import UIKit
import SwiftConfettiView

class ConfirmationViewController: UIViewController {
    
    @IBOutlet weak var confettiView: SwiftConfettiView!
    @IBOutlet weak var goBackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "Booking"
        
        if let confettiImage = UIImage(named: "leaf") {
//            confettiImage.scale =
//            CGSize.init(width: 3, height: 3)
            confettiView.type = .image(confettiImage)
            confettiView.colors = [UIColor.red, UIColor.orange, UIColor.systemPink]
            confettiView.intensity = 0.7
            confettiView.startConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                self.confettiView.stopConfetti()
            }
        }
            
        goBackButton.layer.cornerRadius = 5
        
        navigationItem.hidesBackButton = true
        
    }
    
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
    }
    @IBAction func unwindSegueToConfirmationScreen(segue: UIStoryboardSegue) {
        
    }
}
