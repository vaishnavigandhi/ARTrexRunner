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


class StartGame: SKScene,SKPhysicsContactDelegate {
    var db:DatabaseReference!
    var bullet :Bullet?
    
    private var lastUpdateTime : TimeInterval = 0
    var score = 0
    var randomTime = 0
    var coinTimeAppear = 0
    var ground = SKSpriteNode()
    var groundNext = SKSpriteNode()
    
    var scoreLabel = SKLabelNode()
    
    var HighScoreLabel = SKLabelNode()
    
    //add dinasour image
    var dinasour = SKSpriteNode(imageNamed: "dinosaur1")
    
    //add cactus image
    var cactus = SKSpriteNode(imageNamed: "cactus_small")
    
    //initially define dinasour on the ground as FALSE
    var dinasourMove: Bool = false
    
    //for bullet
    var bulletMove: Bool = false
    
    //for bird
    var bird = SKSpriteNode(imageNamed: "bird")
    var birdAppear: Bool = false
    
    //for coin
    var coin = SKSpriteNode(imageNamed: "coin")
    var coinAppear: Bool = false
    
    var dinoIsGround: Bool = true
    var dMove:CGFloat = 0.0
    
    //get phone id
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    
    
    override func didMove(to view: SKView) {
        //position the dinasour
        dinasour.position = CGPoint(x: 92.183 , y:124.219)
        dinasour.physicsBody = SKPhysicsBody(circleOfRadius: dinasour.size.width / 2.0)
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        dinasour.physicsBody?.isDynamic = false
        print("addDinos")
        addChild(dinasour)
        
        //position the cactus
        cactus.position = CGPoint(x: 1284, y: 124.219)
        cactus.physicsBody = SKPhysicsBody(circleOfRadius: cactus.size.width / 2.0)
        cactus.name = "cactus"
        addChild(cactus)
        
        // initialize delegate
        self.physicsWorld.contactDelegate = self
        positionHighScore()
        //score label
        positionLabel()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        //asign score increment every 1 second
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        
        //print("DETCT\(self.dinasourMove)")
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        if (dt >= 1) {
            self.score = score + 1
            self.randomTime = randomTime + 1
            self.coinTimeAppear = coinTimeAppear + 1
            self.lastUpdateTime = currentTime
            
            self.scoreLabel.text = "Score: \(score)"
        }
        checkScore()
        if(randomTime == 0){
//            print("BIRD ADDED")
            addBird()
        }

        if(randomTime == 10){
            bird.removeFromParent()
//            print("Bird Deleted")
        }
        
        if(coinTimeAppear == 11) {
//            print("COIN")
//            addCoin()
        }

        
        //if the cactus goes outside the frame
        //position from the initial position
        if(self.cactus.position.x <=  0.0) {
            // print("IF")
            cactus.position = CGPoint(x: 1284.0, y: 124.219)
            //  print("CACT1: \(self.cactus.position.x)")

        }
            //o/w move towards the other side of screen
        else if(self.cactus.position.x >=  0.0) {
            let cactusMovement1 = SKAction.move(to: CGPoint(x: -self.size.width, y:124.219), duration: 10)
            cactus.run(cactusMovement1)
        }

        //detect if the jump is straight or parabola
        let cactPositionX = self.cactus.position.x
        let dinoPosiitonX = self.dinasour.position.x

        let diffJump = cactPositionX - dinoPosiitonX
        //         print("DiffJump\(diffJump)")
        var u = 0

        if(diffJump >= 0 && diffJump <= 350) {

            // print("Parabola Jump")
            if(dinasourMove == true) {
                dMove = 1000.0
                jumpParabolaUp()
            }
            //if false -> fall down
            else if(dinasourMove == false){
                jumpParabolaDown()
            }

        } else {
            //print("Straight Jump")
            if(dinasourMove == true) {
                jumpStarightUp()
            }
                //if false -> fall down
            else {
                jumpStraightDown()
            }
        }

        if(dinasour.position.x >= frame.size.width - 100){
            dinasour.position = CGPoint(x: 92.183 , y:124.219)
        } else {
//            print("Not Exceeded")
        }
        
        //if jump-> Straight
        //if true-> jump up
        
    }
    
    func jumpStarightUp() {
        
        let dinoJump = SKAction.move(to: CGPoint(x: self.dinasour.position.x, y:self.frame.size.height/2), duration: 0.5)
        dinasour.run(dinoJump)
        
        let dino1Jump = SKAction.moveBy(x: self.dinasour.position.x, y:self.frame.size.height/2 , duration: 0.5)
        
        let dinoJumpSequence:SKAction = SKAction.sequence([dinoJump, dino1Jump])
        
        dinasour.run(SKAction.repeatForever(dinoJumpSequence))
        
        if(dinasour.position.y >= frame.size.height/2-10) {
            dinasourMove = false
            
            
        }
    }
    
    func jumpStraightDown() {
        let dinoJumpDown = SKAction.move(to: CGPoint(x: self.dinasour.position.x, y:124.219), duration: 0.3)
        let dino1JumpDown = SKAction.moveBy(x: self.dinasour.position.x, y:124.219 , duration: 0.3)
        let dinoJumpDownSequence:SKAction = SKAction.sequence([dinoJumpDown, dino1JumpDown])
        dinasour.run(SKAction.repeatForever(dinoJumpDownSequence))
    }
    
