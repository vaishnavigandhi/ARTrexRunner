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

class HighScore: SKScene {
    var db:DatabaseReference!
    
    let textnode = SKLabelNode()
    
    var score1 = SKLabelNode()
    var score2 = SKLabelNode()
    var name1 = SKLabelNode()
    var name2 = SKLabelNode()
    
    
    var tempname : [String] = []
    var tempscore : [Int] = []
    var numberOfScores = 0
    var dataNamess = ""
    
    override func didMove(to view: SKView) {
        print("HEIGH")
        
        labelsScreen()
        getData()
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let mouseposition = touch.location(in: self)
        let nodeName = self.atPoint(mouseposition).name
        
        if(nodeName == "back") {
            perform(#selector(HighScore.MenuScreen),with: nil, afterDelay: 1)
        }
    }
    
    
    func getData() {
        self.db = Database.database().reference()
        
        self.db.child("score").observe(DataEventType.childAdded, with:{
            (snapshot) in
            print("\(snapshot.value)")
            let x = snapshot.value as! NSDictionary
           
            for x1 in x {
                
                
                if(x1.key as! String == "name") {
                    print("NAME IS :\(x1.value)")
                    self.tempname.append(x1.value as! String)
                }
                if(x1.key as! String == "score"){
                    print("SCORE IS :\(x1.value)")
                    self.tempscore.append(x1.value as! Int)
                }
            }
//            print("FINAL DATA")
//            print(self.tempname)
//            print(self.tempscore)
//
            for (i,j) in self.tempname.enumerated(){
               
                if(i == 0){
                    self.name1.text = j

                }
                if(i == 1){
                    self.name2.text = j
                }
//
            }
            
            for (k,v) in self.tempscore.enumerated(){
                
                if(k == 0){
                    self.score1.text = "\(v)"
                    
                }
                if(k == 1){
                    self.score2.text = "\(v)"
                }
                //
            }
            
            print("ScrName\(self.dataNamess)")
            for j in self.tempscore{
                print("***********************************")
                print("\(j)")
                print("***********************************")
                
            }
        })
    }
    
    func labelsScreen() {
        
        score1.position = CGPoint(x: 514.0, y: 374.0)
        score1.fontSize = 36
        self.score1.fontColor = UIColor.black
        score1.text = "hi"
        addChild(score1)
        
        score2.position = CGPoint(x: 514.0, y: 208.0)
        score2.fontSize = 36
        self.score2.fontColor = UIColor.black
        score2.text = "hi"
        addChild(score2)
        
        name1.position = CGPoint(x: 862.0, y: 383.0)
        name1.fontSize = 36
        self.name1.fontColor = UIColor.black
        name1.text = "hi"
        addChild(name1)
        
        name2.position = CGPoint(x: 862.0, y: 210.0)
        name2.fontSize = 36
        self.name2.fontColor = UIColor.black
        name2.text = "hi"
        addChild(name2)
        
    }
   
    
    @objc func MenuScreen() {
        let scene = GameScene(fileNamed: "GameScene")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
}

extension SKLabelNode {
    func multilined() -> SKLabelNode {
        let substrings: [String] = self.text!.components(separatedBy: "\n")
        return substrings.enumerated().reduce(SKLabelNode()) {
            let label = SKLabelNode(fontNamed: self.fontName)
            label.text = $1.element
            label.fontColor = self.fontColor
            label.fontSize = self.fontSize
            label.position = self.position
            label.horizontalAlignmentMode = self.horizontalAlignmentMode
            label.verticalAlignmentMode = self.verticalAlignmentMode
            let y = CGFloat($1.offset - substrings.count / 2) * self.fontSize
            label.position = CGPoint(x: 0, y: -y)
            $0.addChild(label)
            return $0
        }
    }
}
