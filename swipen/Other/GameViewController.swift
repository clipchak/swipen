//
//  GameViewController.swift
//  color swipe
//
//  Created by Colton Lipchak on 12/17/19.
//  Copyright © 2019 clipchak. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit
import GoogleMobileAds

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    var totalGames = Int(0)
    var interstitial: GADInterstitial!
    var interstitialID = "ca-app-pub-3940256099942544/4411468910"


    override func viewDidLoad() {
        self.view.isMultipleTouchEnabled = false
        JKAudioPlayer.canShareAudio = true
        initAdMobInterstitial()
        
        width = self.view.frame.width
        height = self.view.frame.height
        
        if UserDefaults.standard.object(forKey: "totalGames") != nil {
            totalGames = UserDefaults.standard.integer(forKey: "totalGames")
        }
        
        addObservers()
        
        if !menuScenePresented{
            if let view = self.view as! SKView? {
                let gameScene = IntroScene(size: self.view.frame.size)
                gameScene.scaleMode = .aspectFit
                view.presentScene(gameScene)
                                                    
                view.ignoresSiblingOrder = true
//                // Load the SKScene from 'GameScene.sks'
//                if totalGames == 0 {
//                    let gameScene = AdvancedTutorialScene(size: self.view.frame.size)
//                    gameScene.scaleMode = .aspectFit
//                    view.presentScene(gameScene)
//                                                
//                    view.ignoresSiblingOrder = true
//                } else{
//                    let gameScene = IntroScene(size: self.view.frame.size)
//                    gameScene.scaleMode = .aspectFit
//                    view.presentScene(gameScene)
//                                                
//                    view.ignoresSiblingOrder = true
//                }
                
            }
        }
                
        super.viewDidLoad()
        
    }
    
    ///adds observers to these functions so they can be called anywhere in the app
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.authPlayer), name: NSNotification.Name(rawValue: "authPlayer"), object: nil)
          
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentInterstitialAd), name: NSNotification.Name(rawValue: "presentInterstitialAd"), object: nil)
          
        NotificationCenter.default.addObserver(self, selector: #selector(self.initAdMobInterstitial), name: NSNotification.Name(rawValue: "loadInterstitialAd"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {

        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                safeAreaBottom = window.safeAreaInsets.bottom
                safeAreaLeft = window.safeAreaInsets.left
                safeAreaRight = window.safeAreaInsets.right
                safeAreaTop = window.safeAreaInsets.top
            }
        }
        

    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func initAdMobInterstitial(){
        interstitial = GADInterstitial(adUnitID: interstitialID)
        let request = GADRequest()
        interstitial.load(request)
    }
    
    @objc func presentInterstitialAd(){
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    @objc func authPlayer(){
        let localPLayer = GKLocalPlayer.local
        localPLayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                self.present(view!, animated: true, completion: nil)
                
            } else{
                print(GKLocalPlayer.local.isAuthenticated)
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
