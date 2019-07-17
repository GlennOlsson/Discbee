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
    Player(name: "Oscar"),
    Player(name: "1"),
    Player(name: "2"),
    Player(name: "3"),
    Player(name: "4")
]

let Glenn = constantPlayers[0]
let Fredrik = constantPlayers[1]
let Linus = constantPlayers[2]
let Oscar = constantPlayers[3]
let p1 = constantPlayers[4]
let p2 = constantPlayers[5]
let p3 = constantPlayers[6]
let p4 = constantPlayers[7]


let constantGames = [
    Game(location: "Kärsön", players: Glenn, Fredrik),
    Game(location: "Tyresö", players: Glenn, Fredrik),
    Game(location: "Kärsön", players: Glenn, Fredrik),
    Game(location: "Kärsön", players: Glenn, Fredrik, Oscar, Linus, p1, p2, p3, p4),
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

func `init`(){
	mimicEvents()
}

func getRounds() -> [Game]{
	return constantGames
}
func getDepts() -> [Dept]{
    return constantDepts.filter({(dept: Dept) -> Bool in return dept.value > 0})
}
