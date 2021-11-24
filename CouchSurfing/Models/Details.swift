//
//  Details.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 25.10.21.
//

import Foundation

struct Details {
    var data: DataDetails?
}

    struct DataDetails {
        var body: BodyDetails?
    }

        struct BodyDetails {
            var overview: OverviewDetails?
            var propertyDescription: PropertyDescriptionDetails?
        }

            struct OverviewDetails {
                var overviewSections: [OverviewSectionsDetails]?
            }

                struct OverviewSectionsDetails {
                    var title: String?
                    var content: [String]?
                }

            struct PropertyDescriptionDetails {
                var name: String?
                var localisedAddress: LocalisedAddressDetails?
                var featuredPrice: FeaturedPriceDetails?
                var mapWidget: MapWidgetDetails?
            }

                struct LocalisedAddressDetails {
                    var countryName: String?
                    var cityName: String?
                    var provinceName: String?
                    var addressLine1: String?
                }

                struct FeaturedPriceDetails {
                    var currentPrice: CurrentPriceDetails?
                }

                    struct CurrentPriceDetails {
                        var formatted: String?
                    }

                struct MapWidgetDetails {
                    var staticMapUrl: String?
                }




