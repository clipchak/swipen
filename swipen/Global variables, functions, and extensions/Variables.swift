//
//  Variables.swift
//  swipen
//
//  Created by Colton Lipchak on 7/13/20.
//  Copyright © 2020 clipchak. All rights reserved.
//

import SpriteKit

//global variables
var fontString = "Damascus"
var menuScenePresented = false
var timedModeOn = false
var restartFromALoss = false
var soundOn = true
var timedHighscore = Int(0)
var regHighscore = Int(0)
var totalSwipes = Int(0)
var totalGames = Int(0)
var lastGameScore = Int(5)
var standardSize = CGSize(width: 50, height: 50)

//sizing for different phones
var safeAreaBottom = CGFloat(0.0)
var safeAreaLeft = CGFloat(0.0)
var safeAreaRight = CGFloat(0.0)
var safeAreaTop = CGFloat(0.0)

//sizes
var width = CGFloat(0)
var height = CGFloat(0)
var fullScreen = CGSize(width: width + 13 , height: height + 13)
var middlePosition = CGPoint(x: width/2, y: height/2)
var menuAlignment = SKLabelVerticalAlignmentMode(rawValue: 2)!

//save color for smooth transitions to menu
var newMenuColor = ColorNode(color: UIColor(hexString: "#990000")!, colorClass: "red", name: "red02")

// questionable colors to remove: #7FCDCD, FF8000, 00CED1, EFC050, DDA0DD, FF6F61
// 794044 possibly brown in color
var blueColorNodes =   [ColorNode]()
var pinkColorNodes =   [ColorNode]()
var purpleColorNodes = [ColorNode]()
var greenColorNodes =  [ColorNode]()
var redColorNodes =    [ColorNode]()
var brownColorNodes =  [ColorNode]()
var orangeColorNodes = [ColorNode]()
var yellowColorNodes = [ColorNode]()
//unused
var grayColorNodes =   [ColorNode(color: UIColor(hexString: "#666666")!, colorClass: "gray", name: "gray01")]


var newGameNodes = [ColorNode]()
