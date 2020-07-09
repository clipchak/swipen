//
//  LoseMenuNode.swift
//  swipen
//
//  Created by Colton Lipchak on 7/8/20.
//  Copyright © 2020 clipchak. All rights reserved.
//

import SpriteKit

class LoseMenuNode: SKNode{

    override init() {
           super.init()
    }

    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }

    init(position: CGPoint) {
        
        super.init()
        self.position = position
        self.alpha = 0.0
        self.zPosition = 5
        
        let shareScoreButton = makeLabel(text: "share", name: "shareScore", verticalAlignment: menuAlignment, position: CGPoint(x: -15, y: height/2 + 40), fontColor: .white, fontSize: 18, fontString: fontString)
        let rateAppButton = makeLabel(text: "rate", name: "rateAppButton", verticalAlignment: menuAlignment, position: CGPoint(x: -100, y: height/2 - 16), fontColor: .white, fontSize: 40, fontString: fontString)
        let quitButton = makeLabel(text: "quit", name: "quitButton", verticalAlignment: menuAlignment, position: CGPoint(x: 70, y: height/2 - 15), fontColor: .white, fontSize: 40, fontString: fontString)

        self.addChild(shareScoreButton)
        self.addChild(rateAppButton)
        self.addChild(quitButton)
        
    }
    
    
}
