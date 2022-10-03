//
//  Character.swift
//  Breaking Bad
//
//  Created by Mehmet Ali Kısacık on 30.09.2022.
//

import Foundation

struct Character: Codable {
    let name: String?
    let img: String?
}

typealias Characters = [Character]
