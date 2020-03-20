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
import AVFoundation

class StartGame: SKScene,SKPhysicsContactDelegate {
    
    var db:DatabaseReference!
    
    var bullet :Bullet?
    var TexttureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()
    
    var TexttureAtlas1 = SKTextureAtlas()
    var TextureArray1 = [SKTexture]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    var score = 0
    
    var scoreSound = 0
    
    var randomTime = 0
    
    var coinTimeAppear = 0
    
    //for parallax ground
    var ground = SKTexture(imageNamed: "horizon")
   
    var background = SKTexture(imageNamed: "background")
    
    
    var scoreLabel = SKLabelNode()
    var scoreCount:Bool = true
    var HighScoreLabel = SKLabelNode()
    
    var pointLabel = SKLabelNode()
    var points = 0
    
    var gameOverLabel = SKLabelNode()
    
    var gameRestart = SKSpriteNode(imageNamed: "restart")
    
    //add dinasour image
    var dinasour = SKSpriteNode()
    
    //add cactus image
    var cactus = SKSpriteNode(imageNamed: "cactus")
    
    //add second Cactus Image
    var cactus1 = SKSpriteNode(imageNamed: "cactus")
    
    //initially define dinasour on the ground as FALSE
    var dinasourMove: Bool = false
    
    //for bullet
    var bulletMove: Bool = false
    
    //for bird
    var bird = SKSpriteNode()
    var birdAppears = true
    //for coin
    var coin = SKSpriteNode(imageNamed: "coin")
    
    var dinoIsGround: Bool = true
    var dMove:CGFloat = 0.0
    
    //get phone id
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    var gameIsOn = true
    
    var cactusNew: Bool = false
    
     var soundBullet = SKAction.playSoundFileNamed("bullet", waitForCompletion: false)
     var soundCollide = SKAction.playSoundFileNamed("collide", waitForCompletion: false)
     var soundScore = SKAction.playSoundFileNamed("score", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
        //ANIMATION FUGLY T_REX :)
        TexttureAtlas = SKTextureAtlas(named: "bird")
        for i in 1...TexttureAtlas.textureNames.count{
            let Name1 = "bird\(i).png"
            
            TextureArray.append(SKTexture(imageNamed: Name1))
        }
        bird = SKSpriteNode(imageNamed: TexttureAtlas.textureNames[0] )
        
        bird.size = CGSize(width: 150, height: 130)
        bird.position = CGPoint(x: 200, y: 500)
        
        //hitbox
        self.bird.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:self.bird.frame.width, height:self.bird.frame.height))
        self.bird.physicsBody?.affectedByGravity = false
        self.bird.physicsBody?.isDynamic = false
        //end hitbox
        
        //T-rex is running foever :D ( poor T - work hard :(.
        self.addChild(bird)
        bird.run(SKAction.repeatForever(
            SKAction.animate(with: TextureArray,
                             timePerFrame: 0.05,
                             resize: false,
                             restore: true)),
                     withKey:"dino")
        //-----------------END ANIMATION----------\\
        
        
        //for parallax ground
        createground()
        createBackGround()
        
        
        //ANIMATION FUGLY T_REX :)
        TexttureAtlas1 = SKTextureAtlas(named: "dino")
        for i in 1...TexttureAtlas1.textureNames.count{
            let Name1 = "dino\(i).png"
            
            TextureArray1.append(SKTexture(imageNamed: Name1))
        }
        
        dinasour = SKSpriteNode(imageNamed: TexttureAtlas1.textureNames[0])
        
        dinasour.size = CGSize(width: 100, height: 100)
        dinasour.position = CGPoint(x: 84.183, y: 170.965)
        
        //hitbox
        self.dinasour.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:self.dinasour.frame.width, height:self.dinasour.frame.height))
        self.dinasour.physicsBody?.affectedByGravity = false
        self.dinasour.physicsBody?.isDynamic = false
        //end hitbox
        
        //T-rex is running foever :D ( poor T - work hard :(.
        self.addChild(dinasour)
        dinasour.run(SKAction.repeatForever(
            SKAction.animate(with: TextureArray1,
                             timePerFrame: 0.05,
                             resize: false,
                             restore: true)),
                 withKey:"dino")
        //-----------------END ANIMATION----------\\
        
