
import UIKit

class ExploreHomeViewController: UIViewController {
    
//    MARK:- Properties
    var currentDate = Date()
    var formatter = DateFormatter()
    var dateComponent = DateComponents()
    var catalog: Catalog = Catalog()
    var location: Location = Location()
    var list: List = List()

    
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
        
    // MARK:- ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       // MARK:- Поисковой запрос. Выдает различные варианты ответов
//        NetworkManagerLocation.fetch(query: "minsk", locale: "ru_RU") { [weak self] (location) in
//            guard let self = self else {return}
//            self.location = location
////            self.collectionView.reloadData()
//        }
        
        // MARK:- Запрос списка отелей в соответствии с выбранным поисковым запросом
        NetworkManagerList.fetch(pageNumber: 1, pageSize: 25, destinationId: "118894", locale: "ru_RU") { [weak self] (list) in
            guard let self = self else { return }
            self.list = list
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
    
    @IBAction func viewAllButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TopHouse", bundle: nil)
//        guard let destinationVC = storyboard.instantiateViewController(identifier: "TopHotelsViewController") as? TopHotelsViewController else { return }
      
        // передача данных сразу на первый экран  tab bar
//        guard let tabBarVC = storyboard.instantiateViewController(identifier: "TabBarController") as? TabBarController else { return }
//        guard let topHotelsVC = tabBarVC.viewControllers?.first as? TopHotelsViewController else { return }
//        topHotelsVC.list = self.list
//        navigationController?.pushViewController(tabBarVC, animated: true)

        // передача данных в tab bar
        guard let destinationVC = storyboard.instantiateViewController(identifier: "TabBarController") as? TabBarController else { return }
        destinationVC.list = self.list
        destinationVC.location = self.locationTextField.text
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension ExploreHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // количество ячеек задаем
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return catalog.hotels.count
        guard let count = self.list.data?.body?.searchResults?.results?.count else { return 0 }
        return count
    }
    
    // внешний вид и содержание задаем
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseCell", for: indexPath) as! HouseCell
//                let hotel = catalog.hotels[indexPath.item]
        guard let hotel = self.list.data?.body?.searchResults?.results?[indexPath.item] else { return cell }
        cell.setupCell(hotel: hotel)
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
        guard let hotel = list.data?.body?.searchResults?.results?[indexPath.row] else { return }
        let storyboard = UIStoryboard(name: "HouseDescription", bundle: nil)
        guard let destinationVC = storyboard.instantiateViewController(identifier: "HouseDescriptionViewController") as? HouseDescriptionViewController else { return }
        destinationVC.hotel = hotel
        navigationController?.pushViewController(destinationVC, animated: true)
//        show(destinationVC, sender: nil)
    }
    
    @objc
    func firstRecognizerClicked(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
}

 
