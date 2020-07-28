//
//  TrophyMenu.swift
//  swipen
//
//  Created by Colton Lipchak on 7/8/20.
//  Copyright © 2020 clipchak. All rights reserved.
//

import SpriteKit

class TrophyMenuNode: SKNode{
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(position: CGPoint) {
        super.init()
        extractSavedVariables()
        
        self.alpha = 0
        self.zPosition = 2
        self.position = position
        
        let totalSwipesLbl = makeLabel(text: "swipes", position: CGPoint(x: width/2, y: height - safeAreaTop/2 - 40), fontString: fontString, fontColor: .white, fontSize: 22)
        let totalSwipesNmbr = makeLabel(text: "\(totalSwipes)", position: CGPoint(x: 0, y: -37), fontString: fontString, fontColor: .white, fontSize: 40)
        totalSwipesLbl.addChild(totalSwipesNmbr)
        self.addChild(totalSwipesLbl)
        
//        let totalGamesLbl = makeLabel(text: "games", position: CGPoint(x: width/2, y: safeAreaBottom/2 + 55), fontString: fontString, fontColor: .white, fontSize: 22)
//        let totalGamesNmbr = makeLabel(text: "\(totalGames)", position: CGPoint(x: 0, y: -37), fontString: fontString, fontColor: .white, fontSize: 40)
//        totalGamesLbl.addChild(totalGamesNmbr)
//        self.addChild(totalGamesLbl)
        
        let beginnerTitle = makeLabel(text: "Beginner", position: CGPoint(x: width/2, y: height/2 + 150), fontString: fontString, fontColor: .white, fontSize: 40)
        let beginnerScore = TrophyLabelNode(text: "timed best of 10", position: CGPoint(x: -65, y: -30))
        if timedHighscore >= 10{
            beginnerScore.check.texture = SKTexture(imageNamed: "checkmark")
        }
        let beginnerSwipes = TrophyLabelNode(text: "500 swipes", position: CGPoint(x: -65, y: -60))
        if totalSwipes >= 500 {
            beginnerSwipes.check.texture = SKTexture(imageNamed: "checkmark")
        }
        beginnerTitle.addChild(beginnerScore)
        beginnerTitle.addChild(beginnerSwipes)
        
        let advancedTitle = makeLabel(text: "Advanced", position: CGPoint(x: width/2, y: height/2), fontString: fontString, fontColor: .white, fontSize: 40)
        let advancedScore = TrophyLabelNode(text: "timed best of 50", position: CGPoint(x: -65, y: -30))
        if timedHighscore >= 50{
            advancedScore.check.texture = SKTexture(imageNamed: "checkmark")
        }
        let advancedSwipes = TrophyLabelNode(text: "5,000 swipes", position: CGPoint(x: -65, y: -60))
        if totalSwipes >= 5000 {
            advancedSwipes.check.texture = SKTexture(imageNamed: "checkmark")
        }
        advancedTitle.addChild(advancedScore)
        advancedTitle.addChild(advancedSwipes)
               
        let championTitle = makeLabel(text: "Champion", position: CGPoint(x: width/2, y: height/2 - 150), fontString: fontString, fontColor: .white, fontSize: 40)
        let championScore = TrophyLabelNode(text: "timed best of 100", position: CGPoint(x: -65, y: -30))
        if timedHighscore >= 100{
            championScore.check.texture = SKTexture(imageNamed: "checkmark")
        }
        let championSwipes = TrophyLabelNode(text: "15,000 swipes", position: CGPoint(x: -65, y: -60))
        if totalSwipes >= 15000 {
            championSwipes.check.texture = SKTexture(imageNamed: "checkmark")
        }
        championTitle.addChild(championScore)
        championTitle.addChild(championSwipes)
        
        self.addChild(beginnerTitle)
        self.addChild(advancedTitle)
        self.addChild(championTitle)
    }
    
    func extractSavedVariables(){
        if UserDefaults.standard.object(forKey: "totalSwipes") != nil {
            totalSwipes = UserDefaults.standard.integer(forKey: "totalSwipes")
        }
        
        if UserDefaults.standard.object(forKey: "regHighscore") != nil {
            regHighscore = UserDefaults.standard.integer(forKey: "regHighscore")
        }
        
        if UserDefaults.standard.object(forKey: "timedHighscore") != nil {
            timedHighscore = UserDefaults.standard.integer(forKey: "timedHighscore")
        }
        
        if UserDefaults.standard.object(forKey: "totalGames") != nil {
            totalGames = UserDefaults.standard.integer(forKey: "totalGames")
        }
        
        if UserDefaults.standard.object(forKey: "timedModeOn") != nil {
            timedModeOn = UserDefaults.standard.bool(forKey: "timedModeOn")
        }
        
        if UserDefaults.standard.object(forKey: "soundOn") != nil {
            soundOn = UserDefaults.standard.bool(forKey: "soundOn")
        }
    }
    
}
