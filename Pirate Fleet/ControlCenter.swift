//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    var hitTracker: HitTracker
    

// TODO: Add the computed property, cells.
    var cells: [GridLocation] {
        get {
            // Hint: These two constants will come in handy
            let start = self.location
//            let end: GridLocation = ShipEndLocation(self)
            
//            // Hint: The cells getter should return an array of GridLocations.
            var occupiedCells = [GridLocation]()
            occupiedCells.append(start)
            if self.isVertical {
                for i in 1...self.length{
                    occupiedCells.append(GridLocation(x: start.x, y: start.y + i))
                }
            }else{
                for i in 1...self.length{
                    occupiedCells.append(GridLocation(x: start.x+i, y: start.y))
                }
            }
            return occupiedCells
        }
    }
    var sunk: Bool {
        for thing in hitTracker.cellsHit{
            if !thing.value{
                return false
            }
        }
        return true
    }
// TODO: Add custom initializers
    init(length: Int, location: GridLocation, isVertical: Bool, isWooden: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.isWooden = isWooden
        self.hitTracker = HitTracker()
    }
    init(length: Int, location: GridLocation, isVertical: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.hitTracker = HitTracker()
        self.isWooden = false
    }

}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol PenaltyCell {
    var location: GridLocation {get}
    var guaranteesHit: Bool {get}
    var penaltyText: String {get}
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: PenaltyCell {
    let location: GridLocation
    let guaranteesHit: Bool
    let penaltyText: String
    init(location: GridLocation, penaltyText: String) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteesHit = false
    }
    init(location: GridLocation, penaltyText: String ,guaranteesHit: Bool ) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteesHit = guaranteesHit
    }
}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: PenaltyCell {
    let location: GridLocation
    let guaranteesHit: Bool
    let penaltyText: String
    init(location: GridLocation) {
        self.location = location
        self.penaltyText = ""
        self.guaranteesHit = false
    }
}

class ControlCenter {
    
    func placeItemsOnGrid(_ human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true, isWooden: false)
        human.addShipToGrid(smallShip)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false)
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false, isWooden: false)
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true, isWooden: false)
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true, isWooden: false)
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(location: GridLocation(x: 6, y: 0),penaltyText:"BiuBiuBoom",guaranteesHit:true)
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(location: GridLocation(x: 3, y: 3),penaltyText:"BoomBiuBoom")
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6))
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2))
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(_ gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}
