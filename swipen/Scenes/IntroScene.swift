//
//  Intro.swift
//  swipen
//
//  Created by Colton Lipchak on 7/13/20.
//  Copyright © 2020 clipchak. All rights reserved.
//

/*
 This scene animates the arrow on the app when it launches
 */

import SpriteKit

class IntroScene: SKScene {
    
    var totalGames = Int(0)
    
    override func didMove(to view: SKView) {
        width = view.frame.width
        height = view.frame.height
        
        runAnimation()
    }
    
    func runAnimation(){
        if UserDefaults.standard.object(forKey: "totalGames") != nil {
            totalGames = UserDefaults.standard.integer(forKey: "totalGames")
        }
        
        let title = makeLabel(text: "swipe'n", name: "title", verticalAlignment: SKLabelVerticalAlignmentMode(rawValue: 0)!, position: CGPoint(x: -1, y: -3), fontColor: UIColor(hexString: "#990000")!, fontSize: 40, fontString: "DamascusMedium")
        title.zPosition = 5
        
        let whiteBG2 = makeSpriteNode(imageNamed: "menuArrow", name: "bg", size: CGSize(width: width * 3, height: height * 4), position: middlePosition, zPosition: 1, alpha: 1)
        whiteBG2.addChild(title)
        addChild(whiteBG2)
        
        let redBG = makeSpriteNode(color: UIColor(hexString: "#990000")!, name: "redbg", size: CGSize(width: width, height: height), position: middlePosition, zPosition: 0, alpha: 1)
        addChild(redBG)
        
        if totalGames > 0 {
            let menuButtons = MenuHUDNode(position: CGPoint(x: 0, y: 0))
            addChild(menuButtons)
        }
        
        let group = SKAction.group([.scale(to: 0, duration: 0.3),.run {
            whiteBG2.run(.sequence([.scale(to: CGSize(width: 200, height: 100), duration: 0.50),.run {
                if self.totalGames > 0 {
                    let menuScene = AdvancedGameScene(size: self.size)
                    menuScene.scaleMode = .aspectFit
                    self.view?.presentScene(menuScene)
                } else{
                    let menuScene = AdvancedTutorialScene(size: self.size)
                    menuScene.scaleMode = .aspectFit
                    self.view?.presentScene(menuScene)
                }
                
            }]))
        }])
        
        title.run(.sequence([.wait(forDuration: 1), .scale(to: 0.6, duration: 0.3), group]))
    }
    
}
