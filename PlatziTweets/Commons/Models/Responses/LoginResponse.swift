//
//  LoginResponse.swift
//  PlatziTweets
//
//  Created by Resonant Sports on 12/02/2021.
//

import Foundation

struct LoginResponse: Codable {
    let user: User
    let token: String
}
