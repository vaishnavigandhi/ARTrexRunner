//
//  GameViewController.swift
//  TrexRunnerJump
//
//  Created by Hiten Patel on 2019-04-15.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import ARKit
import Firebase
import FirebaseDatabase

class GameViewController: UIViewController,ARSessionDelegate {
   
    var db:DatabaseReference!
    var session:ARSession!
    
     var deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDetect()
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.showsPhysics = true
                    session = ARSession()
                    session.delegate = self
                }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARFaceTrackingConfiguration.isSupported else {
            print("IPhone X Only")
            return
        }
        
        let configuration = ARFaceTrackingConfiguration()
        session.run(configuration, options: [.resetTracking,.removeExistingAnchors])
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let faceAnchor = anchors.first as? ARFaceAnchor {
            update(withFaceAnchor: faceAnchor)
        }
        
    }
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor) {
        var blendShapes:[ARFaceAnchor.BlendShapeLocation:Any] = faceAnchor.blendShapes
        
        guard let browinnerUp = blendShapes[.browInnerUp] as? Float else {
            return
        }
        
        if browinnerUp > 0.5 {
            print("Move Dino Up")
        }
        
        self.db = Database.database().reference()
        self.db.child("startGame").child(deviceId).observeSingleEvent(of: .value, with:{
            (snapshot) in
            let x = snapshot.value as! NSDictionary
            print("x\(x["brows"])")
            
        })
        
     }
    
    func startDetect() {
            print("STATRGAME")
            var sendData = ["brows": 0, "toungue": 0] 
            self.db = Database.database().reference()
            self.db.child("startGame").child(self.deviceId).setValue(sendData)
    }
}
