//
//  ViewController.swift
//  Object Detection
//
//  Created by Rudra Jikadra on 11/12/17.
//  Copyright © 2017 Rudra Jikadra. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var belowView: UIView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var below: UIView!
    @IBOutlet weak var objectName: UILabel!
    @IBOutlet weak var accuracy: UILabel!
    
    @IBOutlet weak var switchToggle: UISwitch!
    var mlModel = Resnet50().model
    @IBOutlet weak var switchText: UILabel!
    @IBOutlet weak var above: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        //camera
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        // camera is created
        
        switchText.alpha = 1
        switchText.clipsToBounds = true
        switchText.layer.cornerRadius = 10
        view.addSubview(belowView)
        view.addSubview(above)
        
        UIView.animate(withDuration: 2) {
            self.switchText.alpha = 0
        }
        
        let  dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
                
    }
    
    @IBAction func switchModel(_ sender: Any) {
        
        if switchToggle.isOn {
            mlModel = hand().model
            
            switchText.text = "Turn Off For Object ML Model"
            UIView.animate(withDuration: 1.5, animations: {
                self.switchText.alpha = 1
            }, completion: { (animate) in
                UIView.animate(withDuration: 1.5) {
                    self.switchText.alpha = 0
                }
            })
            
        } else {
            mlModel = Resnet50().model
            
            switchText.text = "Turn On For Hand ML Model"
            UIView.animate(withDuration: 1.5, animations: {
                self.switchText.alpha = 1
            }, completion: { (animate) in
                UIView.animate(withDuration: 1.5) {
                    self.switchText.alpha = 0
                }
            })
        }
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for:  mlModel) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            let firstob: Int = Int(firstObservation.confidence * 100)
            let fobstr: String  = "\(firstob)%"
            
            DispatchQueue.main.async(){
                self.objectName.text = firstObservation.identifier
                self.accuracy.text = String(fobstr)
            }
//            print(firstObservation.identifier, firstObservation.confidence)
        }

        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    


}

