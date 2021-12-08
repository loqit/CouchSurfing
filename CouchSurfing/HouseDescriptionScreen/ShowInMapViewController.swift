

import UIKit
import Kingfisher


class ShowInMapViewController: UIViewController {
    var photoUrlString: String = ""

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let photoUrl = URL(string: photoUrlString) else { return }
//        self.image.kf.setImage(with: photoUrl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let photoUrl = URL(string: photoUrlString) else { return }
        self.imageView.kf.setImage(with: photoUrl)
    }
}

