//
//  MenuHUDNode.swift
//  swipen
//
//  Created by Colton Lipchak on 7/8/20.
//  Copyright © 2020 clipchak. All rights reserved.
//

import SpriteKit

class MenuHUDNode: SKNode{
    var timerCirclesMenu = SKNode()

    var pauseButton = SKSpriteNode()
    var soundButton = SKSpriteNode()
    var timedButton = SKSpriteNode()
    var trophyButton = SKSpriteNode()
    var logoNode = SKSpriteNode()
    
    var highscoreLbl = SKLabelNode()
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(position: CGPoint) {
        super.init()
        self.position = position
        
        extractSavedVariables()
        
        let bestLbl = makeLabel(text: "best", position: CGPoint(x: width - 50, y: height - safeAreaTop/2 - 40), fontString: fontString, fontColor: .white, fontSize: 22)
        bestLbl.zPosition = 5
        highscoreLbl = makeLabel(text: "\(regHighscore)", position: CGPoint(x: 0, y: -37), fontString: fontString, fontColor: .white, fontSize: 40)
        if timedModeOn {
            highscoreLbl.text = "\(timedHighscore)"
        }
        bestLbl.addChild(highscoreLbl)
        self.addChild(bestLbl)
        
        if timedModeOn {
            timedButton = makeSpriteNode(imageNamed: "timerOn", name: "timedButton", size: CGSize(width: 50, height: 50), position: CGPoint(x: 45, y: height - safeAreaTop/2 - 48), zPosition: 5, alpha: 1)
        } else{
            timedButton = makeSpriteNode(imageNamed: "timerOff", name: "timedButton", size: CGSize(width: 50, height: 50), position: CGPoint(x: 45, y: height - safeAreaTop/2 - 48), zPosition: 5, alpha: 1)
        }
        self.addChild(timedButton)
        
        if soundOn {
            soundButton = makeSpriteNode(imageNamed: "soundOn", name: "soundButton", size: standardSize, position: CGPoint(x: 45, y: height - safeAreaTop/2 - 48), zPosition: 5, alpha: 1)
        } else{
            soundButton = makeSpriteNode(imageNamed: "soundOff", name: "soundButton", size: standardSize, position: CGPoint(x: 45, y: height - safeAreaTop/2 - 48), zPosition: 5, alpha: 1)
        }
        if !restartFromALoss {
            soundButton.alpha = 0
        }
        self.addChild(soundButton)
        
        let blackSq3 = SKSpriteNode(color: .clear, size: CGSize(width: 55, height: 55))
        blackSq3.position = CGPoint(x: width - 45, y: safeAreaBottom/2 + 45)
        blackSq3.name = "leaderboardButton"
        blackSq3.zPosition = 2
        self.addChild(blackSq3)
        
        let lbThirdSquare = SKSpriteNode(color: .white, size: CGSize(width: 12, height: 15) )
        lbThirdSquare.name = "leaderboardButton"
        lbThirdSquare.position = CGPoint(x: width - 68, y: safeAreaBottom/2 + 23)
        lbThirdSquare.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        lbThirdSquare.zPosition = 2
        self.addChild(lbThirdSquare)
        
        let lbFirstSquare = SKSpriteNode(color: .white, size: CGSize(width: 12, height: 38) )
        lbFirstSquare.name = "leaderboardButton"
        lbFirstSquare.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        lbFirstSquare.position = CGPoint(x: width - 52, y: safeAreaBottom/2 + 23)
        lbFirstSquare.zPosition = 2
        self.addChild(lbFirstSquare)
        
        let lbSecondSquare = SKSpriteNode(color: .white, size: CGSize(width: 12, height: 25) )
        lbSecondSquare.name = "leaderboardButton"
        lbSecondSquare.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        lbSecondSquare.position = CGPoint(x: width - 36, y: safeAreaBottom/2 + 23)
        lbSecondSquare.zPosition = 2
        self.addChild(lbSecondSquare)
        
        timerCirclesMenu.zPosition = 5
        timerCirclesMenu.position = CGPoint(x: width/2 - 40, y: height - safeAreaTop/2 - 50)
        self.addChild(timerCirclesMenu)
        
        pauseButton = makeSpriteNode(imageNamed: "pause", name: "pauseButton", size: CGSize(width: 42, height: 42), position: CGPoint(x: 45, y: safeAreaBottom/2 + 45), zPosition: 5, alpha: 0)
        self.addChild(pauseButton)
        
        trophyButton = makeSpriteNode(imageNamed: "trophy", name: "trophyButton", size: CGSize(width: 42, height: 42), position: CGPoint(x: 45, y: safeAreaBottom/2 + 45), zPosition: 5, alpha: 1)
        trophyButton.run(trophyActionSequence, withKey: "trophy")
        self.addChild(trophyButton)
        
    }

    func changeSound(){
        if soundOn {
            soundButton.texture = SKTexture(imageNamed: "soundOff")
            soundOn = false
            UserDefaults.standard.set(false, forKey: "soundOn")
        } else{
            soundButton.texture = SKTexture(imageNamed: "soundOn")
            soundOn = true
            UserDefaults.standard.set(true, forKey: "soundOn")
        }
    }
    
    func gameStart(){
        //menuButtons.run(.fadeIn(withDuration: 0.1))
        trophyButton.alpha = 0
        trophyButton.removeAllActions()
        timedButton.alpha = 0
        soundButton.alpha = 1
        pauseButton.alpha = 1
        restartFromALoss = false
    }
    
    func restartFromLoss(){
        ///display interstitial advertisement then load a new one 
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentInterstitialAd"), object: nil)
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadInterstitialAd"), object: nil)
        pauseButton.alpha = 0
        trophyButton.alpha = 0
        timedButton.alpha = 0
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
