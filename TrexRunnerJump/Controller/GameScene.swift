//
//  GameScene.swift
//  TrexRunnerJump
//
//  Created by Hiten Patel on 2019-04-15.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import SpriteKit
import GameplayKit
import Firebase
import FirebaseDatabase

class GameScene: SKScene {
    
     var ScoreData = [String : Any]()
     var db:DatabaseReference!
    
    override func didMove(to view: SKView) {
        print("HELLO")
        checkExists()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let mouseposition = touch.location(in: self)
        let nodeName = self.atPoint(mouseposition).name
        print("TOUCEHS\(nodeName)")
        //redirect to startgame Screen
        if(nodeName == "startGame") {
//            print("Start Game\(nodeName)")
            perform(#selector(GameScene.StartGame),with: nil, afterDelay: 1)
        }
            //redirect top high score screen
        else if(nodeName == "highScore"){
//             print("HighScore\(nodeName)")
            perform(#selector(GameScene.HighScore),with: nil, afterDelay: 1)
        }
    }
    
    //get phone id
     let deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    func saveData(){
        
        //get phone name
        let systemName = UIDevice.current.name as! String
        
        let score = 0
        
        ScoreData = ["name": systemName,"deviceId" :self.deviceId,"score": score] as [String : Any]
        
        self.db = Database.database().reference()
        
        self.db.child("score").child(self.deviceId).setValue(ScoreData)
        
    }
    
    func checkExists() {
        self.db = Database.database().reference()
        self.db.child("score").child(deviceId).observeSingleEvent(of: .value, with:{
            (snapshot) in
            let x = snapshot.value as! NSDictionary
            let checkPhone = x["deviceId"]!
           print("snap\(x["deviceId"]!)")
            
            if(x["deviceId"] as! String == self.deviceId) {
                print("Already Exists")
            } else {
                self.saveData()
                print("New User")
            }
        })
    }
    
    @objc func HighScore() {
        let scene = GameScene(fileNamed: "HighScore")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
    
    @objc func StartGame() {
        let scene = GameScene(fileNamed: "StartGame")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
}
