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

class AdvancedGameScene: SKScene, GKGameCenterControllerDelegate {
    let audio = JKAudioPlayer.sharedInstance()

    var logoNode = SKSpriteNode()
    
    var gameIsPaused = false
    var gameOver = false
    var transitionOccurring = false
    var trophiesOn = false
    var trophyMenuReleased = true
    
    var currentColor = ColorNode()
    var nextColor = ColorNode()
    var newSetOfColorSprites = [ColorNode]()
    
    var score = Int(0)
    var index = Int(2)
    
    var timerCirclesGame = SKNode()
    var menuButtons = MenuHUDNode()
    var menuNode = SKNode()
    var restartFromLossMenu = SKNode()
    var trophyMenu = SKNode()
        
    var touchPoint = CGPoint()
    var firstTouch = CGPoint()
    var touching = false
    var movingXDirection = false
    var movingYDirection = false
    var directionPicked = false
    var direction = ""
    
    var xDif = CGFloat()
    var yDif = CGFloat()

    override func didMove(to view: SKView) {
        menuScenePresented = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "authPlayer"), object: nil)
                
        initColors()
        
        addLabelsAndButtons()
        
        addColorToScreen()
        
    }
    
    func initColors(){
        setColorNodesArray()
        newSetOfColorSprites.append(newGameNodes[0])
        newSetOfColorSprites.append(newGameNodes[1])
    }
    
    func addLabelsAndButtons(){
        menuButtons = MenuHUDNode(position: CGPoint(x: 0, y: 0))
        addChild(menuButtons)
        
        timerCirclesGame.zPosition = 5
        timerCirclesGame.position = CGPoint(x: width/2 - 40, y: height - safeAreaTop/2 - 50)
        addChild(timerCirclesGame)
    }
    
    func addColorToScreen(){
        if score == 0 {
            showMenu()
        }
        
        if score == 1 {
            menuButtons.gameStart()
            
            currentColor = advancedCopyNode(node: newSetOfColorSprites[1], isNextNode: false, score: score)
            newSetOfColorSprites[1].didAppear = true
            currentColor.zPosition = 0.1
            currentColor.scoreLabel.text = "\(score)"
            addChild(currentColor)

            nextColor.removeFromParent()
            newSetOfColorSprites[0].didAppear = true
            nextColor = advancedCopyNode(node: newSetOfColorSprites[0], isNextNode: true, score: score)
            addChild(nextColor)
            transitionOccurring = false
            
            if timedModeOn {
                menuButtons.timerCirclesMenu.run(.fadeOut(withDuration: 0.25))
                menuButtons.pauseButton.isHidden = true
            }
        }
        
        if score > 1 {
            currentColor = advancedCopyNode(node: nextColor, isNextNode: false, score: score)
            currentColor.zPosition = 0.1
            currentColor.scoreLabel.text = "\(score)"
            print(currentColor.name!)
            addChild(currentColor)

            nextColor.removeFromParent()
            let nodePointer = newSetOfColorSprites.randomElement()!
            nextColor = advancedCopyNode(node: nodePointer, isNextNode: true, score: score)
            if !nodePointer.didAppear {
                nodePointer.didAppear = true
            }
            addChild(nextColor)
            transitionOccurring = false

            if chance(of: 8){
                newSetOfColorSprites.append(newGameNodes[index])
                if index == 2 {
                }
                if index == 3 {
                }
                
                index += 1
                print(index)
            }
            
        }
    }
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PAUSING FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func addPauseMenu(){
        currentColor.scoreLabel.name = "shareScore"
        menuButtons.pauseButton.texture = SKTexture(imageNamed: "resume")
        gameIsPaused = true
        menuNode = PauseMenuNode(position: CGPoint(x: width/2 + 15, y: -25), score: score, menuButtons: menuButtons)
        addChild(menuNode)
        currentColor.arrow.isHidden = true
        
        currentColor.scoreLabel.run(.sequence([.moveBy(x: 0, y: 75, duration: 0.3), .run {
            self.menuButtons.pauseButton.name = "resumeButton"
        }]))
        menuNode.run(.fadeAlpha(to: 0.8, duration: 0.5))
        
        storeHighScoreAndTotalSwipes()
    }
    
    func addLoseMenu(){
        menuNode = LoseMenuNode(position: CGPoint(x: 0, y: -25))
        currentColor.addChild(menuNode)
        
        ///reset and track some variables
        currentColor.arrow.isHidden = true
        newMenuColor = ColorNode(color: currentColor.color, colorClass: currentColor.colorClass, name: currentColor.name!)
        restartFromALoss = true
        lastGameScore = score

        currentColor.scoreLabel.run(.sequence([.moveBy(x: 0, y: 75, duration: 0.3),.wait(forDuration: 0.2),
                .run {
                    let menuScene = AdvancedGameScene(size: self.size)
                    menuScene.scaleMode = .aspectFit
                    self.view?.presentScene(menuScene)
            }]))
        menuNode.run(.fadeAlpha(to: 0.8, duration: 0.5))
    }
    
    func removePauseMenu(){
        currentColor.scoreLabel.name = ""
        menuButtons.pauseButton.texture = SKTexture(imageNamed: "pause")
        gameIsPaused = false
        currentColor.scoreLabel.run(.sequence([.moveBy(x: 0, y: -75, duration: 0.3), .run {
            if !self.gameIsPaused {
                self.currentColor.arrow.isHidden = false
            }
        }]))
        menuNode.removeAllChildren()
        menuNode.removeFromParent()
        menuButtons.pauseButton.name = "pauseButton"
    }
    
    func pauseGame(){
        if(!gameIsPaused && !gameOver){
            addPauseMenu()
        }
    }
    
    func unpauseGame(){
        if gameIsPaused {
            removePauseMenu()
        }
    }
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ HANDLE SWIPES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func wrongSwipeFunction(){
        if soundOn{
            AudioServicesPlaySystemSound(4095)
        }
        gameIsPaused = true
        gameOver = true
        menuButtons.pauseButton.alpha = 0
        
        addLoseMenu()
        
        UserDefaults.standard.set(totalSwipes, forKey: "totalSwipes")
        //saveHighscore(gameScore: totalSwipes, boardId: "swipenTotalSwipesNew")
        
        //storeHighScoreAndTotalSwipes()
    }
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ HANDLE COLORS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func showMenu(){
        if timedModeOn {
            runTimerOnMenu()
        }

        if restartFromALoss {
            menuButtons.restartFromLoss()
            
            let node = advancedCopyNode(node: newSetOfColorSprites[0], isNextNode: false, score: score)
            node.scoreLabel.isHidden = false
            node.arrow.isHidden = true
            node.scoreLabel.text = "\(lastGameScore)"
            node.scoreLabel.name = "shareScore"
            node.scoreLabel.position = CGPoint(x: node.scoreLabel.position.x, y: node.scoreLabel.position.y + 75)
  
            currentColor = node
            currentColor.zPosition = 0.1
            
            let prevScore = Int(currentColor.scoreLabel.text!) ?? 0
            restartFromLossMenu = RestartFromLossMenu(position: CGPoint(x: 0, y: -25), prevScore: prevScore, menuButtons: menuButtons)
            node.addChild(restartFromLossMenu)

            storeHighScoreAndTotalSwipes()
            //currentColor.run(moveColorAction, withKey: "moveColor")
            
        } else{
            let node = advancedCopyNode(node: newSetOfColorSprites[0], isNextNode: false, score: score)
            currentColor = node
            currentColor.scoreLabel.alpha = 0
            currentColor.arrow.alpha = 0
            currentColor.zPosition = 0.1
            currentColor.scoreLabel.text = "\(score)"
            logoNode = SKSpriteNode(imageNamed: "menuArrow")
            logoNode.name = "logoNode"
            logoNode.size = CGSize(width: 200, height: 100)
            currentColor.addChild(logoNode)
        }
                
        nextColor = advancedCopyNode(node: newSetOfColorSprites[1], isNextNode: true, score: score)
        addChild(nextColor)
        addChild(currentColor)
        print(currentColor.name!)
        print(newGameNodes)
    }
    
    func quitGame(){
        newMenuColor = ColorNode(color: currentColor.color, colorClass: currentColor.colorClass, name: currentColor.name!)
        currentColor.scoreLabel.run(.fadeAlpha(to: 0, duration: 0.2))
        menuButtons.pauseButton.run(.fadeAlpha(to: 0, duration: 0.2))
        if restartFromALoss {
            restartFromLossMenu.run(.sequence([.fadeAlpha(to: 0, duration: 0.2),
            .run({
                restartFromALoss = false
               let menuScene = AdvancedGameScene(size: self.size)
               menuScene.scaleMode = .aspectFit
               self.view?.presentScene(menuScene)}
                )]))
        }else{
            menuNode.run(.sequence([.fadeAlpha(to: 0, duration: 0.2),
            .run({
               let menuScene = AdvancedGameScene(size: self.size)
               menuScene.scaleMode = .aspectFit
               self.view?.presentScene(menuScene)}
                )]))
        }
    }
    
    func closeTrophies(){
        trophyMenuReleased = false
        trophyMenu.run(.sequence([.fadeOut(withDuration: 0.25), .run {
            self.trophyMenu.removeFromParent()
            self.trophyMenuReleased = true
            self.menuButtons.timerCirclesMenu.isHidden = false
            }]))
        logoNode.run(.sequence([.wait(forDuration: 0.3),.fadeIn(withDuration: 0.35),.run {
            }]),withKey: "trophyFade")
        menuButtons.trophyButton.texture = SKTexture(imageNamed: "trophy")
        trophiesOn = false
    }
        
    func showTrophies(){
        menuButtons.timerCirclesMenu.isHidden = true
        trophyMenuReleased = false
        logoNode.removeAllActions()
        logoNode.run(.sequence([.fadeOut(withDuration: 0.25)]))
        menuButtons.trophyButton.texture = SKTexture(imageNamed: "ex")
        trophiesOn = true
        
        trophyMenu = TrophyMenuNode(position: CGPoint(x: 0, y: 0))
        addChild(trophyMenu)
        
        trophyMenu.run(.sequence([.wait(forDuration: 0.3),.fadeIn(withDuration: 0.25),.run {
            self.trophyMenuReleased = true
        }]))
    }
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ HELPER FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func runTimerOnMenu(){
        menuButtons.timerCirclesMenu.alpha = 1
        menuButtons.timedButton.texture = SKTexture(imageNamed: "timerOn")
        menuButtons.highscoreLbl.text = "\(timedHighscore)"
        timedModeOn = true
        UserDefaults.standard.set(true, forKey: "timedModeOn")
        
        menuButtons.timerCirclesMenu.name = "timerCirclesMenu"
        let repeatAction = SKAction.repeatForever(addCirclesToMenu(menuNode: menuButtons.timerCirclesMenu))
        menuButtons.timerCirclesMenu.run(repeatAction)
    }
    
    func removeTimerOnMenu(){
        menuButtons.timedButton.texture = SKTexture(imageNamed: "timerOff")
        menuButtons.highscoreLbl.text = "\(regHighscore)"
        timedModeOn = false
        UserDefaults.standard.set(false, forKey: "timedModeOn")

        menuButtons.timerCirclesMenu.run(.sequence([.fadeOut(withDuration: 0.5),.run {
            self.menuButtons.timerCirclesMenu.removeAllChildren()
            self.menuButtons.timerCirclesMenu.removeAllActions()
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
        //store the player's high score to gamecenter
        var compareScore = score
        if score == 0 {
            compareScore = lastGameScore
        }
        if timedModeOn{
            //saveHighscore(gameScore: score, boardId: "swipenTimedScore")
            if UserDefaults.standard.object(forKey: "timedHighscore") != nil {
                let hscore = UserDefaults.standard.integer(forKey: "timedHighscore")
                if hscore < compareScore{
                    UserDefaults.standard.set(compareScore, forKey: "timedHighscore")
                }
            } else {
                UserDefaults.standard.set(compareScore, forKey: "timedHighscore")
            }
        }else{
            //saveHighscore(gameScore: score, boardId: "swipenRegularScore")
            if UserDefaults.standard.object(forKey: "regHighscore") != nil {
                let hscore = UserDefaults.standard.integer(forKey: "regHighscore")
                if hscore < compareScore{
                    UserDefaults.standard.set(compareScore, forKey: "regHighscore")
                }
            } else {
                UserDefaults.standard.set(compareScore, forKey: "regHighscore")
            }
        }
        UserDefaults.standard.set(totalSwipes, forKey: "totalSwipes")
        //saveHighscore(gameScore: totalSwipes, boardId: "swipenTotalSwipesNew")
        UserDefaults.standard.set((totalGames+1), forKey: "totalGames")

    }
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TOUCH/BUTTON PRESS FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    ///touch functions control all of the gameplay and whether the player loses
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            if (nodesArray.first?.name == currentColor.name || nodesArray.first?.name == "logoNode") && !trophiesOn  && !gameIsPaused {
                menuButtons.run(.fadeOut(withDuration: 0.10))
                currentColor.arrow.removeAllActions()
                logoNode.removeAction(forKey: "trophyFade")
                if score == 0 {
                    logoNode.run(.sequence([.fadeOut(withDuration: 0.10),.run {
                        self.currentColor.scoreLabel.run(.sequence([.fadeAlpha(to: 0.6, duration: 0.10)]))
                        self.currentColor.arrow.run(.sequence([.fadeAlpha(to: 0.6, duration: 0.10)]))
                    }]), withKey: "beginTouchAction")
                }
            }
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
            if nodesArray.first?.name == "soundButton" && !transitionOccurring{
                menuButtons.changeSound()
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
                } else if trophyMenuReleased {
                    showTrophies()
                }
            }
            if !touching{
                firstTouch = location
                xDif = currentColor.position.x - location.x
                yDif = currentColor.position.y - location.y
                touchPoint = location
                touching = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            touchPoint = location

            let xAbs = abs(touchPoint.x - firstTouch.x)
            let yAbs = abs(touchPoint.y - firstTouch.y)

            if xAbs > 4 && !directionPicked {
                directionPicked = true
                movingXDirection = true
                if (touchPoint.x - firstTouch.x) > 0 {
                    direction = "right"
                } else{
                    direction = "left"
                }
            }
            if yAbs > 4 && !directionPicked {
                directionPicked = true
                movingYDirection = true
                if (touchPoint.y - firstTouch.y) > 0 {
                    direction = "up"
                } else{
                    direction = "down"
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false
        directionPicked = false
        movingYDirection = false
        movingXDirection = false
        
        let currentVelocity = currentColor.physicsBody!.velocity
        let dx = abs(currentColor.physicsBody!.velocity.dx)
        let dy = abs(currentColor.physicsBody!.velocity.dy)
        let xPositionalDifference = abs(width/2 - currentColor.position.x)
        let yPositionalDifference = abs(height/2 - currentColor.position.y)
        
        var moveAction = SKAction.moveBy(x: width/2, y: 0, duration: 0.2)
        var correctVectorDirection = false
        
        switch direction {
        case "left":
            moveAction = SKAction.moveBy(x: -width/2, y: 0, duration: 0.2)
            correctVectorDirection = currentVelocity.dx < 0
        case "right":
            moveAction = SKAction.moveBy(x: width/2, y: 0, duration: 0.2)
            correctVectorDirection = currentVelocity.dx > 0
        case "up":
            moveAction = SKAction.moveBy(x: 0, y: height/2, duration: 0.2)
            correctVectorDirection = currentVelocity.dy > 0
        case "down":
            moveAction = SKAction.moveBy(x: 0, y: -height/2, duration: 0.2)
            correctVectorDirection = currentVelocity.dy < 0
        default:
            print("error in touches ended")
        }
        
        if (currentColor.swipeDirection == direction) && ( xPositionalDifference >= 150 || yPositionalDifference >= 180 || dx > 500 || dy > 500) && !transitionOccurring && correctVectorDirection {
            if timedModeOn {
                removeTimerInGame()
            }
            transitionOccurring = true
            totalSwipes += 1
            score += 1
            nextColor.scoreLabel.text = "\(score)"
            
            currentColor.run(.sequence([moveAction, .run {
                self.currentColor.removeFromParent()
                self.addColorToScreen()
            }]))
            
        } else if !transitionOccurring{
            transitionOccurring = true
            
            currentColor.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            currentColor.run(.sequence([.move(to: CGPoint(x: width/2, y: height/2), duration: 0.2),.run {
                self.transitionOccurring = false
            }]))
            
            if self.currentColor.swipeDirection != self.direction && (xPositionalDifference >= 150 || yPositionalDifference >= 180 || dx > 500 || dy > 500) && self.score != 0 {
                self.wrongSwipeFunction()
            }
            
            self.menuButtons.run(.fadeIn(withDuration: 0.1))
            logoNode.removeAction(forKey: "beginTouchAction")
            if score == 0 && !restartFromALoss{
                currentColor.scoreLabel.run(.fadeOut(withDuration: 0.1))
                currentColor.arrow.run(.sequence([.fadeOut(withDuration: 0.1),.run {
                    if !self.trophiesOn{
                        self.logoNode.run(.fadeIn(withDuration: 0.1))
                    }
                }]))
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false
        print("touch cancelled")
        transitionOccurring = true
        
        currentColor.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        currentColor.run(.sequence([.move(to: CGPoint(x: width/2, y: height/2), duration: 0.5),.run {
            self.transitionOccurring = false
            
        }]))
        
        self.menuButtons.run(.fadeIn(withDuration: 0.1))
        logoNode.removeAction(forKey: "beginTouchAction")
        if score == 0 && !restartFromALoss{
            currentColor.scoreLabel.run(.fadeOut(withDuration: 0.1))
            currentColor.arrow.run(.sequence([.fadeOut(withDuration: 0.1),.run {
                if !self.trophiesOn{
                    self.logoNode.run(.fadeIn(withDuration: 0.1))
                }
            }]))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if touching {
            let dt:CGFloat = 1.0/60.0
            var dx = touchPoint.x - currentColor.position.x + xDif
            var dy = touchPoint.y - currentColor.position.y + yDif
            
            let xPos = currentColor.position.x
            let yPos = currentColor.position.y
             
            if movingYDirection {
                dx = 0
            }
             
            if movingXDirection{
                dy = 0
            }

            var distance = CGVector(dx: dx, dy: dy)

            switch direction {
            case "left":
                if distance.dx/dt > 0 && xPos >= width/2 - 13{
                    dx = 0
                }
            case "right":
                if distance.dx/dt < 0 && xPos <= width/2 + 13{
                    dx = 0
                }
            case "down":
                if distance.dy/dt > 0 && yPos >= height/2 - 13{
                    dy = 0
                }
            case "up":
                if distance.dy/dt < 0 && yPos <= height/2 + 13{
                    dy = 0
                }
            default:
                print("error")
            }
            distance = CGVector(dx: dx, dy: dy)
             
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            if !transitionOccurring && directionPicked && !trophiesOn && !gameIsPaused && !gameOver{
                currentColor.physicsBody!.velocity = velocity
            }
            
        }
    }

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SHARING ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func shareScore(){
        //Capture image of player's screen showing their score
        let image = view?.snapshot
        UIGraphicsEndImageContext()
        
        //Text that will send with the players score when they share
        let scoreInt = Int(currentColor.scoreLabel.text!)
        let textToShare = "I'm swipe'n. Can you beat my score of \(scoreInt ?? 0)?"
        
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
                    UIActivity.ActivityType.markupAsPDF,
                    UIActivity.ActivityType.openInIBooks,]
                
                activityVC.popoverPresentationController?.sourceView = view
                top.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}

