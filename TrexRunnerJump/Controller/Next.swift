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

class Next: SKScene {
    
    var bullet :Bullet?
   
    
    //databse reference varibale
    var db:DatabaseReference!
    //get deviceID
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    var dinasour = SKSpriteNode(imageNamed: "tyrannosaurus-rex")
    
     private var lastUpdateTime : TimeInterval = 0
    
    var bulletCount = 0
    
    override func didMove(to view: SKView) {
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let mouseposition = touch.location(in: self)
        let nodeName = self.atPoint(mouseposition).name
        print("Node\(nodeName)")
        if(nodeName == "playGame") {
            print("PLAY GAME")
             perform(#selector(Next.play1Game1),with: nil, afterDelay: 1)
        }
    }
    
    @objc func play1Game1() {
        let scene = GameScene(fileNamed: "StartGame")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        let dt = currentTime - self.lastUpdateTime
        
        if(dt > 1) {
            self.bulletCount = bulletCount + 1
//            print("BulletCOunt\(self.bulletCount)")
        }
        
        detectEyebrow()
      
       
        
//        if(self.bulletStatus == true) {
////            self.bulletStatus = true
//            print("Bul\(self.bulletStatus)")
//            self.childNode(withName: "bulleta")?.removeFromParent()
//            self.bulletStatus = false
//            print("Bul1\(self.bulletStatus)")
//        }
        
    }
    
    func addBullet() {
        var soundBullet1 = SKAction.playSoundFileNamed("bullet", waitForCompletion: false)
        run(soundBullet1)
        
        var dinoX = 173.361
        var dinoY = 223.363
        print("x\(dinoX) y:\(dinoY)")
        // add an BULLET at dinasour position
        self.bullet = Bullet()
        bullet?.position = CGPoint(x: dinoX, y: 223.363)
        addChild(self.bullet!)

        //move the bullet
        let bulletMove = SKAction.move(to: CGPoint(x: self.size.width, y: 223.363), duration: 10)
       
        bullet!.run(bulletMove)
       
     
       
    }
    
    
    
    
    func detectEyebrow() {
//        print("EYebrow detected")
        self.db = Database.database().reference()
        self.db.child("startGame").child(deviceId).observeSingleEvent(of: .value, with:{
            (snapshot) in
            let x = snapshot.value as! NSDictionary
            
            let toungueValue = x["toungue"]
//            print("toungue\(toungueValue)")
            
            if(toungueValue as! Double >= 0.5) {
//                print("IF")
                
                self.addBullet()
            } else {
//                print("ELSE")
            }
            
           
            
            
        })
    }
    
}
