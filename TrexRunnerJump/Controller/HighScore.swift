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
    
    var nameTitleLabel = SKLabelNode()
    var nameLabel = SKLabelNode()
    
    var scoreTitleLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        print("HEIGH")
        addScoreLabel()
        ScoreTitle()
        addNameLabel()
        NameTitle()
        getData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let mouseposition = touch.location(in: self)
        let nodeName = self.atPoint(mouseposition).name
        
        if(nodeName == "menu") {
            perform(#selector(HighScore.MenuScreen),with: nil, afterDelay: 1)
        }
    }
    
    func addScoreLabel() {
        print("ScoreLabel")
        self.scoreLabel.text = "Score1:"
        self.scoreLabel.position.x = 500
        self.scoreLabel.position.y = 550
        self.scoreLabel.fontSize = 50
        self.scoreLabel.fontColor = UIColor.red
        self.scoreLabel.fontName = "AvenirNext-Bold"
        addChild(scoreLabel)
    }
    
    func ScoreTitle(){
        self.scoreTitleLabel.text = "Score:"
        self.scoreTitleLabel.position.x = 500
        self.scoreTitleLabel.position.y = 650
        self.scoreTitleLabel.fontSize = 50
        self.scoreTitleLabel.fontColor = UIColor.red
        self.scoreTitleLabel.fontName = "AvenirNext-Bold"
        addChild(scoreTitleLabel)
    }
    
    func addNameLabel() {
        self.nameLabel.text = "Name1:"
        self.nameLabel.position.x = 200
        self.nameLabel.position.y = 550
        self.nameLabel.fontSize = 50
        self.nameLabel.fontColor = UIColor.red
        self.nameLabel.fontName = "AvenirNext-Bold"
        addChild(nameLabel)
    }
    
    func NameTitle() {
        self.nameTitleLabel.text = "Name:"
        self.nameTitleLabel.position.x = 200
        self.nameTitleLabel.position.y = 650
        self.nameTitleLabel.fontSize = 50
        self.nameTitleLabel.fontColor = UIColor.red
        self.nameTitleLabel.fontName = "AvenirNext-Bold"
        addChild(nameTitleLabel)
    }
    
    
    
    func getData() {
        self.db = Database.database().reference()
        
        self.db.child("score").observe(DataEventType.childAdded, with:{
            (snapshot) in
            let x = snapshot.value as! NSDictionary
            print(x)
            print(x.count)
            self.scoreLabel.text = "\(x["score"]!)"
            self.nameLabel.text = "\(x["name"]!)"
            
            print("score:\(x["score"])")
            print("name:\(x["name"])")
           
        })
    }
    
    @objc func MenuScreen() {
        let scene = GameScene(fileNamed: "Scene")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
}
