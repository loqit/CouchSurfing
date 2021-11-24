//
//  DateViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 10.11.21.
//

import UIKit
import FSCalendar

// передача данных назад через notification
//let checkInCalendarViewControllerNotification = NSNotification.Name(rawValue: "checkInCalendarViewControllerNotification")
//let checkOutCalendarViewControllerNotification = NSNotification.Name(rawValue: "checkOutCalendarViewControllerNotification")


class CalendarViewController: UIViewController {
    
    //   MARK:- Properties
    var formatter = DateFormatter()
    var checkInDate: Date?
    var checkInDateClosure: ((Date) -> ())?
    var checkOutDate: Date?
    var checkOutDateClosure: ((Date) -> ())?
    var sourceTextField: String?
    
    //   MARK:- IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    //   MARK:- LifeCycleController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        
        formatter.dateFormat = "dd MMM, yyy"
        
        //        calendarView.appearance.caseOptions
    }
    
    //   MARK:- IBActions
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        guard let sourceTextField = sourceTextField else { return }
        
        switch sourceTextField {
        case "checkIn":
            guard let checkInDate = checkInDate else { return }
            checkInDateClosure?(checkInDate)
            // передача данных назад через notification
//            NotificationCenter.default.post(name: checkInCalendarViewControllerNotification, object: checkInDate)
        case "checkOut":
            guard let checkOutDate = checkOutDate else { return }
            checkOutDateClosure?(checkOutDate)
            // передача данных назад через notification
//            NotificationCenter.default.post(name: checkOutCalendarViewControllerNotification, object: checkOutDate)
        default:
            return
        }

        dismiss(animated: true, completion: nil)
    }
}

//   MARK:- Extensions
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    //    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
    //        return "May 2020"
    //    }
    //
    //    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
    //        return "May 27 - May 31"
    //    }
    
    
    //   MARK:- Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Выбрана дата \(formatter.string(from: date))")
        
        guard let sourceTextField = sourceTextField else { return }
        switch sourceTextField {
        case "checkIn":
            checkInDate = date
        case "checkOut":
            checkOutDate = date
        default:
            return
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Удалена дата \(formatter.string(from: date))")
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        formatter.dateFormat = "dd MMM, yyy"
        guard let excludedDate = formatter.date(from: "25 Jun, 2020") else { return true }
        if date.compare(excludedDate) == .orderedSame {
            return false
            
        }
        return true
    }
}
