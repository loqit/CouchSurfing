//
//  NetworkManagerDetails.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 25.10.21.
//

import Foundation
import Alamofire

class NetworkManagerDetails {
    static func fetch(hotelId: String, locale: String, completion: ((Details) -> Void)?) {
        
        //        let hotelId = "1214051616"
        //        let locale = "ru_RU"
        
        // MARK:- HeaderParameters
        let apiKey = "cccde74e5fmshf0d5cc70da821d5p17e4c8jsnf742d7399cc7"
        let apiHost = "hotels4.p.rapidapi.com"
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key" : apiKey,
            "x-rapidapi-host" : apiHost
        ]
        
        let url = "https://\(apiHost)/properties/get-details?id=\(hotelId)&checkIn=2020-01-08&checkOut=2020-01-15&currency=USD&locale=\(locale)&adults1=1"
        
        AF.request(url, method: .get, headers: headers).responseJSON { (response) in
            if let dictionary = response.value as? [String: Any] {
                var details: Details = Details()
                
                if let dataDictionary = dictionary["data"] as? [String: Any] {
                    var data: DataDetails = DataDetails()
                    
                    if  let bodyDictionary = dataDictionary["body"] as? [String: Any] {
                        var body: BodyDetails = BodyDetails()
                        
                        if let overviewDictionary = bodyDictionary["overview"] as? [String: Any] {
                            var overview: OverviewDetails = OverviewDetails()
                            
                            if let overviewDetailsArray = overviewDictionary["overviewSections"] as? [[String: Any]] {
                                var overviewSections: [OverviewSectionsDetails] = []
                                
                                for overviewSectionsDictionary in overviewDetailsArray {
                                    var  overviewSection: OverviewSectionsDetails = OverviewSectionsDetails()
                                    overviewSection.title = overviewSectionsDictionary["title"] as? String
                                    overviewSection.content = overviewSectionsDictionary["content"] as? [String]
                                    overviewSections.append(overviewSection)
                                }
                                
                                overview.overviewSections = overviewSections
                            }
                            
                            body.overview = overview
                        }
                        
                        if let overviewDictionary = bodyDictionary["propertyDescription"] as? [String: Any] {
                            var propertyDescription: PropertyDescriptionDetails = PropertyDescriptionDetails()
                            propertyDescription.name = overviewDictionary["name"] as? String
                            
                            if let localisedAddressDictionary = overviewDictionary["localisedAddress"] as? [String: Any] {
                                var localisedAddress: LocalisedAddressDetails = LocalisedAddressDetails()
                                localisedAddress.countryName = localisedAddressDictionary["countryName"] as? String
                                localisedAddress.cityName = localisedAddressDictionary["cityName"] as? String
                                localisedAddress.provinceName = localisedAddressDictionary["provinceName"] as? String
                                localisedAddress.addressLine1 = localisedAddressDictionary["addressLine1"] as? String
                                propertyDescription.localisedAddress = localisedAddress
                            }
                            
                            if let featuredPriceDictionary = overviewDictionary["featuredPrice"] as? [String: Any] {
                                var featuredPrice: FeaturedPriceDetails = FeaturedPriceDetails()
                                
                                if let currentPriceDictionary = featuredPriceDictionary["currentPrice"]  as? [String: Any] {
                                    var currentPrice: CurrentPriceDetails = CurrentPriceDetails()
                                    currentPrice.formatted = currentPriceDictionary["formatted"] as? String
                                    featuredPrice.currentPrice = currentPrice
                                }
                                
                                propertyDescription.featuredPrice = featuredPrice
                            }
                            
                            if let mapWidgetDictionary = overviewDictionary["mapWidget"] as? [String: Any] {
                                var mapWidget: MapWidgetDetails = MapWidgetDetails()
                                mapWidget.staticMapUrl = mapWidgetDictionary["staticMapUrl"] as? String
                                propertyDescription.mapWidget = mapWidget
                            }
                            
                            body.propertyDescription = propertyDescription
                        }
                        
                        data.body = body
                    }
                    
                    details.data = data
                }
                
                completion?(details)
            }
        }
    }
}
