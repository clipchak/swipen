//
//  ColorNode.swift
//  color.swipe
//
//  Created by Colton Lipchak on 5/2/20.
//  Copyright © 2020 clipchak. All rights reserved.
//

import SpriteKit

class TrophyLabelNode: SKLabelNode{
    var check = SKSpriteNode()
    
    override init(fontNamed fontName: String?) {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String, position: CGPoint) {
        super.init()
        
        self.text = text
        self.fontSize = 22
        self.fontName = "Damascus"
        self.fontColor = .white
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode(rawValue: 1)!
        self.position = position
        
        
        let node = SKSpriteNode(imageNamed: "ex")
        node.size = CGSize(width: 13, height: 13)
        node.position = CGPoint(x: -10, y: 7)
        self.check = node
        self.addChild(check)
    }
    
}