//        //position the dinasour
//        dinasour.position = CGPoint(x: 84.183 , y:170.965)
//        dinasour.size = CGSize(width: 100.0, height: 100.0)
//        dinasour.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dinasour.size.width, height: dinasour.size.height))
//
//        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
//        dinasour.physicsBody?.isDynamic = false
//        print("addDinos")
//        addChild(dinasour)
//
        //position the cactus
        cactus.position = CGPoint(x: 1284, y: 124.219)
        cactus.size = CGSize(width: 100.0, height: 100.0)
//        cactus.physicsBody = SKPhysicsBody(circleOfRadius: cactus.size.width / 2.0)
        cactus.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cactus.size.width, height: cactus.size.height))
        cactus.name = "cactus"
        addChild(cactus)
        
        cactus1.position = CGPoint(x: 2584, y: 124.219)
        cactus1.size = CGSize(width: 100.0, height: 100.0)
        cactus1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cactus1.size.width, height: cactus1.size.height))
        cactus1.name = "cactus1"
        addChild(cactus1)
        
        // initialize delegate
        self.physicsWorld.contactDelegate = self
        
        positionHighScore()
        
        //score label
        positionLabel()
        
        //points label
        pointsLabel()
        
        
        
    }
    func createground(){
        
        for i in 0...3 {
        let groundPic = SKSpriteNode(texture: ground)
//            skyPic.zPosition = -30
            groundPic.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            groundPic.position = CGPoint(x: (ground.size().width * CGFloat(i)) - CGFloat(1 * i) , y: 130)
            addChild(groundPic)
            
            let moveLeft = SKAction.moveBy(x: -ground.size().width, y: 0, duration: 2)
            let moveRest = SKAction.moveBy(x: ground.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft,moveRest])
            
            let moveForever = SKAction.repeatForever(moveLoop)
            
            groundPic.run(moveForever)
            print("Ground x:\(groundPic.position.x)  y:\(groundPic.position.y)")
        }
        
       
    }
    
    func createBackGround() {
        for i in 0...3 {
            let BackGroundPic = SKSpriteNode(texture: background)
            //            skyPic.zPosition = -30
            BackGroundPic.anchorPoint = CGPoint(x: 0.1, y: 0.1)
            BackGroundPic.position = CGPoint(x: (background.size().width * CGFloat(i)) - CGFloat(1 * i) , y: 0)
            BackGroundPic.size = CGSize(width: 1334, height: 750)
            BackGroundPic.zPosition = -2
            addChild(BackGroundPic)
            
            let moveLeft = SKAction.moveBy(x: -background.size().width, y: 0, duration: 5)
            let moveRest = SKAction.moveBy(x: background.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft,moveRest])

            let moveForever = SKAction.repeatForever(moveLoop)

            BackGroundPic.run(moveForever)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        //asign score increment every 1 second
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
      
        
        
        let dt = currentTime - self.lastUpdateTime
        
        if(self.dinasour.frame.intersects(self.cactus.frame)) {
            print("INTERSECT")
           
            self.cactus.removeFromParent()
            self.cactus1.removeFromParent()
            self.scoreCount = false
            
            
            if(gameIsOn == true) {
                    gameOverLabelPosn()
                    gameIsOn = false
                 run(soundCollide)
            }
            
        }
        
        
        if(self.dinasour.frame.intersects(self.cactus1.frame)) {
            print("INTERSECT")
            self.cactus.removeFromParent()
            self.cactus1.removeFromParent()
            self.scoreCount = false
            
            
            if(gameIsOn == true) {
                gameOverLabelPosn()
                gameIsOn = false
                run(soundCollide)
            }
            
        }
        
        if(self.dinasour.frame.intersects(self.bird.frame)) {
            print("INTERSECT with bird")
            self.bird.removeFromParent()
            
            if(dt > 1) {
                if(birdAppears == true) {
                    self.points = points + 1
                    self.pointLabel.text = "Points:\(points)"
                }
            }
        }
        
        //print("DETCT\(self.dinasourMove)")
        
        // Calculate time since last update
        
        if(scoreCount == true) {
            
            
            if (dt >= 1) {
                self.score = score + 1
                self.scoreSound = self.scoreSound + 1
                self.randomTime = randomTime + 1
                print("Random\(randomTime)")
                self.coinTimeAppear = coinTimeAppear + 1
                self.lastUpdateTime = currentTime
                self.scoreLabel.text = "Score: \(score)"
            }
        }
        
        if(scoreSound == 100) {
            run(soundScore)
            scoreSound = 0
        }
       
        checkScore()
        detectEyebrow()
        if(bulletMove == true) {
             addBullet()
            self.bulletMove = false
        }
        
        if(self.randomTime == 0){
            print("BIRD ADDED")
            if(birdAppears == true) {
               // addBird()
                birdAppears = false
            }
        }
        
        if(self.randomTime == 5){
            if(birdAppears == false) {
                bird.removeFromParent()
                
                birdAppears = true
            }
        }
        
        if(self.randomTime == 6) {
             self.randomTime = 0
            bird.position.x = 0.0
        }
        print("Bird\(bird.position.x)")
        
        
        //add new ccatus after the score is 10
//        if(score == 10) {
//            cactusNew = true
//
//        }
        
//        if(cactusNew == true) {
//            newCactus()
//            cactusNew = false
//        }

        //cactus 1
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
        //cactus 2
        if(self.cactus1.position.x <= 0.0) {
            cactus1.position = CGPoint(x: 1584.0, y: 124.219)
        }
            
        else if(self.cactus1.position.x >=  0.0) {
            let cactusMovement1 = SKAction.move(to: CGPoint(x: -self.size.width, y:124.219), duration: 10)
            cactus1.run(cactusMovement1)
        }
        
        
        
        if(self.dinasour.position.x > frame.size.width - 100) {
            print("Restore Position of Dinasour")
            self.dinasour.position.x = 90.0
            print("ddd\(self.dinasour.position.x)")
            
        }

        //detect if the jump is straight or parabola
        let cactPositionX = self.cactus.position.x
        let dinoPosiitonX = self.dinasour.position.x

        let diffJump = cactPositionX - dinoPosiitonX
        //         print("DiffJump\(diffJump)")
        var u = 0

        if(diffJump >= 0 && diffJump <= 150) {

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
        
        //if jump-> Straight
        //if true-> jump up
        
    }
    
    func jumpStarightUp() {
        
        
        
        let dinoJump = SKAction.move(to: CGPoint(x: self.dinasour.position.x, y:self.frame.size.height/2), duration: 0.2)
        dinasour.run(dinoJump)

////        let dino1Jump = SKAction.moveBy(x: self.dinasour.position.x, y:self.frame.size.height/2 , duration: 0.5)
//
//        let dinoJumpSequence:SKAction = SKAction.sequence([dinoJump])
//
//        dinasour.run(SKAction.repeatForever(dinoJumpSequence))
//
        if(dinasour.position.y >= frame.size.height/2-10) {
            dinasourMove = false
            
            
        }
    }
    
   
    
    func jumpStraightDown() {
        let dinoJumpDown = SKAction.move(to: CGPoint(x: self.dinasour.position.x, y:170.965), duration: 0.3)
        dinasour.run(dinoJumpDown)
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
        
        let dinoParaJumpDown = SKAction.move(to: CGPoint(x: (self.dinasour.position.x) + (dMove)  , y:170.965), duration: 0.3)
        dinasour.run(dinoParaJumpDown)
        self.dMove = 0.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let mouseposition = touch.location(in: self)
        let nodeName = self.atPoint(mouseposition).name
        
       
//        if(dinasourMove == true) {
////            dinasourMove = false
//
//        } else {
//            dinasourMove = true
//        }
        
        if(nodeName == "restart") {
            perform(#selector(GameScene.StartGame1),with: nil, afterDelay: 1)
        }

        if(nodeName == "back") {
            perform(#selector(StartGame.back1),with: nil, afterDelay: 1)
        }
    }
  
    
    @objc func StartGame1() {
        let scene = GameScene(fileNamed: "StartGame")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
    
    @objc func back1() {
        let scene = GameScene(fileNamed: "GameScene")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
 
    
    func addBullet() {
        let dinoX = self.dinasour.position.x
        let dinoY = self.cactus.position.y
        
        // add an BULLET at dinasour position
        self.bullet = Bullet()
        bullet?.position = CGPoint(x: dinoX, y: dinoY)
        bullet!.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bullet!.size.width, height: bullet!.size.height))
        
        addChild(self.bullet!)
        
        //move the bullet
        let bulletMove = SKAction.move(to: CGPoint(x: self.size.width, y:self.cactus.position.y), duration: 10)
        let bulletsMove = SKAction.moveBy(x: self.size.width, y:self.cactus.position.y, duration: 10)
        let bulletSequence:SKAction = SKAction.sequence([bulletMove, bulletsMove])
        bullet!.run(SKAction.repeatForever(bulletSequence))
    }
    
    func addBird() {
        bird.position = CGPoint(x: 500, y: frame.size.height / 2 - 50)
        bird.name = "bird"
        bird.size = CGSize(width: 100.0, height: 100.0)
        bird.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bird.size.width, height: bird.size.height))
        bird.physicsBody?.isDynamic = false
        addChild(bird)
        
        
        
    }
    
    func addCoin(){
        coin.position = CGPoint(x: 1298.133, y: 134.17)
        coin.size = CGSize(width: 50, height: 50)
        coin.name = "coin1"
        addChild(coin)
    }
    
    func gameOverLabelPosn() {
        self.gameOverLabel.text = "GAME OVER"
        self.gameOverLabel.position.x = frame.size.width / 2
        self.gameOverLabel.position.y = frame.size.height / 2
        self.gameOverLabel.fontSize = 50
        self.gameOverLabel.fontColor = UIColor.red
        self.gameOverLabel.fontName = "AvenirNext-Bold"
        addChild(gameOverLabel)
        
        gameRestart.position = CGPoint(x: frame.size.width / 2 , y:frame.size.width / 2 - 100)
        gameRestart.name = "restart"
        gameRestart.size = CGSize(width: 82.0, height: 82.0)
        addChild(gameRestart)
    }
    
    func positionLabel() {
        self.scoreLabel.text = "Current Score: \(score)"
        self.scoreLabel.position.x = 1100
        self.scoreLabel.position.y = 600
        self.scoreLabel.fontSize = 50
        self.scoreLabel.fontColor = UIColor.red
        self.scoreLabel.fontName = "AvenirNext-Bold"
        addChild(scoreLabel)
    }
    
    func pointsLabel() {
        self.pointLabel.text = "Points: \(points)"
        self.pointLabel.position.x = frame.size.width/2
        self.pointLabel.position.y = 600
        self.pointLabel.fontSize = 50
        self.pointLabel.fontColor = UIColor.red
        self.pointLabel.fontName = "AvenirNext-Bold"
        addChild(pointLabel)
    }
    
    func positionHighScore() {
        self.HighScoreLabel.text = "High Score: \(score)"
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
        let scene = GameScene(fileNamed: "GameScene")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
    
    func detectEyebrow() {
        print("EYebrow detected")
        self.db = Database.database().reference()
        self.db.child("startGame").child(deviceId).observeSingleEvent(of: .value, with:{
            (snapshot) in
            let x = snapshot.value as! NSDictionary
            let eyeBrowValue = x["brows"]!
            
            let toungueValue = x["toungue"]
            var ui = 0.5 as! NSNumber
            
            if (eyeBrowValue as! Float) > 0.5 {
                self.dinasourMove = true
            } else {
                self.dinasourMove = false
            }
            
            if(toungueValue as! Double > 0.8) {
                self.bulletMove = true
            } else {
                self.bulletMove = false
            }
            
            
            
//            if eyeBrowValue as! Float < 0.5 {
//                self.dinasourMove = false
//            }
        })
    }
}
