//
//  TestScene.swift
//  swipen
//
//  Created by Colton Lipchak on 6/19/20.
//  Copyright © 2020 clipchak. All rights reserved.
//

import Foundation
import SpriteKit

class TestScene: SKScene {
    var currentColor = ColorNode()
    var nextColor = ColorNode()
    var newSetOfColorSprites = [ColorNode]()
    
    var touchPoint = CGPoint()
    var firstTouch = CGPoint()
    var firstMovedTouch = CGPoint()
    
    var touching = false
    var movingXDirection = false
    var movingYDirection = false
    var directionPicked = false
    
    var direction = ""
    
    var xDif = CGFloat()
    var yDif = CGFloat()

    override func didMove(to view: SKView) {
        initColors()
    }

    func initColors(){
        //self.physicsBody = SKPhysicsBody.init(edgeLoopFrom: self.frame)
        print(self.frame)
        //self.physicsBody = SKPhysicsBody.init(edgeLoopFrom: CGRect(x: -100, y: -100, width: width + 100, height: height + 100))
        setColorNodesArray()
        
        newSetOfColorSprites.append(newGameNodes[0])
        newSetOfColorSprites.append(newGameNodes[1])
        
        currentColor = copyNode(node: newSetOfColorSprites[1])
        nextColor = copyNode(node: newSetOfColorSprites[0])
        nextColor.zPosition = 0
        nextColor.scoreLabel.text = "1"
        currentColor.zPosition = 1
        //currentColor.size = CGSize(width: 100, height: 200)
        currentColor.physicsBody = SKPhysicsBody.init(rectangleOf: currentColor.size)
        currentColor.physicsBody?.affectedByGravity = false
        addChild(nextColor)
        addChild(currentColor)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first?.location(in: self) {
            if !touching{
                firstTouch = touch
                xDif = currentColor.position.x - touch.x
                yDif = currentColor.position.y - touch.y

                if currentColor.frame.contains(touch) {
                    touchPoint = touch
                    touching = true
                    //print(touching)
                }
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
        
        let dx = abs(currentColor.physicsBody!.velocity.dx)
        let dy = abs(currentColor.physicsBody!.velocity.dy)
        let xPositionalDifference = abs(width/2 - currentColor.position.x)
        let yPositionalDifference = abs(height/2 - currentColor.position.y)

        print("velocity: \(currentColor.physicsBody!.velocity)")
        print("midpoint position: \(currentColor.position)")
        print("x positional difference: \(width/2 - currentColor.position.x)")
        print("y positional difference: \(height/2 - currentColor.position.y)")
        

        if direction == currentColor.swipeDirection && (xPositionalDifference >= 150 || yPositionalDifference >= 180 || dx > 500 || dy > 500 ){
            
        } else{
            currentColor.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            currentColor.run(.move(to: CGPoint(x: width/2, y: height/2), duration: 0.5))
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
            
            if movingYDirection {
                dx = 0
            }
            
            if movingXDirection{
                dy = 0
            }

            var distance = CGVector(dx: dx, dy: dy)
            //print("dx: \(distance.dx/dt)")
            //print("dx: \(dx)")

            switch direction {
            case "left":
                if distance.dx/dt > 0 && currentColor.position.x >= width/2 {
                    dx = 0
                }
            case "right":
                if distance.dx/dt < 0 && currentColor.position.x <= width/2{
                    dx = 0
                }
            case "down":
                if distance.dy/dt > 0 && currentColor.position.y >= height/2{
                    dy = 0
                }
            case "up":
                if distance.dy/dt < 0 && currentColor.position.y <= height/2{
                    dy = 0
                }
            default:
                print("error")
            }
            distance = CGVector(dx: dx, dy: dy)
            
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            currentColor.physicsBody!.velocity = velocity
            //print(direction)
        }
    }
}


//  let distance = CGVector(dx: touchPoint.x-currentColor.position.x, dy: touchPoint.y-currentColor.position.y)

