//
//  Backend.swift
//  Discgolf-app
//
//  Created by Glenn Olsson on 2019-06-19.
//  Copyright © 2019 Glenn Olsson. All rights reserved.
//

import Foundation

let constantPlayers = [
    Player(name: "Glenn"),
    Player(name: "Fredrik"),
    Player(name: "Linus"),
    Player(name: "Oscar")
]

let Glenn = constantPlayers[0]
let Fredrik = constantPlayers[1]
let Linus = constantPlayers[2]
let Oscar = constantPlayers[3]


let constantGames = [
    Game(location: "Kärsön", players: Glenn, Fredrik),
    Game(location: "Tyresö", players: Glenn, Fredrik),
    Game(location: "Kärsön", players: Glenn, Fredrik),
    Game(location: "Kärsön", players: Glenn, Fredrik, Oscar),
]

let constantDepts = [
    Dept(deptor: Fredrik, collector: Glenn, value: 1, currency: "beer"),
    Dept(deptor: Glenn, collector: Linus, value: 3, currency: "appe"),
]

func mimicEvents(){
    constantGames[0].addEvent(player: Glenn, action: 2)
    constantGames[0].addEvent(player: Fredrik, action: 1)
    constantGames[0].addEvent(player: Glenn, action: -1)
    constantGames[0].addEvent(player: Fredrik, action: 3)
    
    constantGames[1].addEvent(player: Glenn, action: 3)
    constantGames[1].addEvent(player: Fredrik, action: 2)
    constantGames[1].addEvent(player: Glenn, action: 1)
    constantGames[1].addEvent(player: Fredrik, action: 1)
    constantGames[1].addEvent(player: Glenn, action: 0)
    constantGames[1].addEvent(player: Fredrik, action: 1)
    constantGames[1].end()
    
    constantGames[2].addEvent(player: Glenn, action: 1)
    constantGames[2].addEvent(player: Fredrik, action: 1)
    constantGames[2].addEvent(player: Glenn, action: 0)
    constantGames[2].addEvent(player: Fredrik, action: 1)
    
    constantGames[3].addEvent(player: Glenn, action: 1)
    constantGames[3].addEvent(player: Fredrik, action: 1)
    constantGames[3].addEvent(player: Oscar, action: 2)
    constantGames[3].addEvent(player: Glenn, action: 1)
    constantGames[3].addEvent(player: Fredrik, action: 1)
    constantGames[3].addEvent(player: Oscar, action: 0)
    constantGames[3].end()
}

func getRounds() -> [Game]{
    mimicEvents()
    return constantGames
}
func getDepts() -> [Dept]{
    return constantDepts.filter({(dept: Dept) -> Bool in return dept.value > 0})
}
