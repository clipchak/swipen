//
//  TrophyScene.swift
//  swipe'n
//
//  Created by Colton Lipchak on 5/1/20.
//  Copyright © 2020 clipchak. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit
import AudioToolbox
import UIKit

class GameScene: SKScene, GKGameCenterControllerDelegate {
    let audio = JKAudioPlayer.sharedInstance()
    
    var swipeLeft = UISwipeGestureRecognizer()
    var swipeRight = UISwipeGestureRecognizer()
    var swipeUp = UISwipeGestureRecognizer()
    var swipeDown = UISwipeGestureRecognizer()

    var pauseButton = SKSpriteNode()
    var soundButton = SKSpriteNode()
    var timedButton = SKSpriteNode()
    var trophy = SKSpriteNode()
    var logoNode = SKSpriteNode()
    
    var gameIsPaused = false
    var gameOver = false
    var soundOn = true
    var transitionOccurring = false
    var trophiesOn = false
    var trophyMenuReleased = true
    
    var currentColor = ColorNode()
    var nextColor = ColorNode()
    var newSetOfColorSprites = [ColorNode]()
    
    var score = Int(0)
    var index = Int(2)
    var totalSwipes = Int(0)
    var totalGames = Int(0)
    var regHighscore = Int(0)
    var timedHighscore = Int(0)
    var menuAlignment = SKLabelVerticalAlignmentMode(rawValue: 2)!
    
    var timerCirclesMenu = SKNode()
    var timerCirclesGame = SKNode()
    var menuNode = SKNode()
    var restartFromLossMenu = SKNode()
    var trophyMenu = SKNode()
    
