//
//  tutorialController.swift
//  TrexRunnerJump
//
//  Created by Vaishnavi Gandhi on 2019-04-20.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit
import ARKit
import Firebase
import FirebaseDatabase

class tutorialController: SKScene {
    
    //databse reference varibale
     var db:DatabaseReference!
    
    
    private var playerNode:Player?
    var moving:Bool = false
    var generator:UIImpactFeedbackGenerator!
    
    //get deviceID
     let deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    override func didMove(to view: SKView) {
        
        
        playerNode = self.childNode(withName: "player") as? Player
        
        generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
    }
    
    override func update(_ currentTime: TimeInterval) {
        detectEyebrow()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let mouseposition = touch.location(in: self)
        let nodeName = self.atPoint(mouseposition).name
        print("TOUCEHS\(nodeName)")
        //redirect to startgame Screen
        if(nodeName == "next") {
            
            //            print("Start Game\(nodeName)")
           perform(#selector(tutorialController.next1),with: nil, afterDelay: 1)
        }
    }
    @objc func next1() {
        let scene = tutorialController(fileNamed: "next")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
        print("MOVING TO NEXT SKS")
    }
    
    func updatePlayer (state:PlayerState) {
        if !moving {
            movePlayer(state: state)
        }
        
    }
    
    func movePlayer (state:PlayerState) {
        if let player = playerNode {
            player.texture = SKTexture(imageNamed: state.rawValue)
            
            var direction:CGFloat = 0
            
            switch state {
            case .up:
                direction = 116
            case .down:
                direction = -116
            case .neutral:
                direction = 0
            }
            
            if Int(player.position.y) + Int(direction) >= -232 && Int(player.position.y) + Int(direction) <= 232 {
                
                moving = true
                
                let moveAction = SKAction.moveBy(x: 0, y: direction, duration: 0.3)
                
                let moveEndedAction = SKAction.run {
                    self.moving = false
                    if direction != 0 {
                        self.generator.impactOccurred()
                    }
                }
                
                let moveSequence = SKAction.sequence([moveAction, moveEndedAction])
                
                player.run(moveSequence)
                
                
            }
            
        }
    }
    
    func detectEyebrow() {
        print("EYebrow detected")
        self.db = Database.database().reference()
        self.db.child("startGame").child(deviceId).observeSingleEvent(of: .value, with:{
            (snapshot) in
            let x = snapshot.value as! NSDictionary
            let eyeBrowValue = x["brows"]!
            
            let toungueValue = x["toungue"]
            print("EYEBRW")
            if (eyeBrowValue as! Double > 0.5) {
                self.updatePlayer(state: .up)
                print("UP")
               // gameScene.updatePlayer(state: .up)
            }else if ((eyeBrowValue as! Double) < 0.025)  {
                self.updatePlayer(state: .down)
                print("DOWN")
               // gameScene.updatePlayer(state: .down)
            }else {
               self.updatePlayer(state: .neutral)
                print("NEW")
            }
            
        })
    }
    
}
