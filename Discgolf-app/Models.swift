//
//  Models.swift
//  Discgolf-app
//
//  Created by Glenn Olsson on 2019-06-19.
//  Copyright © 2019 Glenn Olsson. All rights reserved.
//

import Foundation

class Game {
    var score: [Player: Int]
    
    init(location: String, players: Player...){
        score = [:]
        for player in players {
            score[player] = 0
        }
    }
}

class Player: Hashable {
    private var name: String
    private var id: Int
    
    init(name: String){
        self.name = name
        self.id = Int.random(in: 0...100_000_000)
    }
    
    func getName() -> String {
        return name
    }
    
    func getID() -> Int {
        return id
    }
    
    static func ==(lhs: Player, rhs: Player) -> Bool{
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(id)
    }
}
