//
//  NetworkManagerAlamofire.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 25.10.21.
//

import Foundation
import Alamofire

class NetworkManagerLocation {

//    static func fetch(query: String, locale: String, completion: @escaping (String?) -> ()) {
    static func fetch(query: String, locale: String, completion: ((Location) -> Void)?) {

        let apiKey = "cccde74e5fmshf0d5cc70da821d5p17e4c8jsnf742d7399cc7"
        let apiHost = "hotels4.p.rapidapi.com"
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key" : apiKey,
            "x-rapidapi-host" : apiHost
        ]
                
        let url = "https://\(apiHost)/locations/search?query=\(query)&locale=\(locale)"

        AF.request(url, method: .get, headers: headers).responseJSON { (response) in
//            print(response.value)
            if let dictionary = response.value as? [String: Any] {
                var location: Location = Location()
                location.term = dictionary["term"] as? String
                location.moresuggestions = dictionary["moresuggestions"] as? Int
                location.autoSuggestInstance = dictionary["autoSuggestInstance"] as? String
                location.trackingID = dictionary["trackingID"] as? String
                location.misspellingfallback = dictionary["tmisspellingfallbackerm"] as? Bool
                location.geocodeFallback = dictionary["geocodeFallback"] as? Bool
                
                if let arrayOfSuggestions = dictionary["suggestions"] as? [[String: Any]] {
                    var suggestionsArray: [Suggestion] = []
                    
                    for item in arrayOfSuggestions {
                        var suggestion: Suggestion = Suggestion()
                        suggestion.group = item["group"] as? String
                        
                        if let arrayOfEntities = item["entities"] as? [[String: Any]] {
                            var entitiesArray: [Entity] = []
                            
                            for item in arrayOfEntities {
                                var entity: Entity = Entity()
                                entity.geoId = item["geoId"] as? String
                                entity.destinationId = item["destinationId"] as? String
                                entity.landmarkCityDestinationId = item["landmarkCityDestinationId"] as? String
                                entity.type = item["type"] as? String
                                entity.redirectPage = item["redirectPage"] as? String
                                entity.latitude = item["latitude"] as? Double
                                entity.longitude = item["longitude"] as? Double
                                entity.searchDetail = item["searchDetail"] as? String
                                entity.caption = item["caption"] as? String
                                entity.name = item["name"] as? String
                                entitiesArray.append(entity)
                            }
                            
                            suggestion.entities = entitiesArray
                        }
                        
                        suggestionsArray.append(suggestion)
                    }
                    
                    location.suggestions = suggestionsArray
                }
                
                guard let destinationId = location.suggestions?[0].entities?[0].destinationId else { return }
//                3
//                guard let suggestions = location.suggestions else { return }
//                guard let entities = suggestions[0].entities else { return }
//                guard let destinationId = entities[0].destinationId else { return }
                print(destinationId)
                completion?(location) //вызываю completion чтобы передать наружу данные
            }
            
        }
    }
}




