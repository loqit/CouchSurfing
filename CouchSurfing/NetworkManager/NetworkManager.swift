//
//  NetworkManager.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 25.10.21.
//

import Foundation

//class NetworkManager {
//
//    // *@escaping оператор нужен для того чтобы когда ф-ия fetch закончится блок (String?) -> () задержался в памяти до момента пока не придет ответ от сервера
//    static func fetch(completion: @escaping (String?) -> ()) {
//        let urlString = "https://..."
//        guard let url = URL(string: urlString) else { return }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//
//            guard let data = data else { return }
//            let jsonString = String(data: data, encoding: .utf8)
//            completion(jsonString)
////            print(jsonString as Any)
//
//            //...
//        }
//
//        task.resume()
//    }
//}

import Foundation

class NetworkManager {
    static func fetch(completion: @escaping (String?) -> ()) {
        
        let headers = [
            "x-rapidapi-key": "cccde74e5fmshf0d5cc70da821d5p17e4c8jsnf742d7399cc7",
            "x-rapidapi-host": "hotels4.p.rapidapi.com"
        ]
        
        let baseUrl: String = "https://hotels4.p.rapidapi.com"
        let query: String = "minsk"
        let locale: String = "ru_RU"

        let request = NSMutableURLRequest(url: NSURL(string: "\(baseUrl)/locations/search?query=\(query)&locale=\(locale)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data else { return }
            print("_____data: \(data)")
            
//            guard let response = response else { return }
//            print("_____response: \(response)")
            
            // виталик так предлагает писать
            //    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            //        print("_____json: \(json)")
            //    }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("_____json: \(json)")
                if let json = json as? [String: Any] {
                    print(json)
                }

            } catch {
                print("_____error: \(error)")
            }
            

            
            
        })
        
        dataTask.resume()
    }
}
