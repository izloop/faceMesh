//
//  ViewController.swift
//  FaceMesh
//
//  Created by Izloop on 10/29/18.
//  Copyright © 2018 Izras Peter Levi Hornig. All rights reserved.
//

import UIKit
import ARKit

class FaceMeshViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //configuration to track face
        let configuration = ARFaceTrackingConfiguration()
        
        //run face tracking config using ARSession
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //pause AR session
        sceneView.session.pause()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face Tracking is not supported on this device!")
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        sceneView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
//declare that FaceMeshViewController implements ARSCNViewDelegate protocol
extension FaceMeshViewController: ARSCNViewDelegate {
    
    //define renderer(_:nodeFor:) method from protocol
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        //ensure the metal device used for rendering is NOT nil
        guard let device = sceneView.device else {
            return nil
        }
        
        //implement face geometry
        let faceGeometry = ARSCNFaceGeometry(device: device)
        
        //create scenekit node based on facegeometry
        let node = SCNNode(geometry: faceGeometry)
        
        //set fill mode to be just lines/mesh
        node.geometry?.firstMaterial?.fillMode = .lines
        
        //return node
        return node
    }
    //Define the didUpdate version of the renderer(_:didUpdate:for:) protocol method.
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {
        
        //Ensure the anchor being updated is an ARFaceAnchor and that the node’s geometry is an ARSCNFaceGeometry.
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        
        //Update the ARSCNFaceGeometry using the ARFaceAnchor’s ARFaceGeometry
        faceGeometry.update(from: faceAnchor.geometry)
    }
}
