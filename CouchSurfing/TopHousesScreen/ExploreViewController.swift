//
//  ExploreViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 7.12.21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ExploreViewController: UIViewController {
    
//    MARK:- Properties
    var currentDate = Date()
    var formatter = DateFormatter()
    var dateComponent = DateComponents()
    
    var allHousesCatalog: [House] = []
    
    // MARK:- IBOutlets
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var checkInView: UIView!
    @IBOutlet weak var checkInTextField: UITextField!
    
    @IBOutlet weak var checkOutView: UIView!
    @IBOutlet weak var checkOutTextField: UITextField!
    
    @IBOutlet weak var peopleView: UIView!
    @IBOutlet weak var peopleTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var params: [String: Any] = [:]
        
    // MARK:- ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        let city = locationTextField.text ?? "Minsk"
        let capacity = peopleTextField.text ?? "1"
        params = ["City": city, "Capacity": capacity]
        fetchHouses(with: params)
    }
    
    private func fetchHouses(with params: [String: Any]) {
        let db = Firestore.firestore()
        let city = params["City"] as? String ?? ""
        let tmp = params["Capacity"] as? String ?? "1"
        let capacity = Int(tmp) ?? 0
        var dict: [[String: Any]] = []
        DispatchQueue.global().async {
            db.collection("houses")
                .whereField("City", isEqualTo: city)
                .whereField("Capacity", isGreaterThanOrEqualTo: capacity)
                .getDocuments()
                { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        dict.append(document.data())
                        print(dict)
                        self.updateCollectionView(with: dict)
                    }
                }
            }
        }
    }
    
    private func updateCollectionView(with data: [[String: Any]]) {
        allHousesCatalog = []
        for item in data {
            let newHouse = CSConstans.setHouse(with: item)
            self.allHousesCatalog.append(newHouse)
            self.collectionView.reloadData()
        }
    }
    
    private func configureUI() {
        configureDates()
        configureTextFields()
        configureCollectionView()
        configureTapRecognizer()
    }

    private func configureTextFields() {
        locationView.setupShadowAndRadius()
        checkInView.setupShadowAndRadius()
        checkOutView.setupShadowAndRadius()
        peopleView.setupShadowAndRadius()
        
        locationTextField.setupLeftImage(imageName: "location Icon")
        checkInTextField.setupLeftImage(imageName: "data Icon")
        checkOutTextField.setupLeftImage(imageName: "data Icon")
        peopleTextField.setupLeftImage(imageName: "people Icon")
        searchButton.layer.cornerRadius = 5
    }

    private func configureDates() {
        formatter.dateFormat = "dd MMM, yyy"
        dateComponent.day = 1
        guard let checkOutDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) else { return }
        
        let checkInDateString: String? = formatter.string(from: currentDate)
        if let date = checkInDateString {
            checkInTextField.text = date
        }
        
        
        let checkOutDateString: String = formatter.string(from: checkOutDate)
        checkOutTextField.text = checkOutDateString
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "HouseCell", bundle: nil), forCellWithReuseIdentifier: "HouseCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(firstRecognizerClicked(_:)))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    // MARK:- IBActions
    @IBAction func calendarButtonPressed(_ sender: UIButton) {
        let sourceTextField = sender.tag
        let storyboard = UIStoryboard(name: "BookingDetails", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "CalendarViewController") as! CalendarViewController
        
        switch sourceTextField {
        case 1:
            destinationVC.sourceTextField = "checkIn"
            destinationVC.checkInDateClosure = { [weak self] in
                guard let self = self else { return }
                self.checkInTextField.text = "\(self.formatter.string(from: $0))"}
        case 2:
            destinationVC.sourceTextField = "checkOut"
            destinationVC.checkOutDateClosure = { [weak self] in
                guard let self = self else { return }
                self.checkOutTextField.text = "\(self.formatter.string(from: $0))"}
        default:
            return
        }
        
        destinationVC.modalPresentationStyle = .overCurrentContext
        present(destinationVC, animated: true, completion: nil)
    }
        
    @IBAction func peopleButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "BookingDetails", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "PeopleViewController") as! PeopleViewController
        destinationVC.modalPresentationStyle = .overCurrentContext
        destinationVC.roomRenterStringClosure = { [weak self] in
            guard let self = self else { return }
            self.peopleTextField.text = $0
        }

        present(destinationVC, animated: true, completion: nil)
    }
    
    @IBAction func unwingToExploreHomeScreen(_ sender: UIStoryboardSegue) {
    }
    
    @IBAction func viewAllPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TopHouse", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "TopHouseViewController") as! TopHouseViewController
        destinationVC.params = params
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let city = locationTextField.text ?? "Minsk"
        let tmp = peopleTextField.text ?? "1"
        var capacity = tmp.first ?? "1"
        let params = ["City": city, "Capacity": capacity] as [String : Any]
        fetchHouses(with: params)
    }
    
}

extension ExploreViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // количество ячеек задаем
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = allHousesCatalog.count
        return count
    }
    
    // внешний вид и содержание задаем
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseCell", for: indexPath) as! HouseCell
//                let hotel = catalog.hotels[indexPath.item]
        let house = allHousesCatalog[indexPath.item]
        cell.setupCell(house: house)
        return cell
    }
    
    //  размер ячейки задаем
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        return CGSize(width: 160, height: 168)
        return CGSize(width: 160, height: 200)
    }
    
    // отспут между ячейками задаем
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    // отрабатываем нажатие на ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let house = allHousesCatalog[indexPath.row]
        let storyboard = UIStoryboard(name: "HouseDescription", bundle: nil)
        guard let destinationVC = storyboard.instantiateViewController(identifier: "HouseDescriptionViewController") as? HouseDescriptionViewController else { return }
        destinationVC.house = house
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc
    func firstRecognizerClicked(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

 
