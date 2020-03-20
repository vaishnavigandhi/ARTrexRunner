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
        }else if (nodeName == "tutorial"){
            perform(#selector(GameScene.tutorial),with: nil, afterDelay: 1)
        }
        else if (nodeName == "exit") {
            print("EXIT THE APPLICATION")
             exit(0)
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
            
            if(snapshot.exists()) {
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
    
    @objc func StartGame1() {
        let scene = GameScene(fileNamed: "StartGame")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
    
    @objc func tutorial() {
        let scene = GameScene(fileNamed: "testTutorial")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
}
