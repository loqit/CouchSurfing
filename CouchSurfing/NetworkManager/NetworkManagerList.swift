//
//  NetworkManagerList.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 25.10.21.
//

import Foundation
import Alamofire

class NetworkManagerList {

    static func fetch(pageNumber: Int, pageSize: Int, destinationId: String, locale: String, completion: ((List) -> Void)?) {
        
// MARK:- HeaderParameters
        let apiKey = "cccde74e5fmshf0d5cc70da821d5p17e4c8jsnf742d7399cc7"
        let apiHost = "hotels4.p.rapidapi.com"
       
//        // MARK:- RequiredParameters
//        let adults: Int
//        let pageNumber: Int = 1
//        let desId: String
//        let pageSize: Int = 25
//        let checkOut: String
//        let checkIn: String
//
//        // MARK:- OptionalParameters
//        let children6: Int
//        let amenitylds: String
//        let aduults7: Int
//        let starRatings: Int
//        let priceMax: Int
//        let sortOrder: String
//        //...


        
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key" : apiKey,
            "x-rapidapi-host" : apiHost
        ]
                
        let url = "https://\(apiHost)/properties/list?adults1=1&pageNumber=\(pageNumber)&destinationId=\(destinationId)&pageSize=\(pageSize)&checkOut=2020-01-15&checkIn=2020-01-08&sortOrder=PRICE&locale=\(locale)&currency=USD"
        
        
        AF.request(url, method: .get, headers: headers).responseJSON { (response) in
            //            print(response.value)
            if let dictionary = response.value as? [String: Any] {
                var list: List = List()
                list.result = dictionary["result"] as? String
                
                if let dataDictionary = dictionary["data"] as? [String: Any] {
                    var data: Data = Data()
           
                    if let bodyDictionary = dataDictionary["body"] as? [String: Any] {
                        var body: Body = Body()
                        
                        if let searchResultsDictoinary = bodyDictionary["searchResults"] as? [String: Any] {
                            var searchResults: SearchResults = SearchResults()
                            searchResults.totalCount = searchResultsDictoinary["totalCount"] as? Int
                            
                            if let resultsArray = searchResultsDictoinary["results"] as? [[String: Any]] {
                                var results: [Result] = []
                                
                                for resultDictionary in resultsArray {
                                    if let id = resultDictionary["id"] as? Int {
                                        var result: Result = Result(id: id)
                                        
                                        result.name = resultDictionary["name"] as? String
                                        result.starRating = resultDictionary["starRating"] as? Double
                                        
                                        if let ratePlanDictionary = resultDictionary["ratePlan"] as? [String: Any] {
                                            var ratePlan: RatePlan = RatePlan()
                                            
                                            if let priсeDictionary = ratePlanDictionary["price"] as? [String: Any] {
                                                var price: Price = Price()
                                                price.current = priсeDictionary["current"] as? String
                                                ratePlan.price = price
                                            }
                                            
                                            result.ratePlan = ratePlan
                                        }
                                        
                                        if let optimizedThumbUrlsDictionary = resultDictionary["optimizedThumbUrls"] as? [String: Any] {
                                            var  optimizedThumbUrls: OptimizedThumbUrls =  OptimizedThumbUrls()
                                            optimizedThumbUrls.srpDesktop = optimizedThumbUrlsDictionary["srpDesktop"] as? String
                                            result.optimizedThumbUrls = optimizedThumbUrls
                                        }
                                        
                                        results.append(result)
                                    }
                                    
                                }
                                
                                searchResults.results = results
                            }
                            
                            body.searchResults = searchResults
                        }
                        
                        data.body = body
                    }
                    
                    list.data = data
                }
                
                completion?(list)
            }
        }
    }
}

