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

let constantGames = [
    Game(location: "Kärsön", players: constantPlayers[0], constantPlayers[1]),
    Game(location: "Tyresö", players: constantPlayers[0], constantPlayers[1]),
]

func mimicEvents(){
    constantGames[0].addEvent(player: constantPlayers[0], action: 2)
    constantGames[0].addEvent(player: constantPlayers[1], action: 1)
    constantGames[0].addEvent(player: constantPlayers[0], action: -1)
    constantGames[0].addEvent(player: constantPlayers[1], action: 3)
    
    constantGames[1].addEvent(player: constantPlayers[0], action: 3)
    constantGames[1].addEvent(player: constantPlayers[1], action: 2)
    constantGames[1].addEvent(player: constantPlayers[0], action: 1)
    constantGames[1].addEvent(player: constantPlayers[1], action: 1)
}

func getRounds() -> [Game]{
    mimicEvents()
    return constantGames
}
