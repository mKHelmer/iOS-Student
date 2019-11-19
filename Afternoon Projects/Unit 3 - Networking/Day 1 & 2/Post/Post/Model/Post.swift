//
//  Post.swift
//  Post
//
//  Created by Soul Master on 11/18/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation
//top level or outermost object in the JSON file
struct TopLevelObject: Codable {

    let post : [Post]
    
}
// our model, decodable so we can pull it from JSON
struct Post: Codable {
    let username: String
    let text: String
    let timestamp: TimeInterval = Date().timeIntervalSince1970
}
