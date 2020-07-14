//
//  Settings.swift
//  swipe'n
//
//  Created by Colton Lipchak on 12/17/19.
//  Copyright © 2019 clipchak. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import GameKit

// Offset each node with a slight delay
let delayAction = SKAction.wait(forDuration: 1)

// Move color right then back to left
let moveLogoRightAction = SKAction.moveBy(x: 17, y: 0, duration: 0.4)
let moveLogoLeftAction = SKAction.moveBy(x: -17, y: 0, duration: 0.4)
       
// Wait for seconds before repeating the action
let logoWaitAction = SKAction.wait(forDuration: 4)
let logoWaitAction2 = SKAction.wait(forDuration: 6)

// Form a sequence with the actions, as well as the wait action
let moveColorActionSequence = SKAction.sequence([delayAction, moveLogoRightAction, moveLogoLeftAction,logoWaitAction])
let moveColorActionSequence2 = SKAction.sequence([delayAction,delayAction,delayAction, moveLogoRightAction, moveLogoLeftAction])

// Form a repeat action with the sequence
let moveColorAction = SKAction.repeatForever(moveColorActionSequence)
let moveColorAction2 = SKAction.repeatForever(moveColorActionSequence2)

// Scale up and then back down
let resizeUpAction = SKAction.resize(byWidth: 8.0, height: 8.0, duration: 0.3)
let resizeDownAction = SKAction.resize(byWidth: -8.0, height: -8.0, duration: 0.3)

// Wait for 2 seconds before repeating the action
let waitAction2 = SKAction.wait(forDuration: 6)

// Form a sequence with the scale actions, as well as the wait action
let scaleTrophySequence = SKAction.sequence([resizeUpAction, resizeDownAction, waitAction2])

// Form a repeat action with the sequence
let repeatTrophyAction = SKAction.repeatForever(scaleTrophySequence)

// Combine the delay and the repeat actions into another sequence
let trophyActionSequence = SKAction.sequence([delayAction, repeatTrophyAction])



//blue04 looks purple
//green03 kind of blue
//orange2 / red4 look same
/*
 ugly colors:
 
 
 */


