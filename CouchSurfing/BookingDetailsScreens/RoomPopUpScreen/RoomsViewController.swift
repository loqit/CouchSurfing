//
//  RoomsViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 10.11.21.
//

import UIKit

// передача данных назад через notification
//let roomViewControllerNotification = NSNotification.Name(rawValue: "roomleViewControllerNotification")

class RoomsViewController: UIViewController {
    var bookingRoom: BookingRoom = BookingRoom()
    var bookingRoomStringClosure: ((String) -> ())?
    var bookingRoomClosure: ((BookingRoom) -> ())?
    
    @IBOutlet weak var roomsTableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationItem.title = ""
        
        self.roomsTableView.register(UINib(nibName: "BookingDetailsCell", bundle: nil), forCellReuseIdentifier: "BookingDetailsCell")
        self.roomsTableView.dataSource = self
        self.roomsTableView.delegate = self
        
        self.contentView.setupShadowAndRadius()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        let bookingRoomString = createBookingRoomString(bookingRoom: self.bookingRoom)
        
        // если пользователь не заполнил поля то кнопка не будет работать
        if bookingRoomString == "" {
            return
        } else {
            bookingRoomStringClosure?(bookingRoomString)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func createBookingRoomString(bookingRoom: BookingRoom) -> String {
        var roomText: String = ""
        for room in bookingRoom.bookingRooms {
            if room.quantity != 0 {
                if roomText == "" {
                    roomText += "\(room.quantity) \(room.name)"
                } else {
                    roomText += ", \(room.quantity) \(room.name)"
                }
            }
        }
        
        return roomText
    }
}

extension RoomsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingRoom.bookingRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingDetailsCell", for: indexPath) as! BookingDetailsCell
        cell.setupCell(item: bookingRoom.bookingRooms[indexPath.item])
        
        
        cell.cellMinusPressed = {
            guard self.bookingRoom.bookingRooms[indexPath.item].quantity > 0 else { return }
            self.bookingRoom.bookingRooms[indexPath.item].quantity -= 1
            tableView.reloadData()
        }
        cell.cellPlusPressed = {
            self.bookingRoom.bookingRooms[indexPath.item].quantity += 1
            tableView.reloadData()
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

