

import UIKit
import Kingfisher

class HouseDescriptionViewController: UIViewController {
    
    var hotelOnMapImageUrl: String = ""
    var hotel: Result?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var bookNowButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        galleryButton.layer.cornerRadius = 5
        bookNowButton.layer.cornerRadius = 5
        imageView.layer.cornerRadius = 5
        
        guard let hotelId = hotel?.id else { return }
        
        NetworkManagerDetails.fetch(hotelId: String(hotelId), locale: "ru_RU") { [weak self] (details) in
            guard let self = self else {return}
            let countryName = details.data?.body?.propertyDescription?.localisedAddress?.countryName ?? "-"
            let cityName = details.data?.body?.propertyDescription?.localisedAddress?.cityName ?? "-"
            let overviewContent = details.data?.body?.overview?.overviewSections?[0].content ?? []
            let mapImageUrl = details.data?.body?.propertyDescription?.mapWidget?.staticMapUrl ?? ""
            
            self.hotelOnMapImageUrl = mapImageUrl
            self.nameLabel.text = details.data?.body?.propertyDescription?.name
            self.locationLabel.text = "\(countryName), \(cityName)"
            self.textView.text = details.data?.body?.overview?.overviewSections?[0].content?[0]
            var overviewContentString: String = ""
            
            for item in overviewContent {
                overviewContentString = overviewContentString == "" ? item : "\(overviewContentString). \(item)"
            }
            
            self.textView.text = overviewContentString
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let photoString = hotel?.optimizedThumbUrls?.srpDesktop else { return }
        guard let photoUrl = URL(string: photoString) else { return }
        self.imageView.kf.setImage(with: photoUrl)
    }
    
    @IBAction func galleryButtonPressed(_ sender: UIButton) {
    }
    @IBAction func showInMapButtonPressed(_ sender: UIButton) {
        guard let destinationVC = storyboard?.instantiateViewController(identifier: "ShowInMapViewController") as? ShowInMapViewController else { return }
        destinationVC.photoUrlString = hotelOnMapImageUrl
        navigationController?.pushViewController(destinationVC, animated: true)
        
//        let destinationVC = ShowInMapViewController()
//        destinationVC.photoUrlString = hotelOnMapImageUrl
//        navigationController?.pushViewController(destinationVC, animated: true)
        
//        performSegue(withIdentifier: "showInMapSegue", sender: nil)
    }
    @IBAction func readMoreButtonPressed(_ sender: UIButton) {
    }
    @IBAction func bookNowButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToBookingDetailsStoryboard", sender: nil)
    }
}
