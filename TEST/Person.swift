//
//  Person.swift
//  TEST
//
//  Created by Elizabeth Serykh on 20.01.2024.
//

import Foundation

struct Person: Decodable {
    let name: String
    let image: String
    let status: String
}

struct PersonData: Decodable {
    let results: [Person]
}
