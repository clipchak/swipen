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

class AdvancedTutorialScene: SKScene {
    var slide = Int(1)
    
    var currentColor = SKSpriteNode()
    var firstSlide = SKSpriteNode()
    var secondSlide = SKSpriteNode()
    var thirdSlide = SKSpriteNode()
    var fourthSlide = SKSpriteNode()
    var fifthSlide = SKSpriteNode()
    var timedButton = SKSpriteNode()
    var trophyButton = SKSpriteNode()
    var lbNode = SKNode()
    var timedLabel = SKLabelNode()
    var trophyLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    
    var touchPoint = CGPoint()
    var firstTouch = CGPoint()
    var firstMovedTouch = CGPoint()
    
    var touching = false
    var movingXDirection = false
    var movingYDirection = false
    var directionPicked = false
    var transitioning = false
    
    var direction = ""
    
    var xDif = CGFloat()
    var yDif = CGFloat()
    
    
    override func didMove(to view: SKView) {
        menuScenePresented = true
        addTitleAndSkipLabels()
       // addGestures()
        addFirstSlide()
        addSecondSlide()
        addThirdSlide()
        addFourthSlide()
        addFifthSlide()
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
        //firstSlide.run(moveColorAction2, withKey: "moveColor")
        //currentColor = firstSlide
        firstSlide.physicsBody = SKPhysicsBody.init(rectangleOf: firstSlide.size)
        firstSlide.physicsBody?.affectedByGravity = false
        //addChild(currentColor)
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
        
        timedButton = makeSpriteNode(imageNamed: "timerOff", name: "timedButton", size: CGSize(width: 50, height: 50), position: CGPoint(x: -width/2 + 45, y: height/2 - safeAreaTop/2 - 48), zPosition: 0, alpha: 1)
        trophyButton = makeSpriteNode(imageNamed: "trophy", name: "trophyButton", size: CGSize(width: 42, height: 42), position: CGPoint(x: -width/2 + 45, y: -height/2 + safeAreaBottom/2 + 45), zPosition: 0, alpha: 1)
        
        timedLabel = makeLabel(text: "switch between regular", name: "switch", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: 175), fontColor: .white, fontSize: 20, fontString: fontString)
        timedLabel.alpha = 0
        let timedLabel2 = makeLabel(text: "or timed mode", name: "switch", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: -20), fontColor: .white, fontSize: 20, fontString: fontString)
        timedLabel.alpha = 0
        timedLabel.addChild(timedLabel2)
        
        trophyLabel = makeLabel(text: "view challenges", name: "trophy", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: -175), fontColor: .white, fontSize: 20, fontString: fontString)
        trophyLabel.alpha = 0
        
        lbNode = SKNode()
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
        
        scoreLabel = makeLabel(text: "view leaderboard", name: "scores", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 1)!, position: CGPoint(x: 0, y: -175), fontColor: .white, fontSize: 20, fontString: fontString)
        scoreLabel.alpha = 0
        
        
        fifthSlide.addChild(timedLabel)
        fifthSlide.addChild(timedButton)
        fifthSlide.addChild(trophyButton)
        fifthSlide.addChild(trophyLabel)
        fifthSlide.addChild(lbNode)
        fifthSlide.addChild(scoreLabel)
        fifthSlide.addChild(logoNode)
        addChild(fifthSlide)
    }
    
    func animateFifthSlide(){
        timedButton.run(.sequence([.wait(forDuration: 1.5),.resize(byWidth: 18, height: 18, duration: 0.5),.run {
            self.timedLabel.run(.sequence([.fadeIn(withDuration: 0.5),.wait(forDuration: 2),.run {
                self.timedButton.run(.resize(byWidth: -18, height: -18, duration: 0.5))
                self.timedLabel.run(.fadeOut(withDuration: 0.5))
                }]))
            }]))
        trophyButton.run(.sequence([.wait(forDuration: 5),.resize(byWidth: 18, height: 18, duration: 0.5),.run {
            self.trophyLabel.run(.sequence([.fadeIn(withDuration: 0.5),.wait(forDuration: 2),.run {
                self.trophyButton.run(.resize(byWidth: -18, height: -18, duration: 0.5))
                self.trophyLabel.run(.fadeOut(withDuration: 0.5))
                }]))
            }]))
        lbNode.run(.sequence([.wait(forDuration: 8),.scale(by: 1.3, duration: 0.5),.run {
            self.scoreLabel.run(.sequence([.fadeIn(withDuration: 0.5),.wait(forDuration: 2),.run {
                self.lbNode.run(.scale(by: 0.75, duration: 0.5))
                self.scoreLabel.run(.fadeOut(withDuration: 0.5))
                }]))
            }]))
        
        self.run(.sequence([.wait(forDuration: 12),.run {
            let gameScene = AdvancedGameScene(size: self.size)
            gameScene.scaleMode = .aspectFit
            self.view?.presentScene(gameScene)
            }]))
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
        if let touch = touches.first?.location(in: self) {
            let nodesArray = self.nodes(at: touch)
            if nodesArray.first?.name == "skip"{
                let gameScene = AdvancedGameScene(size: self.size)
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene)
            }
            
            if !touching{
                firstTouch = touch
                xDif = currentColor.position.x - touch.x
                yDif = currentColor.position.y - touch.y
                
                switch slide {
                    case 1:
                        xDif = firstSlide.position.x - touch.x
                        yDif = firstSlide.position.y - touch.y
                    case 2:
                        xDif = secondSlide.position.x - touch.x
                        yDif = secondSlide.position.y - touch.y
                    case 3:
                        xDif = thirdSlide.position.x - touch.x
                        yDif = thirdSlide.position.y - touch.y
                    case 4:
                        xDif = fourthSlide.position.x - touch.x
                        yDif = fourthSlide.position.y - touch.y
                    case 5:
                        xDif = fifthSlide.position.x - touch.x
                        yDif = fifthSlide.position.y - touch.y
                    default:
                        print("error")
                }

                //if currentColor.frame.contains(touch) {
                    touchPoint = touch
                    touching = true
                //}
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            touchPoint = location

            let xAbs = abs(touchPoint.x - firstTouch.x)
            let yAbs = abs(touchPoint.y - firstTouch.y)
            //print("xAbs: \(xAbs) yAbs: \(yAbs)")

            if xAbs > 6.5 && !directionPicked {
                directionPicked = true
                movingXDirection = true
                if (touchPoint.x - firstTouch.x) > 0 {
                    direction = "right"
                } else{
                    direction = "left"
                }
            }
            
            if yAbs > 6.5 && !directionPicked {
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
        
        var dx = CGFloat(0)
        var dy = CGFloat(0)
        var xPositionalDifference = CGFloat(0)
        var yPositionalDifference = CGFloat(0)

        if !transitioning {
            switch slide {
                case 1:
                    dx = abs(firstSlide.physicsBody!.velocity.dx)
                    dy = abs(firstSlide.physicsBody!.velocity.dy)
                    xPositionalDifference = abs(width/2 - firstSlide.position.x)
                    yPositionalDifference = abs(height/2 - firstSlide.position.y)
                case 2:
                    dx = abs(secondSlide.physicsBody!.velocity.dx)
                    dy = abs(secondSlide.physicsBody!.velocity.dy)
                    xPositionalDifference = abs(width/2 - secondSlide.position.x)
                    yPositionalDifference = abs(height/2 - secondSlide.position.y)
                case 3:
                    dx = abs(thirdSlide.physicsBody!.velocity.dx)
                    dy = abs(thirdSlide.physicsBody!.velocity.dy)
                    xPositionalDifference = abs(width/2 - thirdSlide.position.x)
                    yPositionalDifference = abs(height/2 - thirdSlide.position.y)
                case 4:
                    dx = abs(fourthSlide.physicsBody!.velocity.dx)
                    dy = abs(fourthSlide.physicsBody!.velocity.dy)
                    xPositionalDifference = abs(width/2 - fourthSlide.position.x)
                    yPositionalDifference = abs(height/2 - fourthSlide.position.y)
                case 5:
                    dx = abs(fifthSlide.physicsBody!.velocity.dx)
                    dy = abs(fifthSlide.physicsBody!.velocity.dy)
                    xPositionalDifference = abs(width/2 - fifthSlide.position.x)
                    yPositionalDifference = abs(height/2 - fifthSlide.position.y)
                default:
                    print("error")
            }
        }
        
        if (slide == 1 && direction == "right") && (xPositionalDifference >= 150 || yPositionalDifference >= 180 || dx > 500 || dy > 500) {
            transitioning = true

            firstSlide.run(.sequence([.move(by: CGVector(dx: 200, dy: 0), duration: 0.5), .run {
                self.firstSlide.removeFromParent()
                self.secondSlide.physicsBody = SKPhysicsBody.init(rectangleOf: self.secondSlide.size)
                self.secondSlide.physicsBody?.affectedByGravity = false
                self.transitioning = false

                }]))
            
            slide = 2
        } else{
            firstSlide.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            firstSlide.run(.move(to: CGPoint(x: width/2, y: height/2), duration: 0.5))
        }
        
        if (slide == 2 && direction == "left") && (xPositionalDifference >= 150 || yPositionalDifference >= 180 || dx > 500 || dy > 500) {
            transitioning = true
            secondSlide.run(.sequence([.move(by: CGVector(dx: -200, dy: 0), duration: 0.5), .run {
                self.secondSlide.removeFromParent()
                self.thirdSlide.physicsBody = SKPhysicsBody.init(rectangleOf: self.thirdSlide.size)
                self.thirdSlide.physicsBody?.affectedByGravity = false
                self.transitioning = false
                }]))
            
            slide = 3
        } else{
            secondSlide.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            secondSlide.run(.move(to: CGPoint(x: width/2, y: height/2), duration: 0.5))
        }
        
        if (slide == 3 && direction == "right") && (xPositionalDifference >= 150 || yPositionalDifference >= 180 || dx > 500 || dy > 500) {
            transitioning = true

            thirdSlide.run(.sequence([.move(by: CGVector(dx: 200, dy: 0), duration: 0.5), .run {
                self.thirdSlide.removeFromParent()
                self.fourthSlide.physicsBody = SKPhysicsBody.init(rectangleOf: self.fourthSlide.size)
                self.fourthSlide.physicsBody?.affectedByGravity = false
                self.transitioning = false

                }]))

            slide = 4
        } else{
            thirdSlide.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            thirdSlide.run(.move(to: CGPoint(x: width/2, y: height/2), duration: 0.5))
        }
        
        if (slide == 4 && direction == "left") && (xPositionalDifference >= 150 || yPositionalDifference >= 180 || dx > 500 || dy > 500) {
            transitioning = true

            fourthSlide.run(.sequence([.move(by: CGVector(dx: -200, dy: 0), duration: 0.5), .run {
                self.fourthSlide.removeFromParent()
                self.animateFifthSlide()
                self.fifthSlide.physicsBody = SKPhysicsBody.init(rectangleOf: self.fifthSlide.size)
                self.fifthSlide.physicsBody?.affectedByGravity = false
                self.transitioning = false

                }]))

            slide = 5
        } else{
            fourthSlide.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            fourthSlide.run(.move(to: CGPoint(x: width/2, y: height/2), duration: 0.5))
        }
        
        if slide == 5 {
            fifthSlide.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            fifthSlide.run(.move(to: CGPoint(x: width/2, y: height/2), duration: 0.5))
        }
        
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false
    }

    override func update(_ currentTime: TimeInterval) {
        if touching {
            let dt:CGFloat = 1.0/60.0
            var dx = touchPoint.x - currentColor.position.x + xDif
            var dy = touchPoint.y - currentColor.position.y + yDif
            var xPos = currentColor.position.x
            var yPos = currentColor.position.y
            
            switch slide {
                case 1:
                    dx = touchPoint.x - firstSlide.position.x + xDif
                    dy = touchPoint.y - firstSlide.position.y + yDif
                    xPos = firstSlide.position.x
                    yPos = firstSlide.position.y
                case 2:
                    dx = touchPoint.x - secondSlide.position.x + xDif
                    dy = touchPoint.y - secondSlide.position.y + yDif
                    xPos = secondSlide.position.x
                    yPos = secondSlide.position.y
                case 3:
                    dx = touchPoint.x - thirdSlide.position.x + xDif
                    dy = touchPoint.y - thirdSlide.position.y + yDif
                    xPos = thirdSlide.position.x
                    yPos = thirdSlide.position.y
                case 4:
                    dx = touchPoint.x - fourthSlide.position.x + xDif
                    dy = touchPoint.y - fourthSlide.position.y + yDif
                    xPos = fourthSlide.position.x
                    yPos = fourthSlide.position.y
                case 5:
                    dx = touchPoint.x - fifthSlide.position.x + xDif
                    dy = touchPoint.y - fifthSlide.position.y + yDif
                    xPos = fifthSlide.position.x
                    yPos = fifthSlide.position.y
                default:
                    print("error")
            }
            
            if movingYDirection {
                dx = 0
            }
            
            if movingXDirection{
                dy = 0
            }

            var distance = CGVector(dx: dx, dy: dy)

            switch direction {
            case "left":
                if distance.dx/dt > 0 && xPos >= width/2 {
                    dx = 0
                }
            case "right":
                if distance.dx/dt < 0 && xPos <= width/2{
                    dx = 0
                }
            case "down":
                if distance.dy/dt > 0 && yPos >= height/2{
                    dy = 0
                }
            case "up":
                if distance.dy/dt < 0 && yPos <= height/2{
                    dy = 0
                }
            default:
                print("error")
            }
            distance = CGVector(dx: dx, dy: dy)
            
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            //currentColor.physicsBody!.velocity = velocity
            if !transitioning && directionPicked {
                switch slide {
                    case 1:
                        firstSlide.physicsBody!.velocity = velocity
                    case 2:
                        secondSlide.physicsBody!.velocity = velocity
                    case 3:
                        thirdSlide.physicsBody!.velocity = velocity
                    case 4:
                        fourthSlide.physicsBody!.velocity = velocity
                    case 5:
                        fifthSlide.physicsBody!.velocity = velocity

                    default:
                        print("error")
                }
            }
            
        }
    }
    
}
