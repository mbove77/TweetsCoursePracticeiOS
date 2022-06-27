//
//  RegisterRequest.swift
//  PlatziTweets
//
//  Created by Resonant Sports on 12/02/2021.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let names: String
}
