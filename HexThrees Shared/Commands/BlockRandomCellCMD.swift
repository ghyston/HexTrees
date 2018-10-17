//
//  MarkRandomCellAsBlockedCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 20.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation


class EmptyCellDistributionCalculator: ICellsStatisticCalculator {
    
    var openCells: Int = 0
    var gameCells: Int = 0
    
    func next(cell: BgCell) {
        
        if cell.isBlocked {
           return
        }
        
        openCells += 1
        
        if cell.gameCell != nil {
            gameCells += 1
        }
    }
    
    func clean() {
        
        openCells = 0
        gameCells = 0
    }
}

class BlockRandomCellCMD : GameCMD {
    
    private func dontHaveGameCellAndBonuses (cell: BgCell) -> Bool {
        
        return
            cell.gameCell == nil &&
                !cell.isBlocked &&
                cell.bonus == nil
    }
    
    private func dontContainGameCell (cell: BgCell) -> Bool {
        
        return
            cell.gameCell == nil &&
            !cell.isBlocked
    }
    
    override func run() {
        
        let freeCells = gameModel.hasBgCells(compare: self.dontHaveGameCellAndBonuses) ?
            gameModel.getBgCells(compare: self.dontHaveGameCellAndBonuses) :
            gameModel.getBgCells(compare: self.dontContainGameCell)
        
        //@todo: fix it somehow
        var dice = ProbabilityArray<BgCell>()
        var calc = EmptyCellDistributionCalculator()
        var icalc : ICellsStatisticCalculator = calc
        // for some reason I cannot do &(calc as ICellsStatisticCalculator)
        
        for freeCell in freeCells {
            
            gameModel.calculateForSiblings(coord: freeCell.coord, calc: &icalc)
            
            let probability : Float = Float(calc.gameCells) / Float(calc.openCells)
            dice.add(freeCell, probability)
        }
        
        
        guard let randomCell = dice.getRandom() else {
            return
        }
        
        if randomCell.bonus != nil {
            
            randomCell.removeBonusWithDisposeAnimation()
        }
        
        randomCell.block()
    }
    
}