/*

func setColorNodesArray(){
    newGameNodes.removeAll()
    
    blueColorNodes =   [ColorNode(color: UIColor(hexString: "#003366")!, colorClass: "blue", name: "blue01"),
                            ColorNode(color: UIColor(hexString: "#002CF0")!, colorClass: "blue", name: "blue02"),
                            ColorNode(color: UIColor(hexString: "#000080")!, colorClass: "blue", name: "blue03"),
                            ColorNode(color: UIColor(hexString: "#92A8D1")!, colorClass: "blue", name: "blue04"),
                            ColorNode(color: UIColor(hexString: "#45B8AC")!, colorClass: "blue", name: "blue05"),
                            ColorNode(color: UIColor(hexString: "#55B4B0")!, colorClass: "blue", name: "blue06"),
                            ColorNode(color: UIColor(hexString: "#063E42")!, colorClass: "blue", name: "blue07"),
                            ColorNode(color: UIColor(hexString: "#009999")!, colorClass: "blue", name: "blue08"),
                            ColorNode(color: UIColor(hexString: "#2C9C91")!, colorClass: "blue", name: "blue09"),
                            ColorNode(color: UIColor(hexString: "#00CCCC")!, colorClass: "blue", name: "blue10"),
                            ColorNode(color: UIColor(hexString: "#3B5998")!, colorClass: "blue", name: "blue11")
    ]
    pinkColorNodes =   [ColorNode(color: UIColor(hexString: "#794044")!, colorClass: "purple", name: "purple05"),
                            ColorNode(color: UIColor(hexString: "#E0B2C9")!, colorClass: "purple", name: "purple06")
    ]
    purpleColorNodes = [ColorNode(color: UIColor(hexString: "#6B5B95")!, colorClass: "purple", name: "purple01"),
                            ColorNode(color: UIColor(hexString: "#5B5EA6")!, colorClass: "purple", name: "purple02"),
                            ColorNode(color: UIColor(hexString: "#42063E")!, colorClass: "purple", name: "purple03"),
                            ColorNode(color: UIColor(hexString: "#261B47")!, colorClass: "purple", name: "purple04"),
                            ColorNode(color: UIColor(hexString: "#794044")!, colorClass: "purple", name: "purple05"),
                            ColorNode(color: UIColor(hexString: "#E0B2C9")!, colorClass: "purple", name: "purple06")
    ]
    greenColorNodes =  [ColorNode(color: UIColor(hexString: "#203C24")!, colorClass: "green", name: "green01"),
                            ColorNode(color: UIColor(hexString: "#006400")!, colorClass: "green", name: "green02"),
                            ColorNode(color: UIColor(hexString: "#009B77")!, colorClass: "green", name: "green03"),
                            ColorNode(color: UIColor(hexString: "#3E4206")!, colorClass: "green", name: "green04"),
                            ColorNode(color: UIColor(hexString: "#00994D")!, colorClass: "green", name: "green05"),
                            ColorNode(color: UIColor(hexString: "#009900")!, colorClass: "green", name: "green06"),
                            ColorNode(color: UIColor(hexString: "#2A623D")!, colorClass: "green", name: "green07"),
                            ColorNode(color: UIColor(hexString: "#78866B")!, colorClass: "green", name: "green08")

    ]
    redColorNodes =    [ColorNode(color: UIColor(hexString: "#420620")!, colorClass: "red", name: "red01"),
                        ColorNode(color: UIColor(hexString: "#990000")!, colorClass: "red", name: "red02"),
                        ColorNode(color: UIColor(hexString: "#5B0000")!, colorClass: "red", name: "red03"),
                        ColorNode(color: UIColor(hexString: "#D11141")!, colorClass: "red", name: "red04")

    ]
    brownColorNodes =  [ColorNode(color: UIColor(hexString: "#C29979")!, colorClass: "brown", name: "brown01"),
                            ColorNode(color: UIColor(hexString: "#994D00")!, colorClass: "brown", name: "brown02"),
                            ColorNode(color: UIColor(hexString: "#47261B")!, colorClass: "brown", name: "brown03")
    ]
    orangeColorNodes = [ColorNode(color: UIColor(hexString: "#FF8258")!, colorClass: "orange", name: "orange01"),
                            ColorNode(color: UIColor(hexString: "#FF490C")!, colorClass: "orange", name: "orange02"),
                            ColorNode(color: UIColor(hexString: "#FF6D3C")!, colorClass: "orange", name: "orange03"),
                            ColorNode(color: UIColor(hexString: "#994D00")!, colorClass: "orange", name: "orange04"),
                            ColorNode(color: UIColor(hexString: "#47261B")!, colorClass: "orange", name: "orange05"),
                            ColorNode(color: UIColor(hexString: "#F37735")!, colorClass: "orange", name: "orange06"),
                            ColorNode(color: UIColor(hexString: "#C99789")!, colorClass: "orange", name: "orange07")

    ]
    yellowColorNodes =  [ColorNode(color: UIColor(hexString: "#FFC425")!, colorClass: "yellow", name: "yellow01"),
                         ColorNode(color: UIColor(hexString: "#D3A625")!, colorClass: "yellow", name: "yellow02")
    ]
    
    var allColorNodes = [blueColorNodes,purpleColorNodes,yellowColorNodes,greenColorNodes,redColorNodes,orangeColorNodes]
    newMenuColor.swipeDirection = "right"
    let arrow = SKSpriteNode(imageNamed: "arrowRight")
        arrow.alpha = 0.6
        arrow.scale(to: CGSize(width: 70, height: 35))
        arrow.position = CGPoint(x: 0, y: -width/4)
    newMenuColor.arrow = arrow
    newMenuColor.addChild(arrow)
    newGameNodes.append(newMenuColor)
    
    var index = 0
    for i in 0 ..< allColorNodes.count{
        if allColorNodes[i] == checkClassOfColor(colorClass: newMenuColor.colorClass){
            index = i
        }
    }
    allColorNodes.remove(at: index)
    allColorNodes.shuffle()
    
    var swipeDirection = 1
    var allColorNodesIndex = 0
    for i in 0 ..< allColorNodes.joined().count{
        var colorArray = allColorNodes[allColorNodesIndex]
        allColorNodesIndex += 1
        if allColorNodesIndex >= allColorNodes.count {
            allColorNodesIndex = 0
        }
        let randomIndex = Int.random(in: 0 ..< colorArray.count)
        let color = colorArray[randomIndex]
        
        switch swipeDirection {
        case 0:
            color.swipeDirection = "right"
            let arrow = SKSpriteNode(imageNamed: "arrowRight")
                arrow.alpha = 0.6
                arrow.scale(to: CGSize(width: 70, height: 35))
                arrow.position = CGPoint(x: 0, y: -width/4)
            color.arrow = arrow
            color.addChild(arrow)
        case 1:
            color.swipeDirection = "left"
            let arrow = SKSpriteNode(imageNamed: "arrowLeft")
                arrow.alpha = 0.6
                arrow.scale(to: CGSize(width: 70, height: 35))
                arrow.position = CGPoint(x: 0, y: -width/4)
            color.arrow = arrow
            color.addChild(arrow)
        case 2:
            color.swipeDirection = "up"
            let arrow = SKSpriteNode(imageNamed: "arrowUp")
                arrow.alpha = 0.6
                arrow.scale(to: CGSize(width: 35, height: 70))
                arrow.position = CGPoint(x: 0, y: -width/4)
            color.arrow = arrow
            color.addChild(arrow)
        case 3:
            color.swipeDirection = "down"
            let arrow = SKSpriteNode(imageNamed: "arrowDown")
                arrow.alpha = 0.6
                arrow.scale(to: CGSize(width: 35, height: 70))
                arrow.position = CGPoint(x: 0, y: -width/4)
            color.arrow = arrow
            color.addChild(arrow)
        default:
            print("error")
        }
        
        newGameNodes.append(color)
        colorArray.remove(at: randomIndex)

        swipeDirection += 1
        if swipeDirection == 4 {
            swipeDirection = 0
        }
    }

}

*/
