//
//  Wine.swift
//  AstraWine
//
//  Created by Михаил Иванов on 29.09.2021.
//

import Foundation

struct Shelf {
    var name: String
    var bottle: [Bottle] = []
    
    init(name: String, bottle: [Bottle]) {
        self.name = name
        self.bottle = bottle
    }
    
    init(name: String) {
        self.name = name
    }

    static func getShelfs() -> [Shelf] {
        [Shelf(name: "Зима 2010", bottle: [
            Bottle(name: "Test", dateTasting: "Test", comment: "Test", rating: 2),
            Bottle(name: "Test2", dateTasting: "Test", comment: "Test", rating: 2),
            Bottle(name: "Test3", dateTasting: "Test", comment: "Test", rating: 2),
            Bottle(name: "Test4", dateTasting: "Test", comment: "Test", rating: 2)
        ]),
        Shelf(name: "Лето 2014", bottle: [
            Bottle(name: "Test1", dateTasting: "Test", comment: "Test", rating: 2),
            Bottle(name: "Test6", dateTasting: "Test", comment: "Test", rating: 4)
        ]),
        Shelf(name: "Лето 2019", bottle: [
            Bottle(name: "Test1", dateTasting: "Test", comment: "Test", rating: 2),
            Bottle(name: "Test6", dateTasting: "Test", comment: "Test", rating: 4)
        ])]
    }
}

struct Bottle {
    var name: String
    var dateTasting: String = ""
    var placeTasting: String = ""
    var country: String = ""
    var region: String = ""
    var colorWine: Color = .red
    var dateHarvest: String = ""
    var grapeSort: String = ""
    var fortressWine: Double = 0.0
    var price: Int = 0
    var manufacturer: String = ""
    var distributor: String = ""
    
    var appearance: String = ""
    var scent: String = ""
    var teste: String = ""
    var storagePotential: String = ""
    var flowTemp: Double = 0.0
    var gastronomicCompanions: String = ""
    var placeOfPurchase: String = ""
    var comment: String = ""
    var rating: Int = 0
    
    init(name: String, dateTasting: String, comment: String, rating: Int) {
        self.name = name
        self.dateTasting = dateTasting
        self.comment = comment
        self.rating = rating
    }
    
    init(name: String) {
        self.name = name
    }
}

enum Color: String {
    case red = "Красное"
    case ping = "Розовое"
}
