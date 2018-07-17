//
//  ViewController.swift
//  MagicGarden
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 17/07/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var assetName:String  = "bola"
    var scene: SCNScene?
    fileprivate var nodeModel: SCNNode?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]

        
//        scene = SCNScene(named: "art.scnassets/scene.scn")!
        
//        let node = scene?.rootNode.childNode(withName: assetName, recursively: true)

//         nodeModel = createSceneNodeForAsset(assetName, assetPath: "art.scnassets/scene2.scn")
        // Set the scene to the view
       // sceneView.scene = scene!
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func createSceneNodeForAsset(_ assetName: String, assetPath: String) -> SCNNode? {
        guard let paperPlaneScene = SCNScene(named: assetPath) else {
            return nil
        }
        let newNode = paperPlaneScene.rootNode.childNode(withName: assetName, recursively: true)
        return newNode
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
        // Prevent the screen from being dimmed after a while.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start a new session
        self.startNewSession()
    }
    
    
    func startNewSession() {
        
        // Create a session configuration with horizontal plane detection
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView) else { return }
        
   
        
        if let nodeExists = sceneView.scene.rootNode.childNode(withName: assetName, recursively: true) {
            nodeExists.removeFromParentNode()
        }
        
        let hitResultsFeaturePoints: [ARHitTestResult] =
            sceneView.hitTest(location, types: .featurePoint)
        
        if let hit = hitResultsFeaturePoints.first {
            let anchor = ARAnchor(transform: hit.worldTransform)
            print("anchor \(anchor)")
            
            sceneView.session.add(anchor: anchor)
        }
      
//        if let hit = hitResultsFeaturePoints.first {
//            let finalTransform = hit.worldTransform
//            let anchor = ARAnchor(transform: finalTransform)
//            sceneView.session.add(anchor: anchor)
//        }
//
//        if let hit = sceneView.hitTest(location, types: .featurePoint).first {
//            let transformHit = hit.worldTransform
//            let pointTranslation = transformHit.translation
//            let nodeModel = scene?.rootNode.childNode(withName: assetName, recursively: true)
//            nodeModel?.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
//            sceneView.scene.rootNode.addChildNode(nodeModel!)
//
//
//        }
        
        

    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            guard let scene = SCNScene(named: "art.scnassets/scene.scn") else {
                //return nil
                return
            }
            let node = scene.rootNode.childNode(withName: "Fence", recursively: true)!
            
            node.simdTransform = anchor.transform
            //node.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
            //            //node.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            sceneView.scene.rootNode.addChildNode(node)
            
        }
    }
    

    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
