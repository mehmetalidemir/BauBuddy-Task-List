//
//  Task.swift
//  VERODigitalSolutions-iOSTask
//
//  Created by Mehmet Ali Demir on 2.03.2023.
//

import Foundation

class Task : Codable {
    var task: String
    var title: String
    var description: String
    var colorCode: String

    init(task: String, title: String, description: String, colorCode: String) {
        self.task = task
        self.title = title
        self.description = description
        self.colorCode = colorCode
    }
}

class TokenModelResponse: Codable {
    let oauth: TokenModel
}

class TokenModel: Codable {
    let access_token: String
}

