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
        
        let totalGamesLbl = makeLabel(text: "games", position: CGPoint(x: width/2, y: safeAreaBottom/2 + 55), fontString: fontString, fontColor: .white, fontSize: 22)
        let totalGamesNmbr = makeLabel(text: "\(totalGames)", position: CGPoint(x: 0, y: -37), fontString: fontString, fontColor: .white, fontSize: 40)
        totalGamesLbl.addChild(totalGamesNmbr)
        self.addChild(totalGamesLbl)
        
        let beginnerTitle = makeLabel(text: "Beginner", position: CGPoint(x: width/2, y: height/2 + 160), fontString: fontString, fontColor: .white, fontSize: 40)
        let beginnerTimedScore = TrophyLabelNode(text: "timed best of 10", position: CGPoint(x: -65, y: -30))
        if timedHighscore >= 10{
            beginnerTimedScore.check.texture = SKTexture(imageNamed: "checkmark")
        }
        let beginnerUntimedScore = TrophyLabelNode(text: "untimed best of 20", position: CGPoint(x: -65, y: -60))
        if regHighscore >= 20{
            beginnerUntimedScore.check.texture = SKTexture(imageNamed: "checkmark")
        }
        let beginnerSwipes = TrophyLabelNode(text: "250 swipes", position: CGPoint(x: -65, y: -90))
        if totalSwipes >= 250 {
            beginnerSwipes.check.texture = SKTexture(imageNamed: "checkmark")
        }
        beginnerTitle.addChild(beginnerTimedScore)
        beginnerTitle.addChild(beginnerUntimedScore)
        beginnerTitle.addChild(beginnerSwipes)
        
        let advancedTitle = makeLabel(text: "Advanced", position: CGPoint(x: width/2, y: height/2), fontString: fontString, fontColor: .white, fontSize: 40)
        let advancedTimedScore = TrophyLabelNode(text: "timed best of 50", position: CGPoint(x: -65, y: -30))
        if timedHighscore >= 50{
            advancedTimedScore.check.texture = SKTexture(imageNamed: "checkmark")
        }
        let advancedUntimedScore = TrophyLabelNode(text: "untimed best of 75", position: CGPoint(x: -65, y: -60))
        if regHighscore >= 75{
            advancedUntimedScore.check.texture = SKTexture(imageNamed: "checkmark")
        }
        let advancedSwipes = TrophyLabelNode(text: "2,500 swipes", position: CGPoint(x: -65, y: -90))
        if totalSwipes >= 2500 {
            advancedSwipes.check.texture = SKTexture(imageNamed: "checkmark")
        }
        advancedTitle.addChild(advancedTimedScore)
        advancedTitle.addChild(advancedUntimedScore)
        advancedTitle.addChild(advancedSwipes)
               
        let championTitle = makeLabel(text: "Champion", position: CGPoint(x: width/2, y: height/2 - 160), fontString: fontString, fontColor: .white, fontSize: 40)
        let championTimedScore = TrophyLabelNode(text: "timed best of 75", position: CGPoint(x: -65, y: -30))
        if timedHighscore >= 75{
            championTimedScore.check.texture = SKTexture(imageNamed: "checkmark")
        }
        let championUntimedScore = TrophyLabelNode(text: "untimed best of 120", position: CGPoint(x: -65, y: -60))
        if regHighscore >= 120{
            championUntimedScore.check.texture = SKTexture(imageNamed: "checkmark")
        }
        let championSwipes = TrophyLabelNode(text: "10,000 swipes", position: CGPoint(x: -65, y: -90))
        if totalSwipes >= 10000 {
            championSwipes.check.texture = SKTexture(imageNamed: "checkmark")
        }
        championTitle.addChild(championTimedScore)
        championTitle.addChild(championUntimedScore)
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
