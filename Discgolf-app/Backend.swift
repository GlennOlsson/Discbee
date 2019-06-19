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

func getRounds() -> [Game]{
    return constantGames
}
