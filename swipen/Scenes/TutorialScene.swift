//
//  Tutorial.swift
//  swipe'n
//
//  Created by Colton Lipchak on 6/11/20.
//  Copyright © 2020 clipchak. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit
import AudioToolbox
import UIKit

class TutorialScene: SKScene {
    var swipeLeft = UISwipeGestureRecognizer()
    var swipeRight = UISwipeGestureRecognizer()
    var slide = Int(1)
    
    var firstSlide = SKSpriteNode()
    var secondSlide = SKSpriteNode()
    var thirdSlide = SKSpriteNode()
    var fourthSlide = SKSpriteNode()
    var fifthSlide = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        menuScenePresented = true
        addTitleAndSkipLabels()
        addGestures()
        addFirstSlide()
        addSecondSlide()
        addThirdSlide()
        addFourthSlide()
        //addFifthSlide()
    }
    
    func addFirstSlide(){
        firstSlide = makeSpriteNode(color: UIColor(hexString: "#990000")!,name: "firstSlide", size: fullScreen, position: CGPoint(x: width/2, y: height/2), zPosition: 1, alpha: 1)
        let logoNode = SKSpriteNode(imageNamed: "menuArrow")
        logoNode.size = CGSize(width: 200, height: 100)
        let welcomeTo = makeLabel(text: "swipe your screen in the", name: "welcomeTo", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: 175), fontColor: .white, fontSize: 20, fontString: fontString)
        welcomeTo.alpha = 0
        let welcomeTo2 = makeLabel(text: "direction of the arrows", name: "welcomeTo", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: -20), fontColor: .white, fontSize: 20, fontString: fontString)
        
        welcomeTo.addChild(welcomeTo2)
        //welcomeTo.run(.move(to: CGPoint(x: 0, y: 175), duration: 0.5))
        //welcomeTo.run(.fadeIn(withDuration: 0.5))
        welcomeTo.run(.sequence([.wait(forDuration: 0.5),.fadeIn(withDuration: 0.5)]))
        firstSlide.addChild(logoNode)
        firstSlide.addChild(welcomeTo)
        firstSlide.run(moveColorAction2, withKey: "moveColor")
        
        addChild(firstSlide)
    }
    
    func addSecondSlide(){
        secondSlide = makeSpriteNode(color: UIColor(hexString: "#3B5998")!, name: "secondSlide", size: fullScreen, position: middlePosition, zPosition: 0.9, alpha: 1)
        let scoreLabel = makeLabel(text: "1", name: "scoreLbl2", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: 0), fontColor: .white, fontSize: 150, fontString: fontString)
        scoreLabel.alpha = 0.6
        let arrow = SKSpriteNode(imageNamed: "arrowLeft")
            arrow.alpha = 0.6
            arrow.scale(to: CGSize(width: 70, height: 35))
            arrow.position = CGPoint(x: 0, y: -width/4)
        
        secondSlide.addChild(scoreLabel)
        secondSlide.addChild(arrow)
        addChild(secondSlide)
    }
    
    func addThirdSlide(){
        thirdSlide = makeSpriteNode(color: UIColor(hexString: "#990000")!, name: "thirdSlide", size: fullScreen, position: middlePosition, zPosition: 0.8, alpha: 1)
        let scoreLabel = makeLabel(text: "2", name: "scoreLbl2", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: 0), fontColor: .white, fontSize: 150, fontString: fontString)
        scoreLabel.alpha = 0.6
        let rememberLabel = makeLabel(text: "remember which direction", name: "", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: 175), fontColor: .white, fontSize: 20, fontString: fontString)
        let rememberLabel2 = makeLabel(text: "you swipe each color...", name: "", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: -20), fontColor: .white, fontSize: 20, fontString: fontString)
        rememberLabel.addChild(rememberLabel2)
        thirdSlide.addChild(rememberLabel)
        thirdSlide.addChild(scoreLabel)
        addChild(thirdSlide)
    }
    
    func addFourthSlide(){
        fourthSlide = makeSpriteNode(color: UIColor(hexString: "#3B5998")!, name: "fourthSlide", size: fullScreen, position: middlePosition, zPosition: 0.7, alpha: 1)
        let scoreLabel = makeLabel(text: "3", name: "scoreLbl2", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: 0), fontColor: .white, fontSize: 150, fontString: fontString)
        scoreLabel.alpha = 0.6
        let rememberLabel = makeLabel(text: "...swipe the wrong direction", name: "", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: 175), fontColor: .white, fontSize: 20, fontString: fontString)
        let rememberLabel2 = makeLabel(text: "and you lose", name: "", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: -20), fontColor: .white, fontSize: 20, fontString: fontString)
        rememberLabel.addChild(rememberLabel2)
        fourthSlide.addChild(rememberLabel)
        fourthSlide.addChild(scoreLabel)
        addChild(fourthSlide)
    }
    
    func addFifthSlide(){
        fifthSlide = makeSpriteNode(color: UIColor(hexString: "#990000")!, name: "fourthSlide", size: fullScreen, position: middlePosition, zPosition: 0.6, alpha: 1)
        let logoNode = SKSpriteNode(imageNamed: "menuArrow")
        logoNode.size = CGSize(width: 200, height: 100)
        
        let timedButton = makeSpriteNode(imageNamed: "timerOff", name: "timedButton", size: CGSize(width: 50, height: 50), position: CGPoint(x: -width/2 + 45, y: height/2 - safeAreaTop/2 - 48), zPosition: 0, alpha: 1)
        let trophyButton = makeSpriteNode(imageNamed: "trophy", name: "trophyButton", size: CGSize(width: 42, height: 42), position: CGPoint(x: -width/2 + 45, y: -height/2 + safeAreaBottom/2 + 45), zPosition: 0, alpha: 1)
        
        let timedLabel = makeLabel(text: "switch between regular", name: "switch", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: 175), fontColor: .white, fontSize: 20, fontString: fontString)
        timedLabel.alpha = 0
        let timedLabel2 = makeLabel(text: "or timed mode", name: "switch", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: -20), fontColor: .white, fontSize: 20, fontString: fontString)
        timedLabel.alpha = 0
        timedLabel.addChild(timedLabel2)
        
        let trophyLabel = makeLabel(text: "view challenges", name: "trophy", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: -175), fontColor: .white, fontSize: 20, fontString: fontString)
        trophyLabel.alpha = 0
        
        let lbNode = SKNode()
        lbNode.position = CGPoint(x: width/2 - 68, y: -height/2 + safeAreaBottom/2 + 23)
        let lbThirdSquare = SKSpriteNode(color: .white, size: CGSize(width: 12, height: 15) )
               //lbThirdSquare.position = CGPoint(x: width/2 - 68, y: -height/2 + safeAreaBottom/2 + 23)
               lbThirdSquare.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        lbNode.addChild(lbThirdSquare)
               
        let lbFirstSquare = SKSpriteNode(color: .white, size: CGSize(width: 12, height: 38) )
               lbFirstSquare.anchorPoint = CGPoint(x: 0.5, y: 0.0)
               lbFirstSquare.position = CGPoint(x: 16, y: 0)
        lbNode.addChild(lbFirstSquare)
               
        let lbSecondSquare = SKSpriteNode(color: .white, size: CGSize(width: 12, height: 25) )
               lbSecondSquare.anchorPoint = CGPoint(x: 0.5, y: 0.0)
               lbSecondSquare.position = CGPoint(x: 32, y: 0)
        lbNode.addChild(lbSecondSquare)
        
        let scoreLabel = makeLabel(text: "view leaderboard", name: "scores", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: -175), fontColor: .white, fontSize: 20, fontString: fontString)
        scoreLabel.alpha = 0
        
        timedButton.run(.sequence([.wait(forDuration: 1.5),.resize(byWidth: 18, height: 18, duration: 0.5),.run {
            timedLabel.run(.sequence([.fadeIn(withDuration: 0.5),.wait(forDuration: 2),.run {
                timedButton.run(.resize(byWidth: -18, height: -18, duration: 0.5))
                timedLabel.run(.fadeOut(withDuration: 0.5))
                }]))
            }]))
        trophyButton.run(.sequence([.wait(forDuration: 5),.resize(byWidth: 18, height: 18, duration: 0.5),.run {
            trophyLabel.run(.sequence([.fadeIn(withDuration: 0.5),.wait(forDuration: 2),.run {
                trophyButton.run(.resize(byWidth: -18, height: -18, duration: 0.5))
                trophyLabel.run(.fadeOut(withDuration: 0.5))
                }]))
            }]))
        lbNode.run(.sequence([.wait(forDuration: 8),.scale(by: 1.3, duration: 0.5),.run {
            scoreLabel.run(.sequence([.fadeIn(withDuration: 0.5),.wait(forDuration: 2),.run {
                lbNode.run(.scale(by: 0.75, duration: 0.5))
                scoreLabel.run(.fadeOut(withDuration: 0.5))
                }]))
            }]))
        
        self.run(.sequence([.wait(forDuration: 12),.run {
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFit
            self.view?.presentScene(gameScene)
            }]))
        
        fifthSlide.addChild(timedLabel)
        fifthSlide.addChild(timedButton)
        fifthSlide.addChild(trophyButton)
        fifthSlide.addChild(trophyLabel)
        fifthSlide.addChild(lbNode)
        fifthSlide.addChild(scoreLabel)
        fifthSlide.addChild(logoNode)
        addChild(fifthSlide)
    }
    
    func addGestures(){
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(TutorialScene.swipedLeft(sender:)))
        swipeLeft.direction = .left
        view!.addGestureRecognizer(swipeLeft)
           
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(TutorialScene.swipedRight(sender:)))
        swipeRight.direction = .right
        view!.addGestureRecognizer(swipeRight)
    }
    
    @objc func swipedRight(sender: UISwipeGestureRecognizer) {
        print("right")
        let moveAction = SKAction.moveBy(x: width, y: 0, duration: 0.25)
        if slide == 1 {
            firstSlide.run(moveAction)
            slide = 2
        }
        if slide == 3 {
            thirdSlide.run(moveAction)
            slide = 4
        }

    }
    
    @objc func swipedLeft(sender: UISwipeGestureRecognizer) {
        print("left")
        let moveAction = SKAction.moveBy(x: -width, y: 0, duration: 0.25)
        if slide == 2 {
            secondSlide.run(moveAction)
            slide = 3
        }
        if slide == 4 {
            fourthSlide.run(moveAction)
            addFifthSlide()
            slide = 5
            swipeLeft.isEnabled = false
            swipeRight.isEnabled = false
        }

    }
    
    func addTitleAndSkipLabels(){
        let howToPlay = makeLabel(text: "Tutorial", position: CGPoint(x: width/2, y: height - safeAreaTop/2 - 48), fontString: fontString, fontColor: .white, fontSize: 20)
        howToPlay.zPosition = 5
        let skip = makeLabel(text: "skip tutorial", position: CGPoint(x: width/2, y: safeAreaBottom/2 + 33), fontString: fontString, fontColor: .white, fontSize: 20)
        //skip.alpha = 0
        skip.zPosition = 5
        skip.name = "skip"
        addChild(skip)
        //addChild(howToPlay)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "skip"{
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene)
            }
        }
        
    }
    
}
