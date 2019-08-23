//
//  ModelData.swift
//  KKKokoro
//
//  Created by Sylvia Jia Fen  on 2019/8/23.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation

struct HitList: Codable {
    
    let data: [Data]
    
    let paging: Paging
    
    let summary: Summary
}

struct Data: Codable {
    
    let id: String
    
    let name: String
    
    let duration: Int
    
    let url: String
    
    let trackNumber: Int
    
    let explicitness: Bool
    
    let availableTerritories: [String]
    
    let album: Album
    
    enum CodingKeys: String, CodingKey {
        
        case id
        
        case name
        
        case duration
        
        case url
        
        case trackNumber = "track_number"
        
        case explicitness
        
        case availableTerritories = "available_territories"
        
        case album
    }
    
}

struct Album: Codable {
    
    let id: String
    
    let name: String
    
    let url: String
    
    let explicitness: Bool
    
    let availableTerritories: [String]
    
    let releaseDate: String
    
    let images: [Image]
    
    let artist: Artist
    
    enum CodingKeys: String, CodingKey {
        
        case id
        
        case name
        
        case url
        
        case explicitness
        
        case availableTerritories = "available_territories"
        
        case releaseDate = "release_date"
        
        case images
        
        case artist
        
    }
    
}

struct Image: Codable {
    
    let height: Int
    
    let width: Int
    
    let url: String
}

struct Artist: Codable {
    
    let id: String
    
    let name: String
    
    let url: String
    
    let images: [Image]
}

struct Paging: Codable {
    
    let offset: Int
    
    let limit: Int
    
//    let previous:
    
    let next: String
    
}

struct Summary: Codable {
    
    let total: Int
}
