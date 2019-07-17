//
//  Models.swift
//  Discgolf-app
//
//  Created by Glenn Olsson on 2019-06-19.
//  Copyright © 2019 Glenn Olsson. All rights reserved.
//

import Foundation

/**
    Describes an event, for instance when a user adds 2 to their points
*/
class Event {
    let time: Date
    let player: Player
    let action: Int
    
    init(time: Date, player: Player, action: Int) {
        self.time = time
        self.player = player
        self.action = action
    }
    
    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: time)
    }
}

class Game {
    var score: [Player: Int]
    let time: Date
    let location: String
    var events: [Event]
    var isLive: Bool
    
    init(location: String, players: Player...){
        score = [:]
        for player in players {
            score[player] = 0
        }
        time = Date()
        self.location = location
        self.events = []
        isLive = true
    }
    
    func getTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM-YY"
        return dateFormatter.string(from: time)
    }
    
    func addEvent(player: Player, action: Int){
        guard let currentScore = score[player] else {
            print("NOT A PLAYER")
            return
        }
        events.append(Event(time: Date(), player: player, action: action))
        score[player] = currentScore + action
    }
    
    func end(){
        isLive = false
    }
    
    func resume(){
        isLive = true
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

class Dept {
    
    let deptor: Player
    let collector: Player
    var value: Int
    let currency: String
    
    init(deptor: Player, collector: Player, value: Int, currency: String){
        self.deptor = deptor
        self.collector = collector
        self.value = value
        self.currency = currency
    }
    
    func decrease(){
        value -= 1
    }
    
    func getText() -> String {
        return "\(deptor.getName()) ows \(collector.getName()) \(value) \(currency.lowercased())"
    }
}
