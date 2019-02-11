//
//  ViewController.swift
//  Untitled
//
//  Created by Jubril on 22/01/2019.
//  Copyright © 2019 HelloWorld. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Spring

class GalleryViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var closeButton: SpringButton!
    @IBOutlet var sceneView: ARSCNView!
    var showingCloseButton: Bool = true
    
    //MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let triggerImages = ARReferenceImage.referenceImages(inGroupNamed: "gallery", bundle: nil)!
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = triggerImages
        configuration.maximumNumberOfTrackedImages = 20

        // Run the view's session
        sceneView.session.run(configuration)
        HideInstructions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        if (self.isMovingFromParent) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
    
    @objc func canRotate() -> Void {}
    
    //MARK: Actions
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        if !showingCloseButton {
            showCloseButton()
            showingCloseButton = true
        }
        else {
            hideCloseButton()
            showingCloseButton = false

        }
    }
    
    @IBAction func onCloseButtonTap(_ sender: SpringButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func showCloseButton() {
        closeButton.animation = "fadeIn"
        closeButton.animate()
    }
    
    func hideCloseButton() {
        closeButton.animation = "fadeOut"
        closeButton.animate()
    }
    
    func HideInstructions() {
        delay(delay: 4) {
            UIView.animate(withDuration: 0.3) {
                self.visualEffectView.alpha = 0
            }
        }
    }
    
    func setupVideoOnNode(_ node: SCNNode, fromURL url: URL){
        
        //1. Create An SKVideoNode
        var videoPlayerNode: SKVideoNode!
        
        //2. Create An AVPlayer With Our Video URL
         let videoPlayer = AVPlayer(url: url)
        
        //3. Intialize The Video Node With Our Video Player
        videoPlayerNode = SKVideoNode(avPlayer: videoPlayer)
        videoPlayerNode.yScale = -1
        
        //4. Create A SpriteKitScene & Postion It
        let spriteKitScene = SKScene(size: CGSize(width: 600, height: 300))
        spriteKitScene.scaleMode = .aspectFit
        videoPlayerNode.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
        videoPlayerNode.size = spriteKitScene.size
        spriteKitScene.addChild(videoPlayerNode)
        spriteKitScene.scaleMode = .aspectFit
        
        //6. Set The Nodes Geoemtry Diffuse Contenets To Our SpriteKit Scene
        node.geometry?.firstMaterial?.diffuse.contents = spriteKitScene
        
        //5. Play The Video
        videoPlayer.volume = 0
        videoPlayer.play()
        
        
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem, queue: nil)
            { notification in
                videoPlayer.seek(to: CMTime.zero)
                videoPlayer.play()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //1. Check We Have An ARImageAnchor And Have Detected Our Reference Image
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage

        //2. Get The Physical Width & Height Of Our Reference Image
        let width = CGFloat(referenceImage.physicalSize.width)
        let height = CGFloat(referenceImage.physicalSize.height)
        
        //3. Create An SCNNode To Hold Our Video Player With The Same Size As The Image Target
        let videoHolder = SCNNode()
        let videoHolderGeometry = SCNPlane(width: width, height: height)
        videoHolder.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        videoHolder.geometry = videoHolderGeometry
        
        //4. Create Our Video Player
        
        if let videoURL = Bundle.main.url(forResource: referenceImage.name!, withExtension: "mp4"){
            setupVideoOnNode(videoHolder, fromURL: videoURL)
        }
        
        //5. Add It To The Hierarchy
        node.addChildNode(videoHolder)
        
    }
}