    func jumpParabolaUp() {
        let dinoParaJump = SKAction.move(to: CGPoint(x: self.dinasour.position.x + dMove, y:self.frame.size.height/2), duration: 0.5)
        dinasour.run(dinoParaJump)
        
        let dino1ParaJump = SKAction.moveBy(x: self.dinasour.position.x + dMove, y:self.frame.size.height/2 , duration: 0.5)
        
        let dinoParaJumpSequence:SKAction = SKAction.sequence([dinoParaJump, dino1ParaJump])
        
        dinasour.run(SKAction.repeatForever(dinoParaJumpSequence))
        //        print("PARA JUMP UP")
        //        print("x:\(dinasour.position.x)")
        //        print("y:\(dinasour.position.y)")
        if(dinasour.position.y >= frame.size.height/2-10) {
            dinasourMove = false
            dMove = 1000.0
        }
        
    }
    
    
    
    
    func jumpParabolaDown() {
        
        let dinoParaJumpDown = SKAction.move(to: CGPoint(x: (self.dinasour.position.x) + (dMove)  , y:124.219), duration: 0.3)
        let dino1ParaJumpDown = SKAction.moveBy(x: (self.dinasour.position.x) + (dMove), y:124.219 , duration: 0.3)
        let dinoParaJumpDownSequence:SKAction = SKAction.sequence([dinoParaJumpDown, dino1ParaJumpDown])
        dinasour.run(SKAction.repeatForever(dinoParaJumpDownSequence))
        self.dMove = 0.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let mouseposition = touch.location(in: self)
        let nodeName = self.atPoint(mouseposition).name
        
        if(nodeName == "menu") {
            perform(#selector(StartGame.MenuScreen),with: nil, afterDelay: 1)
        }

        if(dinasourMove == true) {
            dinasourMove = false
            bulletMove = true
        } else {
            dinasourMove = true
        }

        if(bulletMove == true) {
            // addBullet()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("HELLO")
        let objectA = contact.bodyA.node as? SKSpriteNode
        let objectB = contact.bodyB.node as? SKSpriteNode
        
        print("ObjectA\(objectA)")
        print("Object B\(objectB)")
        
        if(objectA?.name == "cactus") {
            print("ObjectB\(objectB)")
        } else if(objectB?.name == "cactus"){
            print("Object A\(objectA)")
        }
    }
    
    func addBullet() {
        let dinoX = self.dinasour.position.x
        let dinoY = self.cactus.position.y
        
        // add an BULLET at dinasour position
        self.bullet = Bullet()
        bullet?.position = CGPoint(x: dinoX, y: dinoY)
        addChild(self.bullet!)
        
        //move the bullet
        let bulletMove = SKAction.move(to: CGPoint(x: self.size.width, y:self.cactus.position.y), duration: 10)
        let bulletsMove = SKAction.moveBy(x: self.size.width, y:self.cactus.position.y, duration: 10)
        let bulletSequence:SKAction = SKAction.sequence([bulletMove, bulletsMove])
        bullet!.run(SKAction.repeatForever(bulletSequence))
    }
    
    func addBird() {
        bird.position = CGPoint(x: 1271.907, y: 482.543)
        bird.name = "bird"
        addChild(bird)
        
    }
    
    func addCoin(){
        coin.position = CGPoint(x: 1298.133, y: 134.17)
        coin.size = CGSize(width: 50, height: 50)
        coin.name = "coin1"
        addChild(coin)
    }
    
    func positionLabel() {
        self.scoreLabel.text = "Score: \(score)"
        self.scoreLabel.position.x = 1100
        self.scoreLabel.position.y = 650
        self.scoreLabel.fontSize = 50
        self.scoreLabel.fontColor = UIColor.red
        self.scoreLabel.fontName = "AvenirNext-Bold"
        addChild(scoreLabel)
    }
    
    func positionHighScore() {
        self.HighScoreLabel.text = "High: \(score)"
        self.HighScoreLabel.position.x = 1100
        self.HighScoreLabel.position.y = 550
        self.HighScoreLabel.fontSize = 50
        self.HighScoreLabel.fontColor = UIColor.red
        self.HighScoreLabel.fontName = "AvenirNext-Bold"
        addChild(HighScoreLabel)
    }
    
    func checkScore(){
        self.db = Database.database().reference()
        self.db.child("score").child(deviceId).observeSingleEvent(of: .value, with:{
            (snapshot) in
            let x = snapshot.value as! NSDictionary
            let xScore = x["score"]
            
            if(self.score as! Int > xScore as! Int) {
                
                self.HighScoreLabel.text = "High: \(self.score)"
             self.db.child("score").child(self.deviceId).child("score").setValue(self.score)
            } else {
                self.HighScoreLabel.text = "High: \(xScore!)"
            }
            
        })
    }
    
    @objc func MenuScreen() {
        let scene = GameScene(fileNamed: "Scene")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
    
    func detectEyebrow() {
        print("EYebrow detected")
    }
}