    var highscoreLbl = SKLabelNode()

    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        menuScenePresented = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "authPlayer"), object: nil)

        addSwipeGestures()
        
        extractSavedVariables()
        
        initColors()
        
        addLabelsAndButtons()
        
        addColorToScreen()
                
    }
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PAUSING FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func addPauseMenu(){
        UserDefaults.standard.set(totalSwipes, forKey: "totalSwipes")
        menuNode.position = CGPoint(x: width/2 + 15, y: -25)
        menuNode.alpha = 0.0
        menuNode.zPosition = 5
        addChild(menuNode)
        currentColor.arrow.isHidden = true
        
        let shareScoreButton = makeLabel(text: "share", name: "shareScore", verticalAlignment: menuAlignment, position: CGPoint(x: -15, y: height/2 + 40), fontColor: .white, fontSize: 18, fontString: fontString)
        
        let rateAppButton = makeLabel(text: "rate", name: "rateAppButton", verticalAlignment: menuAlignment, position: CGPoint(x: -100, y: height/2 - 16), fontColor: .white, fontSize: 40, fontString: fontString)
                
        let quitButton = makeLabel(text: "quit", name: "quitButton", verticalAlignment: menuAlignment, position: CGPoint(x: 70, y: height/2 - 15), fontColor: .white, fontSize: 40, fontString: fontString)

        currentColor.scoreLabel.run(.sequence([.moveBy(x: 0, y: 75, duration: 0.3), .run {
                self.menuNode.addChild(shareScoreButton)
                self.menuNode.addChild(rateAppButton)
                self.menuNode.addChild(quitButton)
                self.pauseButton.name = "resumeButton"
        }]))
        menuNode.run(.fadeAlpha(to: 0.8, duration: 0.5))
    }
    
    func addLoseMenu(){
        menuNode.position = CGPoint(x: 0, y: -25)
        menuNode.zPosition = 5
        currentColor.addChild(menuNode)
        currentColor.arrow.isHidden = true
        menuNode.alpha = 0

        let shareScoreButton = makeLabel(text: "share", name: "shareScore", verticalAlignment: menuAlignment, position: CGPoint(x: 0, y: 40), fontColor: .white, fontSize: 18, fontString: fontString)
        
        let rateAppButton = makeLabel(text: "rate", name: "rateAppButton", verticalAlignment: menuAlignment, position: CGPoint(x: -100, y: -16), fontColor: .white, fontSize: 40, fontString: fontString)
        
        let quitButton = makeLabel(text: "quit", name: "quitButtn", verticalAlignment: menuAlignment, position: CGPoint(x: 90, y: -20), fontColor: .white, fontSize: 40, fontString: fontString)
        
        let swipeToRestart = makeLabel(text: "swipe           to restart", name: "", verticalAlignment: menuAlignment, position: CGPoint(x: 0, y: -175), fontColor: .white, fontSize: 18, fontString: fontString)
        swipeToRestart.alpha = 0
        let arrow = SKSpriteNode(imageNamed: "arrowRight")
        arrow.alpha = 0.8
        arrow.scale(to: CGSize(width: 50, height: 25))
        arrow.position = CGPoint(x: -13, y: -9)
        swipeToRestart.addChild(arrow)
        menuNode.addChild(swipeToRestart)
        resetGame()
        currentColor.scoreLabel.run(.sequence([.moveBy(x: 0, y: 75, duration: 0.3), .run {
                self.menuNode.addChild(shareScoreButton)
                self.menuNode.addChild(rateAppButton)
                self.menuNode.addChild(quitButton)
            },.wait(forDuration: 0.2),.run {
                    let menuScene = GameScene(size: self.size)
                    menuScene.scaleMode = .aspectFit
                    self.view?.presentScene(menuScene)
            }]))
        
        menuNode.run(.fadeAlpha(to: 0.8, duration: 0.5))
    }
    
    func resetGame(){
        newMenuColor = ColorNode(color: currentColor.color, colorClass: currentColor.colorClass, name: currentColor.name!)
        restartFromALoss = true
        lastGameScore = score
    }
    
    func removePauseMenu(){
        currentColor.scoreLabel.run(.sequence([.moveBy(x: 0, y: -75, duration: 0.3), .run {
            if !self.gameIsPaused {
                self.currentColor.arrow.isHidden = false

            }
            }]))
        menuNode.removeAllChildren()
        menuNode.removeFromParent()
    }
    
    func pauseGame(){
        if(!gameIsPaused && !gameOver){
            currentColor.scoreLabel.name = "shareScore"
            pauseButton.texture = SKTexture(imageNamed: "resume")
            gameIsPaused = true
            swipeEnabler(bool: false)
            addPauseMenu()
        }
    }
    
    func unpauseGame(){
        if gameIsPaused {
            currentColor.scoreLabel.name = ""
            pauseButton.texture = SKTexture(imageNamed: "pause")
            gameIsPaused = false
            swipeEnabler(bool: true)
            removePauseMenu()
            pauseButton.name = "pauseButton"
        }
    }
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ HANDLE LABELS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
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
    }
    
    func addLabelsAndButtons(){
        let bestLbl = makeLabel(text: "best", position: CGPoint(x: width - 50, y: height - safeAreaTop/2 - 40), fontString: "Damascus", fontColor: .white, fontSize: 22)
        bestLbl.zPosition = 5
        highscoreLbl = makeLabel(text: "\(regHighscore)", position: CGPoint(x: 0, y: -37), fontString: "Damascus", fontColor: .white, fontSize: 40)
        if timedModeOn {
            highscoreLbl.text = "\(timedHighscore)"
        }
        addChild(bestLbl)
        bestLbl.addChild(highscoreLbl)
        
        if UserDefaults.standard.object(forKey: "timedModeOn") != nil {
            timedModeOn = UserDefaults.standard.bool(forKey: "timedModeOn")
        }
        if timedModeOn {
            timedButton = makeSpriteNode(imageNamed: "timerOn", name: "timedButton", size: CGSize(width: 50, height: 50), position: CGPoint(x: 45, y: height - safeAreaTop/2 - 48), zPosition: 5, alpha: 1)
        } else{
            timedButton = makeSpriteNode(imageNamed: "timerOff", name: "timedButton", size: CGSize(width: 50, height: 50), position: CGPoint(x: 45, y: height - safeAreaTop/2 - 48), zPosition: 5, alpha: 1)
        }
        addChild(timedButton)
        
        if UserDefaults.standard.object(forKey: "soundOn") != nil {
            soundOn = UserDefaults.standard.bool(forKey: "soundOn")
        }
        if soundOn {
            soundButton = makeSpriteNode(imageNamed: "soundOn", name: "soundButton", size: standardSize, position: CGPoint(x: 45, y: height - safeAreaTop/2 - 48), zPosition: 5, alpha: 1)
        } else{
            soundButton = makeSpriteNode(imageNamed: "soundOff", name: "soundButton", size: standardSize, position: CGPoint(x: 45, y: height - safeAreaTop/2 - 48), zPosition: 5, alpha: 1)
        }
        if !restartFromALoss {
            timedButton.run(.fadeIn(withDuration: 0.5))
            soundButton.alpha = 0
        }
        addChild(soundButton)
        
        let blackSq3 = SKSpriteNode(color: .clear, size: CGSize(width: 55, height: 55))
        blackSq3.position = CGPoint(x: width - 45, y: safeAreaBottom/2 + 45)
        blackSq3.name = "leaderboardButton"
        blackSq3.zPosition = 2
        addChild(blackSq3)
        
        let lbThirdSquare = SKSpriteNode(color: .white, size: CGSize(width: 12, height: 15) )
        lbThirdSquare.name = "leaderboardButton"
        lbThirdSquare.position = CGPoint(x: width - 68, y: safeAreaBottom/2 + 23)
        lbThirdSquare.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        lbThirdSquare.zPosition = 2
        addChild(lbThirdSquare)
        
        let lbFirstSquare = SKSpriteNode(color: .white, size: CGSize(width: 12, height: 38) )
        lbFirstSquare.name = "leaderboardButton"
        lbFirstSquare.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        lbFirstSquare.position = CGPoint(x: width - 52, y: safeAreaBottom/2 + 23)
        lbFirstSquare.zPosition = 2
        addChild(lbFirstSquare)
        
        let lbSecondSquare = SKSpriteNode(color: .white, size: CGSize(width: 12, height: 25) )
        lbSecondSquare.name = "leaderboardButton"
        lbSecondSquare.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        lbSecondSquare.position = CGPoint(x: width - 36, y: safeAreaBottom/2 + 23)
        lbSecondSquare.zPosition = 2
        addChild(lbSecondSquare)
        
        timerCirclesMenu.zPosition = 5
        timerCirclesMenu.position = CGPoint(x: width/2 - 40, y: height - safeAreaTop/2 - 50)
        addChild(timerCirclesMenu)
        
        timerCirclesGame.zPosition = 5
        timerCirclesGame.position = CGPoint(x: width/2 - 40, y: height - safeAreaTop/2 - 50)
        addChild(timerCirclesGame)
        
        pauseButton = makeSpriteNode(imageNamed: "pause", name: "pauseButton", size: CGSize(width: 42, height: 42), position: CGPoint(x: 45, y: safeAreaBottom/2 + 45), zPosition: 5, alpha: 0)
        addChild(pauseButton)
        pauseButton.run(.fadeIn(withDuration: 0.5))
    }
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ HANDLE SWIPES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func wrongSwipeFunction(){
        if soundOn{
            AudioServicesPlaySystemSound(4095)
        }
        gameIsPaused = true
        swipeEnabler(bool: false)
        gameOver = true
        pauseButton.removeFromParent()
        
        addLoseMenu()
        
        //animate the new high score
        var highestScore = Int(0)
        if timedModeOn {
            highestScore = UserDefaults.standard.integer(forKey: "timedHighscore")
        } else{
            highestScore = UserDefaults.standard.integer(forKey: "regHighscore")
        }
        
        let scoreDifference = score - highestScore
        let scoreIncAction = SKAction.run {
            self.highscoreLbl.text = "\(highestScore + 1)"
            highestScore = highestScore + 1
        }
        let waitAction = SKAction.wait(forDuration: 0.15)
        let repeatActions = SKAction.sequence([scoreIncAction,waitAction])
        let repeatUntil = SKAction.repeat(repeatActions, count: scoreDifference)

        if scoreDifference > 0 {
            self.run(.sequence([.wait(forDuration: 0.75),repeatUntil]))
        }
        storeHighScoreAndTotalSwipes()
    }
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ HANDLE COLORS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func initColors(){
        setColorNodesArray()
        newSetOfColorSprites.append(newGameNodes[0])
        newSetOfColorSprites.append(newGameNodes[1])
    }
    
    func showMenu(){
        if timedModeOn {
            runTimerOnMenu()
        }
        swipeUp.isEnabled = false
        swipeLeft.isEnabled = false
        swipeDown.isEnabled = false

        if restartFromALoss {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentInterstitialAd"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadInterstitialAd"), object: nil)
            pauseButton.isHidden = true
            let node = copyNode(node: newSetOfColorSprites[0])
            node.scoreLabel.isHidden = false
            node.arrow.isHidden = true
            node.scoreLabel.text = "\(lastGameScore)"
            node.scoreLabel.name = "shareScore"
            node.scoreLabel.position = CGPoint(x: node.scoreLabel.position.x, y: node.scoreLabel.position.y + 75)
            restartFromLossMenu.position = CGPoint(x: 0, y: -25)
            restartFromLossMenu.zPosition = 5
            restartFromLossMenu.alpha = 0.8
            
            node.addChild(restartFromLossMenu)
            currentColor = node
            currentColor.zPosition = 0.1
            
            let shareScore = makeLabel(text: "share", name: "shareScore", verticalAlignment: menuAlignment, position: CGPoint(x: 0, y: 40), fontColor: .white, fontSize: 18, fontString: fontString)
            
            let rateApp = makeLabel(text: "rate", name: "rateAppButton", verticalAlignment: menuAlignment, position: CGPoint(x: -100, y: -16), fontColor: .white, fontSize: 40, fontString: fontString)
            
            let quit = makeLabel(text: "quit", name: "quitButton", verticalAlignment: menuAlignment, position: CGPoint(x: 90, y: -20), fontColor: .white, fontSize: 40, fontString: fontString)
            
            let swipeToRestart = makeLabel(text: "swipe           to restart", name: "", verticalAlignment: menuAlignment, position: CGPoint(x: 0, y: -175), fontColor: .white, fontSize: 18, fontString: fontString)
            let arrow = SKSpriteNode(imageNamed: "arrowRight")
            arrow.alpha = 0.8
            arrow.scale(to: CGSize(width: 50, height: 25))
            arrow.position = CGPoint(x: -13, y: -9)
            swipeToRestart.addChild(arrow)
            
            //restartFromLossMenu.addChild(swipeToRestart)
            restartFromLossMenu.addChild(shareScore)
            restartFromLossMenu.addChild(rateApp)
            restartFromLossMenu.addChild(quit)
            
        } else{
            let node = copyNode(node: newSetOfColorSprites[0])
            node.scoreLabel.isHidden = true
            node.arrow.isHidden = true
            currentColor = node
            currentColor.zPosition = 0.1
            currentColor.scoreLabel.text = "\(score)"
            logoNode = SKSpriteNode(imageNamed: "menuArrow")
            logoNode.size = CGSize(width: 200, height: 100)
            currentColor.addChild(logoNode)
        }

        //currentColor.run(moveColorAction, withKey: "moveColor")
        let moveColorActionSequence2 = SKAction.sequence([logoWaitAction,.run {
            if !self.trophiesOn {
                self.currentColor.run(SKAction.sequence([moveLogoRightAction,moveLogoLeftAction]))
            }
        },delayAction,delayAction,delayAction])
        let moveColorAction2 = SKAction.repeatForever(moveColorActionSequence2)
        currentColor.run(moveColorAction2, withKey: "moveColor")

        
        logoNode.alpha = 0.0
        logoNode.run(.fadeIn(withDuration: 0.5),withKey: "fadeIn")
        
        pauseButton.texture = SKTexture(imageNamed: "trophy")
        pauseButton.name = "trophyButton"
        pauseButton.run(trophyActionSequence, withKey: "trophy")
                
        nextColor = copyNode(node: newSetOfColorSprites[1])
        addChild(nextColor)
        addChild(currentColor)
        print(currentColor.name!)
        print(newGameNodes)

    }
    
    func addColorToScreen(){
        if score == 0 {
            showMenu()
        }
        
        if score == 1 {
            restartFromALoss = false
            timedButton.removeAllActions()
            timedButton.run(.sequence([.fadeOut(withDuration: 0.15),.run {
                self.soundButton.run(.fadeIn(withDuration: 0.3))
                }]))

            swipeLeft.isEnabled = true
            pauseButton.isHidden = false
            pauseButton.texture = SKTexture(imageNamed: "pause")
            pauseButton.removeAction(forKey: "trophy")
            pauseButton.name = "pauseButton"
            
            currentColor = copyNode(node: newSetOfColorSprites[1])
            newSetOfColorSprites[1].didAppear = true
            currentColor.zPosition = 0.1
            currentColor.scoreLabel.text = "\(score)"
            addChild(currentColor)

            nextColor.removeFromParent()
            nextColor = copyNode(node: newSetOfColorSprites[0])
            newSetOfColorSprites[0].didAppear = true
            addChild(nextColor)
            transitionOccurring = false
            
            if timedModeOn {
                timerCirclesMenu.run(.fadeOut(withDuration: 0.25))
                pauseButton.isHidden = true
            }
        }
        
        if score > 1 {
            currentColor = copyNode(node: nextColor)
            currentColor.zPosition = 0.1
            currentColor.scoreLabel.text = "\(score)"
            print(currentColor.name!)
            addChild(currentColor)

            nextColor.removeFromParent()
            let nodePointer = newSetOfColorSprites.randomElement()!
            nextColor = copyNode(node: nodePointer)
            if !nodePointer.didAppear {
                nodePointer.didAppear = true
            }
            addChild(nextColor)
            transitionOccurring = false

            if chance(of: 8){
                newSetOfColorSprites.append(newGameNodes[index])
                if index == 2 {
                    swipeUp.isEnabled = true
                }
                if index == 3 {
                    swipeDown.isEnabled = true
                }
                
                index += 1
                print(index)
            }
            
        }
        

        
//        if score == 14 {
//            currentColor = copyNode(node: nextColor)
//            currentColor.zPosition = 0.1
//            currentColor.scoreLabel.text = "\(score)"
//            print(currentColor.name!)
//            addChild(currentColor)
//            transitionOccurring = false
//
//            newSetOfColorSprites.append(newGameNodes[2])
//            nextColor.removeFromParent()
//            nextColor = copyNode(node: newSetOfColorSprites[2])
//            newSetOfColorSprites[2].didAppear = true
//            swipeUp.isEnabled = true
//            addChild(nextColor)
//        }
        
    }
    
    func chance(of: Int) -> Bool{
        let d = Int.random(in: 1..<100)
        var chanceHit = false
        if of <= d {
            chanceHit = false
        } else{
            chanceHit = true
        }
        return chanceHit
    }
    
    func quitGame(){
        newMenuColor = ColorNode(color: currentColor.color, colorClass: currentColor.colorClass, name: currentColor.name!)
        currentColor.scoreLabel.run(.fadeAlpha(to: 0, duration: 0.2))
        pauseButton.run(.fadeAlpha(to: 0, duration: 0.2))
        if restartFromALoss {
            restartFromLossMenu.run(.sequence([.fadeAlpha(to: 0, duration: 0.2),
            .run({
                restartFromALoss = false
               let menuScene = GameScene(size: self.size)
               menuScene.scaleMode = .aspectFit
               self.view?.presentScene(menuScene)}
                )]))
        }else{
            menuNode.run(.sequence([.fadeAlpha(to: 0, duration: 0.2),
            .run({
               let menuScene = GameScene(size: self.size)
               menuScene.scaleMode = .aspectFit
               self.view?.presentScene(menuScene)}
                )]))
        }
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
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TOUCH/BUTTON PRESS FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "shareScore"{
                shareScore()
            }
            if nodesArray.first?.name == "rateAppButton"{
                rateApp()
            }
            if nodesArray.first?.name == "leaderboardButton"{
                showLeaderboard()
            }
            if nodesArray.first?.name == "quitButton"{
                quitGame()
            }
            if nodesArray.first?.name == "soundButton"{
                changeSound()
            }
            if nodesArray.first?.name == "pauseButton" && !gameIsPaused && !transitionOccurring{
                pauseGame()
            }
            if nodesArray.first?.name == "resumeButton" && gameIsPaused{
                unpauseGame()
            }
            if nodesArray.first?.name == "timedButton" && !transitionOccurring{
                if timedModeOn {
                    removeTimerOnMenu()
                } else{
                    runTimerOnMenu()
                }
            }
            if nodesArray.first?.name == "trophyButton" && !transitionOccurring {
                if trophiesOn && trophyMenuReleased {
                    closeTrophies()
                }else if trophyMenuReleased {
                        showTrophies()
                }
            }
        }
    }
    
    func closeTrophies(){
        pauseButton.isPaused = false
        trophyMenuReleased = false
        //currentColor.run(moveColorAction, withKey: "moveColor")
        trophyMenu.run(.sequence([.fadeOut(withDuration: 0.25), .run {
            self.trophyMenu.removeFromParent()
            self.swipeRight.isEnabled = true
            }]))
        logoNode.run(.sequence([.wait(forDuration: 0.3),.fadeIn(withDuration: 0.35),.run {
            self.trophyMenuReleased = true
            self.timerCirclesMenu.isHidden = false
            }]))
        pauseButton.texture = SKTexture(imageNamed: "trophy")
        trophiesOn = false
    }
        
    func showTrophies(){
        timerCirclesMenu.isHidden = true
        pauseButton.isPaused = true
        trophyMenuReleased = false
        //currentColor.removeAction(forKey: "moveColor")
        swipeRight.isEnabled = false
        logoNode.removeAction(forKey: "fadeIn")
        logoNode.run(.sequence([.fadeOut(withDuration: 0.25)]))
        pauseButton.texture = SKTexture(imageNamed: "ex")
        trophiesOn = true
            
        trophyMenu.position = CGPoint(x: 0, y: 0)
        trophyMenu.alpha = 0.0
        trophyMenu.zPosition = 2
        addChild(trophyMenu)
                               
        let totalSwipesLbl = makeLabel(text: "swipes", position: CGPoint(x: width/2, y: height - safeAreaTop/2 - 40), fontString: fontString, fontColor: .white, fontSize: 22)
        let totalSwipesNmbr = makeLabel(text: "\(totalSwipes)", position: CGPoint(x: 0, y: -37), fontString: fontString, fontColor: .white, fontSize: 40)
        totalSwipesLbl.addChild(totalSwipesNmbr)
        trophyMenu.addChild(totalSwipesLbl)
            
    //        let totalGamesLbl = makeLabel(text: "games", position: CGPoint(x: width/2, y: safeAreaBottom/2 + 55), fontName: fontString, fontColor: .white, fontSize: 22)
    //        let totalGamesNmbr = makeLabel(text: "\(totalGames)", position: CGPoint(x: 0, y: -37), fontName: fontString, fontColor: .white, fontSize: 40)
    //        totalGamesLbl.addChild(totalGamesNmbr)
    //        trophyMenu.addChild(totalGamesLbl)
               
        let beginnerTitle = makeLabel(text: "Beginner", position: CGPoint(x: width/2, y: height/2 + 150), fontString: fontString, fontColor: .white, fontSize: 40)
        let beginnerScore = TrophyLabelNode(text: "regular best of 15", position: CGPoint(x: -65, y: -30))
        if regHighscore >= 15{
            beginnerScore.check.texture = SKTexture(imageNamed: "checkmark")
        }
        let beginnerSwipes = TrophyLabelNode(text: "500 swipes", position: CGPoint(x: -65, y: -60))
        if totalSwipes >= 500 {
            beginnerSwipes.check.texture = SKTexture(imageNamed: "checkmark")
        }
        beginnerTitle.addChild(beginnerScore)
        beginnerTitle.addChild(beginnerSwipes)
               
        let advancedTitle = makeLabel(text: "Advanced", position: CGPoint(x: width/2, y: height/2), fontString: fontString, fontColor: .white, fontSize: 40)
        let advancedScore = TrophyLabelNode(text: "regular best of 50", position: CGPoint(x: -65, y: -30))
        if regHighscore >= 50{
            advancedScore.check.texture = SKTexture(imageNamed: "checkmark")
        }
        let advancedSwipes = TrophyLabelNode(text: "5,000 swipes", position: CGPoint(x: -65, y: -60))
        if totalSwipes >= 5000 {
            advancedSwipes.check.texture = SKTexture(imageNamed: "checkmark")
        }
        advancedTitle.addChild(advancedScore)
        advancedTitle.addChild(advancedSwipes)
               
        let championTitle = makeLabel(text: "Champion", position: CGPoint(x: width/2, y: height/2 - 150), fontString: fontString, fontColor: .white, fontSize: 40)
        let championScore = TrophyLabelNode(text: "regular best of 100", position: CGPoint(x: -65, y: -30))
        if regHighscore >= 100{
            championScore.check.texture = SKTexture(imageNamed: "checkmark")
        }
        let championSwipes = TrophyLabelNode(text: "15,000 swipes", position: CGPoint(x: -65, y: -60))
        if totalSwipes >= 15000 {
            championSwipes.check.texture = SKTexture(imageNamed: "checkmark")
        }
        championTitle.addChild(championScore)
        championTitle.addChild(championSwipes)
               
        trophyMenu.addChild(beginnerTitle)
        trophyMenu.addChild(advancedTitle)
        trophyMenu.addChild(championTitle)
        trophyMenu.run(.sequence([.wait(forDuration: 0.3),.fadeIn(withDuration: 0.25),.run {
            self.trophyMenuReleased = true
        }]))
            
    }
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ HELPER FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    
    func addSwipeGestures(){
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedLeft(sender:)))
        swipeLeft.direction = .left
        view!.addGestureRecognizer(swipeLeft)
           
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight(sender:)))
        swipeRight.direction = .right
        view!.addGestureRecognizer(swipeRight)
           
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp(sender:)))
        swipeUp.direction = .up
        view!.addGestureRecognizer(swipeUp)
        
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown(sender:)))
        swipeDown.direction = .down
        view!.addGestureRecognizer(swipeDown)
    }
       
    @objc func swipedLeft(sender: UISwipeGestureRecognizer) {
        if currentColor.swipeDirection == "left" && !transitionOccurring{
            moveLeft()
        }else if !transitionOccurring{
                wrongSwipeFunction()
        }
    }
       
    @objc func swipedRight(sender: UISwipeGestureRecognizer) {
        if currentColor.swipeDirection == "right" && !transitionOccurring{
            moveRight()
        }else if !transitionOccurring{
                wrongSwipeFunction()
        }
    }
       
    @objc func swipedUp(sender: UISwipeGestureRecognizer) {
        if currentColor.swipeDirection == "up" && !transitionOccurring{
            moveUp()
        }else if !transitionOccurring{
                wrongSwipeFunction()
        }
    }
       
    @objc func swipedDown(sender: UISwipeGestureRecognizer) {
        if currentColor.swipeDirection == "down" && !transitionOccurring{
            moveDown()
        }else if !transitionOccurring{
                wrongSwipeFunction()
        }
    }
    
    func correctMoveFunction(action: SKAction){
        if timedModeOn {
            removeTimerInGame()
        }
        transitionOccurring = true
        totalSwipes += 1
        score += 1
        nextColor.scoreLabel.text = "\(score)"
        currentColor.run(.sequence([action, .run {
            self.currentColor.removeFromParent()
            self.addColorToScreen()
        }]))
    }
    
    func moveRight(){
       
        let moveAction = SKAction.moveBy(x: width, y: 0, duration: 0.25)
        correctMoveFunction(action: moveAction)
    }
    
    func moveLeft(){
       
        let moveAction = SKAction.moveBy(x: -width, y: 0, duration: 0.25)
        correctMoveFunction(action: moveAction)
    }
    
    func moveUp(){
        
        let moveAction = SKAction.moveBy(x: 0, y: height, duration: 0.25)
        correctMoveFunction(action: moveAction)
    }
    
    func moveDown(){
        
        let moveAction = SKAction.moveBy(x: 0, y: -height, duration: 0.25)
        correctMoveFunction(action: moveAction)
    }
    
    func swipeEnabler(bool: Bool){
        swipeLeft.isEnabled = bool
        swipeRight.isEnabled = bool
        swipeUp.isEnabled = bool
        swipeDown.isEnabled = bool
    }
    
    func runTimerOnMenu(){
        timerCirclesMenu.alpha = 1
        timedButton.texture = SKTexture(imageNamed: "timerOn")
        highscoreLbl.text = "\(timedHighscore)"
        timedModeOn = true
        UserDefaults.standard.set(true, forKey: "timedModeOn")
        
        timerCirclesMenu.name = "timerCirclesMenu"
        let repeatAction = SKAction.repeatForever(addCirclesToMenu(menuNode: timerCirclesMenu))
        timerCirclesMenu.run(repeatAction)
    }
    
    func removeTimerOnMenu(){
           timedButton.texture = SKTexture(imageNamed: "timerOff")
           highscoreLbl.text = "\(regHighscore)"
           timedModeOn = false
           UserDefaults.standard.set(false, forKey: "timedModeOn")
           
           timerCirclesMenu.run(.sequence([.fadeOut(withDuration: 0.5),.run {
               self.timerCirclesMenu.removeAllChildren()
               self.timerCirclesMenu.removeAllActions()
           }]))
       }
    
    func runTimerInGame(){
        timerCirclesGame.alpha = 1
        timerCirclesGame.name = "timerCirclesGame"
        timerCirclesGame.run(addCirclesToMenu(menuNode: timerCirclesGame))
    }
    
    func removeTimerInGame(){
        self.timerCirclesGame.removeAllActions()
        timerCirclesGame.run(.sequence([.fadeOut(withDuration: 0.5),.run {
        self.timerCirclesGame.removeAllChildren()
            self.runTimerInGame()
        }]))
    }
    
    func addCirclesToMenu(menuNode: SKNode) -> SKAction{
        let circle1 = SKShapeNode(circleOfRadius: 5)
        circle1.alpha = 0
        circle1.fillColor = .white
        let circle2 = SKShapeNode(circleOfRadius: 5)
        circle2.alpha = 0
        circle2.fillColor = .white
        let circle3 = SKShapeNode(circleOfRadius: 5)
        circle3.alpha = 0
        circle3.fillColor = .white
        circle2.position = CGPoint(x: 38, y: 0)
        circle3.position = CGPoint(x: 76, y: 0)
        menuNode.addChild(circle1)
        menuNode.addChild(circle2)
        menuNode.addChild(circle3)
        
        let appearAction = SKAction.sequence([.wait(forDuration: 0.4),.run {
        circle1.run(.fadeIn(withDuration: 0.5))
        },.wait(forDuration: 0.5),.run {
            circle2.run(.fadeIn(withDuration: 0.5))
        },.wait(forDuration: 0.5),.run {
            circle3.run(.fadeIn(withDuration: 0.5))
        },.wait(forDuration: 0.5),.run {
            if menuNode.name == "timerCirclesGame" && !self.gameOver{
                self.wrongSwipeFunction()
            }
            if menuNode.name == "timerCirclesMenu" {
                circle1.run(.fadeOut(withDuration: 0.5))
                circle2.run(.fadeOut(withDuration: 0.5))
                circle3.run(.fadeOut(withDuration: 0.5))
            }
        }])
        
        let waitAction = SKAction.wait(forDuration: 1.5)
        
        if menuNode.name == "timerCirclesGame"{
            return appearAction
        } else{
            return SKAction.sequence([appearAction,waitAction])
        }
    }
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GAMECENTER FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    @IBAction func showLeaderboard() {
        let viewControllerVar = self.view?.window?.rootViewController
        let gKGCViewController = GKGameCenterViewController()
        gKGCViewController.gameCenterDelegate = self
        viewControllerVar?.present(gKGCViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func storeHighScoreAndTotalSwipes(){
        //store the player's high score to gc
        //saveHighscore(gameScore: Int(scoreLbl.text!)!)
        if timedModeOn{
            if UserDefaults.standard.object(forKey: "timedHighscore") != nil {
                let hscore = UserDefaults.standard.integer(forKey: "timedHighscore")
                if hscore < score{
                    UserDefaults.standard.set(score, forKey: "timedHighscore")
                }
            } else {
                UserDefaults.standard.set(score, forKey: "timedHighscore")
            }
        }else{
            if UserDefaults.standard.object(forKey: "regHighscore") != nil {
                let hscore = UserDefaults.standard.integer(forKey: "regHighscore")
                if hscore < score{
                    UserDefaults.standard.set(score, forKey: "regHighscore")
                }
            } else {
                UserDefaults.standard.set(score, forKey: "regHighscore")
            }
        }
        UserDefaults.standard.set(totalSwipes, forKey: "totalSwipes")
        UserDefaults.standard.set((totalGames+1), forKey: "totalGames")

    }
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SHARING ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func shareScore(){
        //Capture image of player's screen showing their score
        let image = view?.snapshot
        UIGraphicsEndImageContext()
        
        //Text that will send with the players score when they share
        let textToShare = "I swiped to \(score). What can you swipe to?"
        
        //Sets up and presents the view controller that will allow the player to share their score with friends
        if var top = scene?.view?.window?.rootViewController {
            while let presentedViewController = top.presentedViewController {
                top = presentedViewController
            }
            
            //Website links to the app
            if let myWebsite = URL(string: "http://itunes.apple.com/app/1519496187/") {
                let objectsToShare = [textToShare, myWebsite, image!] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                //Excluded activities
                activityVC.excludedActivityTypes = [
                    UIActivity.ActivityType.assignToContact,
                    UIActivity.ActivityType.addToReadingList,
                    UIActivity.ActivityType.copyToPasteboard,
                    UIActivity.ActivityType.markupAsPDF,
                    UIActivity.ActivityType.openInIBooks,]
                
                activityVC.popoverPresentationController?.sourceView = view
                top.present(activityVC, animated: true, completion: nil)
            }
        }
    }

}

