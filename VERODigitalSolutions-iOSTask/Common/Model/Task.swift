//
//  Task.swift
//  VERODigitalSolutions-iOSTask
//
//  Created by Mehmet Ali Demir on 2.03.2023.
//

import Foundation

struct Task: Codable {
    let title: String
    let description: String
    let task: String
    let colorCode: String
}

class TokenModelResponse: Codable {
    let oauth: TokenModel
}

class TokenModel: Codable {
    let access_token: String
}

