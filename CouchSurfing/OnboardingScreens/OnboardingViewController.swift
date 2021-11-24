//
//  OnboardingViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 05.11.21.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    //    MARK:- IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var onboarding: Onboarding = Onboarding()
    var onboardingPage: Int = 1
    
    //    MARK:- Life cycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 5
        self.collectionView.register(UINib(nibName: "OnboardingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    //    MARK:- IBActions
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        //        let destinationViewController = UIStoryboard(name: "RegisterLogin", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController")
        //        destinationViewController.modalPresentationStyle = .fullScreen
        //        navigationController?.pushViewController(destinationViewController, animated: true)
        
        //        let onboardingStoryboard = UIStoryboard(name: "RegisterLogin", bundle: Bundle.main)
        //        guard let destinationViewController = onboardingStoryboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else { return }
        //        navigationController?.pushViewController(destinationViewController, animated: true)
        
        performSegue(withIdentifier: "goToRegisterLoginStoryboard", sender: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if onboardingPage != onboarding.pages.count {
            let indexPath = IndexPath(row: onboardingPage, section: 0)
            pageControl.currentPage = onboardingPage
            // без нижней и через одну строку код не работает. Баг в XCode который давно не правят
            self.collectionView.isPagingEnabled = false
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            self.collectionView.isPagingEnabled = true
            onboardingPage += 1
            
            if onboardingPage == 3 {
                skipButton.setTitle("Done", for: .normal)
                nextButton.setTitle("Get Started", for: .normal)
            }
        } else {
            // конец экранов Onboarding. Переход на экран Register
            performSegue(withIdentifier: "goToRegisterLoginStoryboard", sender: nil)
        }
    }
}


// MARK:- Extension
extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboarding.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        let page = onboarding.pages[indexPath.item]
        cell.setupCell(page: page)
        return cell
    }
    
    // задаем размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 375 * 372)
    }
    
    // убираем отступ между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
