

import UIKit
import Kingfisher
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class HouseDescriptionViewController: UIViewController {
    
    var hotelOnMapImageUrl: String = ""
    var house: House?
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var bookNowButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setHouseData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setHouseData()
    }
    
    private func setHouseData() {
        DispatchQueue.global().async {
            self.setImageView()
        }
        nameLabel.text = house?.title
        textView.text = house?.description
        locationLabel.text = house?.city
        getRating()
        getOwner()
        
    }
    
    private func getOwner() {
        let db = Firestore.firestore()
        
        guard let userID = house?.userOwnerID else { return }
        db.collection("users").document(userID).getDocument { document, error in
            
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["Name"] as? String ?? ""
                self.ownerLabel.text = name
            } else {
                print("Document does not exist")
            }

        }
    }
    
    private func getRating() {
       
        let db = Firestore.firestore()
        
        guard let houseID = house?.houseID.uuidString else { return }
        print(houseID)
        db.collection("ratings").document(houseID).getDocument { document, error in
            
            if let document = document, document.exists {
                let data = document.data()
                let rating = data?["Value"] as? Int
                var rate = String(rating ?? 0) ?? ""
                if rate == "0" {rate = "_"}
                self.ratingLabel.text = "\(rate)/5"
            } else {
                print("Document does not exist")
            }

        }
    }
    
    private func setImageView() {
        if let url = URL(string: house?.imageURL ?? "") {
            imageView.kf.setImage(with: url)
        }
    }
    
    @IBAction func openReviews(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ReviewListViewController") as? ReviewListViewController else { return }
        vc.thisHouseID = house?.houseID.uuidString
        vc.ownerID = house?.userOwnerID
        navigationController?.pushViewController(vc, animated: true)
       // navigationController?.present(vc, animated: true)
    }
    private func configureUI() {
        galleryButton.layer.cornerRadius = 5
        bookNowButton.layer.cornerRadius = 5
        imageView.layer.cornerRadius = 5
        
        if currentUserIsOwner() {
            bookNowButton.setTitle("Delete", for: .normal)
        }
    }
    
    @IBAction func galleryButtonPressed(_ sender: UIButton) {
        let vc = ReviewListViewController()
        vc.thisHouseID = house?.houseID.uuidString
        navigationController?.pushViewController(vc, animated: true)
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
    
    private func currentUserIsOwner() -> Bool {
        let currentUserID = Auth.auth().currentUser!.uid
        let ownerHouseID = house?.userOwnerID
        return ownerHouseID == currentUserID
    }
    
    private func deleteHouse() {
        let db = Firestore.firestore()
        guard let houseID = house?.houseID.uuidString else { return }
        db.collection("houses").document(houseID).delete()
        db.collection("ratings").document(houseID).delete()
        deleteReviews(by: houseID)
        
    }
    
    private func deleteReviews(by houseID: String) {
        let db = Firestore.firestore()
        db.collection("reviews").whereField("HouseID", isEqualTo: houseID).getDocuments { documents, error in
            guard let documents = documents, error == nil else { return }
            for document in documents.documents {
                let reviewID = document.data()["ReviewID"] as? String ?? ""
                db.collection("reviews").document(reviewID).delete()
            }
        }
    }
    
    @IBAction func bookNowButtonPressed(_ sender: UIButton) {
        print("Book Now Button Pressed")
        if currentUserIsOwner() {
            let alert = UIAlertController(title: "Are you shure", message: "Do you want to delete the post?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { action in
                self.deleteHouse()
                self.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            self.present(alert, animated: true)
        } else {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "BookingDetailsViewController") as? BookingDetailsViewController else { return }
            vc.houseID = house?.houseID.uuidString
            navigationController?.pushViewController(vc, animated: true)
        }
      //  performSegue(withIdentifier: "goToBookingDetailsStoryboard", sender: nil)
    }
}
