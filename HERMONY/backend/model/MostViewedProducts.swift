//
//  MostViewedProducts.swift
//  HERMONY
//
//  Created by Mohamed Ahmed Sadek on 4/29/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import Foundation
struct MostViewedProducts : Codable {
    let Status : String
    let code : Int
    let message : String
    let Products : Products
}

struct Products : Codable{
    let id : Int
    let img : String
    let ProductId : String
}

enum codingKeys : String , CodingKey {
    case id = "id"
    case img = "img"
    case ProductId = "Product_id"
}

