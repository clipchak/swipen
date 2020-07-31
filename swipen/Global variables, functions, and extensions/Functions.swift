//
//  Functions.swift
//  swipen
//
//  Created by Colton Lipchak on 7/13/20.
//  Copyright © 2020 clipchak. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit

func saveHighscore(gameScore: Int, boardId: String){
    //let boardId = "swipenRegularScore"
    if GKLocalPlayer.local.isAuthenticated{
        print("\n Success! Sending highscore of \(gameScore) to leaderboard")
        
        let leaderboard_id = boardId
        let scoreReporter = GKScore(leaderboardIdentifier: leaderboard_id)
        
        scoreReporter.value = Int64(gameScore)
        let scoreArray: [GKScore] = [scoreReporter]
        
        GKScore.report(scoreArray, withCompletionHandler: {Error -> Void in
            if Error != nil {
                print("an error has occurred sending to gamecenter")
                //print("\n \(Error) \n")
            }
        })
    }
}

func setColorNodesArray(){
    newGameNodes.removeAll()
    
    blueColorNodes =   [ColorNode(color: UIColor(hexString: "#003366")!, colorClass: "blue", name: "blue01"),
                            ColorNode(color: UIColor(hexString: "#002CF0")!, colorClass: "blue", name: "blue02"),
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
                            ColorNode(color: UIColor(hexString: "#F37735")!, colorClass: "orange", name: "orange06")

    ]
    yellowColorNodes =  [ColorNode(color: UIColor(hexString: "#FFC425")!, colorClass: "yellow", name: "yellow01"),
                         ColorNode(color: UIColor(hexString: "#D3A625")!, colorClass: "yellow", name: "yellow02")
    ]
    blackColorNodes =  [ColorNode(color: UIColor(hexString: "#191919")!,colorClass: "black", name: "black01")]
    
    var allColorNodes = [blueColorNodes,purpleColorNodes,yellowColorNodes,greenColorNodes,redColorNodes,orangeColorNodes,blackColorNodes]
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
    var loopTwice = false
    var i = 0
    while i < allColorNodes.count {
        var colorArray = allColorNodes[i]
        let randomIndex = Int.random(in: 0 ..< colorArray.count)
        let color = colorArray[randomIndex]
        colorArray.remove(at: randomIndex)
        
        if !loopTwice && i == allColorNodes.count - 1{
            i = 0
            loopTwice = true
        }
        
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
        swipeDirection += 1
        if swipeDirection == 4 {
            swipeDirection = 0
        }
        
        i += 1
    }

}

func checkClassOfColor(colorClass: String) -> [ColorNode]{
    let returnArr = [ColorNode]()
    switch colorClass {
    case "blue":
        return blueColorNodes
    case "pink":
        return pinkColorNodes
    case "purple":
        return purpleColorNodes
    case "green":
        return greenColorNodes
    case "red":
        return redColorNodes
    case "brown":
        return brownColorNodes
    case "orange":
        return orangeColorNodes
    case "yellow":
        return yellowColorNodes
    case "black":
        return blackColorNodes
        
    default:
        return returnArr
    }
    
}

func makeSpriteNode(imageNamed: String, name: String, size: CGSize, position: CGPoint, zPosition: CGFloat, alpha: CGFloat) -> SKSpriteNode{
    let spriteNode = SKSpriteNode(imageNamed: imageNamed)
    spriteNode.size = size
    spriteNode.position = position
    spriteNode.zPosition = zPosition
    spriteNode.alpha = alpha
    spriteNode.name = name
    return spriteNode
}

func makeSpriteNode(color: UIColor, name: String, size: CGSize, position: CGPoint, zPosition: CGFloat, alpha: CGFloat) -> SKSpriteNode{
    let spriteNode = SKSpriteNode(color: color, size: size)
    spriteNode.size = size
    spriteNode.position = position
    spriteNode.zPosition = zPosition
    spriteNode.alpha = alpha
    spriteNode.name = name
    return spriteNode
}

func makeLabel(text: String, name: String, verticalAlignment: SKLabelVerticalAlignmentMode, position: CGPoint, fontColor: UIColor,fontSize: CGFloat, fontString: String) -> SKLabelNode{
    let label = SKLabelNode(text: text)
    label.name = name
    label.verticalAlignmentMode = verticalAlignment
    label.position = position
    label.fontColor = fontColor
    label.fontSize = fontSize
    label.fontName = fontString
    return label
}

