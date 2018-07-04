//
//  GameViewController.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameVC: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    var gameModel : GameModel?
    var scene : GameScene?
    var defaultGameParams: GameParams?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scene = GameScene.newGameScene()

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(self.scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        self.defaultGameParams = GameParams(
            fieldSize: 4,
            randomElementsCount: 4,
            blockedCellsCount: 2,
            strategy: PowerOfTwoMergingStrategy())
        
        let recognizer = HexSwipeGestureRecogniser(
            target: self,
            action:#selector(handleSwipe(recognizer:)))
        recognizer.delegate = self
        self.view.addGestureRecognizer(recognizer)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onGameReset),
            name: .resetGame,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onScoreUpdate),
            name: .updateScore,
            object: nil)
        
        startGame()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func startGame() {
        
        let cmd = StartGameCMD(
            scene: self.scene!,
            view: self.view as! SKView,
            params: self.defaultGameParams!)
        cmd.run()
        self.gameModel = cmd.gameModel
        //ContainerConfig.instance.Register(self.gameModel as! GameModel)
    }
    
    @objc func onGameReset(notification: Notification) {
        
        CleanGameCMD(self.gameModel!).run()
        startGame()
    }
    
    @objc func onScoreUpdate(notification: Notification) {
        
        scoreLabel.text = "\(self.gameModel!.score)"
    }
}

extension GameVC: UIGestureRecognizerDelegate {
    
    @objc func handleSwipe(recognizer: HexSwipeGestureRecogniser) {
        
        DoSwipeCMD(self.gameModel!).run(direction: recognizer.direction)
    }
    
    // https://stackoverflow.com/questions/4825199/gesture-recognizer-and-button-actions
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view is UIButton) {
            return false
        }
        return true
    }
}
