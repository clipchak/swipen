//
//  RestartFromLossMenu.swift
//  swipen
//
//  Created by Colton Lipchak on 7/27/20.
//  Copyright © 2020 clipchak. All rights reserved.
//

import SpriteKit

class RestartFromLossMenu: SKNode{
    
    override init() {
           super.init()
    }

    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }

    init(position: CGPoint, prevScore: Int, menuButtons: MenuHUDNode) {
        super.init()
        self.position = position
        self.alpha = 0.8
        self.zPosition = 5
        
        let shareScoreButton = makeLabel(text: "share", name: "shareScore", verticalAlignment: menuAlignment, position: CGPoint(x: 0, y: 40), fontColor: .white, fontSize: 18, fontString: fontString)
        let rateAppButton = makeLabel(text: "rate", name: "rateAppButton", verticalAlignment: menuAlignment, position: CGPoint(x: -100, y: -16), fontColor: .white, fontSize: 40, fontString: fontString)
        let quitButton = makeLabel(text: "quit", name: "quitButton", verticalAlignment: menuAlignment, position: CGPoint(x: 90, y: -20), fontColor: .white, fontSize: 40, fontString: fontString)
        self.addChild(shareScoreButton)
        self.addChild(rateAppButton)
        self.addChild(quitButton)

        //animate the new high score
        var highestScore = Int(0)
        if timedModeOn {
            highestScore = UserDefaults.standard.integer(forKey: "timedHighscore")
        } else{
            highestScore = UserDefaults.standard.integer(forKey: "regHighscore")
        }

        let scoreDifference = prevScore - highestScore
        let scoreIncAction = SKAction.run {
            menuButtons.highscoreLbl.text = "\(highestScore + 1)"
            highestScore = highestScore + 1
        }
        let waitAction = SKAction.wait(forDuration: 0.15)
        let repeatActions = SKAction.sequence([scoreIncAction,waitAction])
        let repeatUntil = SKAction.repeat(repeatActions, count: scoreDifference)

        if scoreDifference > 0 {
            menuButtons.run(.sequence([.wait(forDuration: 0.75), repeatUntil]))
        }
        
    }
    
    
}