func makeLabel(text: String, position: CGPoint, fontString: String, fontColor: UIColor, fontSize: CGFloat) -> SKLabelNode{
    let label = SKLabelNode(text: text)
    label.position = position
    label.fontColor = fontColor
    label.fontSize = fontSize
    label.fontName = fontString
    return label
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

func copyNode(node: ColorNode) -> ColorNode{
    let returnNode = ColorNode(color: node.color, colorClass: node.colorClass, name: node.name!)
    returnNode.arrow = node.arrow
    returnNode.swipeDirection = node.swipeDirection
    returnNode.didAppear = node.didAppear
       
    if node.swipeDirection == "right" {
        let arrow = SKSpriteNode(imageNamed: "arrowRight")
        arrow.alpha = 0.6
        arrow.scale(to: CGSize(width: 70, height: 35))
        arrow.position = CGPoint(x: 0, y: -width/4)
        returnNode.arrow = arrow
        if !node.didAppear {
            returnNode.addChild(arrow)
        }
    }
    if node.swipeDirection == "left" {
        let arrow = SKSpriteNode(imageNamed: "arrowLeft")
            arrow.alpha = 0.6
            arrow.scale(to: CGSize(width: 70, height: 35))
            arrow.position = CGPoint(x: 0, y: -width/4)
        returnNode.arrow = arrow
        if !node.didAppear {
            returnNode.addChild(arrow)
        }
    }
    if node.swipeDirection == "up" {
        let arrow = SKSpriteNode(imageNamed: "arrowUp")
            arrow.alpha = 0.6
            arrow.scale(to: CGSize(width: 35, height: 70))
            arrow.position = CGPoint(x: 0, y: -width/4)
        returnNode.arrow = arrow
        if !node.didAppear {
            returnNode.addChild(arrow)
        }
    }
    if node.swipeDirection == "down" {
        let arrow = SKSpriteNode(imageNamed: "arrowDown")
            arrow.alpha = 0.6
            arrow.scale(to: CGSize(width: 35, height: 70))
            arrow.position = CGPoint(x: 0, y: -width/4)
        returnNode.arrow = arrow
        if !node.didAppear {
            returnNode.addChild(arrow)
        }
    }
    return returnNode
}

func advancedCopyNode(node: ColorNode, isNextNode: Bool, score: Int) -> ColorNode{
    let returnNode = ColorNode(color: node.color, colorClass: node.colorClass, name: node.name!)
    returnNode.arrow = node.arrow
    returnNode.swipeDirection = node.swipeDirection
    returnNode.didAppear = node.didAppear
    
    if isNextNode {
        returnNode.scoreLabel.text = "\(score + 1)"
    }
    
    if !isNextNode {
        returnNode.physicsBody = SKPhysicsBody.init(rectangleOf: returnNode.size)
        returnNode.physicsBody?.affectedByGravity = false
    }
    
       
    if node.swipeDirection == "right" {
        let arrow = SKSpriteNode(imageNamed: "arrowRight")
        arrow.alpha = 0.6
        arrow.scale(to: CGSize(width: 70, height: 35))
        arrow.position = CGPoint(x: 0, y: -width/4)
        returnNode.arrow = arrow
        if !node.didAppear {
            returnNode.addChild(arrow)
        }
    }
    if node.swipeDirection == "left" {
        let arrow = SKSpriteNode(imageNamed: "arrowLeft")
            arrow.alpha = 0.6
            arrow.scale(to: CGSize(width: 70, height: 35))
            arrow.position = CGPoint(x: 0, y: -width/4)
        returnNode.arrow = arrow
        if !node.didAppear {
            returnNode.addChild(arrow)
        }
    }
    if node.swipeDirection == "up" {
        let arrow = SKSpriteNode(imageNamed: "arrowUp")
            arrow.alpha = 0.6
            arrow.scale(to: CGSize(width: 35, height: 70))
            arrow.position = CGPoint(x: 0, y: -width/4)
        returnNode.arrow = arrow
        if !node.didAppear {
            returnNode.addChild(arrow)
        }
    }
    if node.swipeDirection == "down" {
        let arrow = SKSpriteNode(imageNamed: "arrowDown")
            arrow.alpha = 0.6
            arrow.scale(to: CGSize(width: 35, height: 70))
            arrow.position = CGPoint(x: 0, y: -width/4)
        returnNode.arrow = arrow
        if !node.didAppear {
            returnNode.addChild(arrow)
        }
    }
    return returnNode
}

func rateApp() {
    //"itms-apps://itunes.apple.com/app/" + "appId"
    guard let url = URL(string: "itms-apps://itunes.apple.com/app/1519496187/") else {
        return
    }
    if #available(iOS 10, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    } else {
        UIApplication.shared.openURL(url)
    }
}

func hexStringFromColor(color: UIColor) -> String {
   let components = color.cgColor.components
   let r: CGFloat = components?[0] ?? 0.0
   let g: CGFloat = components?[1] ?? 0.0
   let b: CGFloat = components?[2] ?? 0.0

   let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
   print(hexString)
   return hexString
}
