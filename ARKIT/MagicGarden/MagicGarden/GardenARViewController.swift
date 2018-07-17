//
//  GameARViewController.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 13/07/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import UIKit
import ARKit

class GardenARViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.showsStatistics = true
        sceneView.delegate = self

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func startNewSession() {
        
        // Create a session configuration with horizontal plane detection
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
}

extension GardenARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
           
            guard let scene = SCNScene(named: "art.scnassets/ship.scn") else {
                //return nil
                return
            }
            let node = scene.rootNode.childNode(withName: "ship", recursively: true)!
            
            node.simdTransform = anchor.transform
            
            sceneView.scene.rootNode.addChildNode(node)
            
        }
    }
}


