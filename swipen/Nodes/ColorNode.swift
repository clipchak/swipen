//
//  ColorNode.swift
//  color.swipe
//
//  Created by Colton Lipchak on 5/2/20.
//  Copyright © 2020 clipchak. All rights reserved.
//

import SpriteKit

class ColorNode: SKSpriteNode{
    var colorClass = String()
    var swipeDirection = String()
    var arrow = SKSpriteNode()
    var timer = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var didAppear = false
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        let colorSize = CGSize(width: width + 13, height: height + 13)
        super.init(texture: texture, color: color, size: colorSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //color class: the type of hierarchy/shade the color belongs to (blue, red, etc)
    //swipeDirection: the direction this color is swiped
    init(color: UIColor, colorClass: String, name: String ) {
        let colorSize = CGSize(width: width + 13, height: height + 13)
        let colorPos = CGPoint(x: width/2, y: height/2)
        super.init(texture: nil,color: color, size:colorSize)
        self.position = colorPos
        self.colorClass = colorClass
        self.name = name
        
        let score = SKLabelNode(text: "0")
        score.verticalAlignmentMode = SKLabelVerticalAlignmentMode(rawValue: 1)!
        score.fontSize = 150
        score.fontName = "Damascus"
        score.alpha = 0.6
        
        self.scoreLabel = score
        self.addChild(score)
    }
    
    func moveRight(){
        self.run(.sequence([.moveBy(x: width, y: 0, duration: 0.3), .run {
            //self.position = CGPoint(x: width/2, y: height/2)
            //self.removeFromParent()
            }]))
    }
    
    func moveLeft(){
        self.run(.sequence([.moveBy(x: -width, y: 0, duration: 0.3), .run {
            //self.position = CGPoint(x: width/2, y: height/2)
            //self.removeFromParent()
            }]))
    }
    
    func moveUp(){
        self.run(.sequence([.moveBy(x: 0, y: height, duration: 0.3), .run {
            //self.removeFromParent()
            }]))
    }
    
    func moveDown(){
        self.run(.sequence([.moveBy(x: 0, y: -height, duration: 0.3), .run {
            //self.removeFromParent()
            }]))
    }
    
}
