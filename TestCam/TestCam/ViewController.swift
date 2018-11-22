//
//  ViewController.swift
//  TestCam
//
//  Created by Ken Lâm on 11/21/18.
//  Copyright © 2018 kenk11. All rights reserved.
//

import UIKit
import GPUImage
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var renderView: RenderView!
    var camera:Camera!
    var isRecording = false
    var movieOutput:MovieOutput? = nil
    var fileURL:URL!
    let lookUpFilter = LookupFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            camera = try Camera(sessionPreset: AVCaptureSession.Preset.hd1920x1080)
            camera.runBenchmark = true
//            lookUpFilter.intensity = 1
//            lookUpFilter.lookupImage = PictureInput(imageName: "lookup_amaro")
            lookUpFilter.lookupImage = PictureInput(imageName: "lookup_none")
            camera --> lookUpFilter --> renderView
            camera.startCapture()
        } catch {
            fatalError("Could not initialize rendering pipeline: \(error)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func capture(_ sender: AnyObject) {
        if (!isRecording) {
            do {
                self.isRecording = true
                let documentsDir = try FileManager.default.url(for:.documentDirectory, in:.userDomainMask, appropriateFor:nil, create:true)
                fileURL = URL(string:"test.mp4", relativeTo:documentsDir)!
                do {
                    try FileManager.default.removeItem(at:fileURL)
                } catch {
                }
                
                movieOutput = try MovieOutput(URL:fileURL, size:Size(width:480, height:640), liveVideo:true)
                camera.audioEncodingTarget = movieOutput
                lookUpFilter --> movieOutput!
                movieOutput!.startRecording()
                DispatchQueue.main.async {
                    // Label not updating on the main thread, for some reason, so dispatching slightly after this
                    (sender as! UIButton).titleLabel!.text = "Stop"
                }
            } catch {
                fatalError("Couldn't initialize movie, error: \(error)")
            }
        } else {
            movieOutput?.finishRecording{
                self.isRecording = false
                DispatchQueue.main.async {
                    (sender as! UIButton).titleLabel!.text = "Record"
                }
                self.camera.audioEncodingTarget = nil
                self.movieOutput = nil
                self.saveVideo(fileURL: self.fileURL.absoluteURL)
            }
        }
    }
    
    func saveVideo(fileURL:URL) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }) { saved, error in
            if saved {
                debugPrint("Done")
            }
        }
    }
    
    @IBAction func onTapFilter1(_ sender: Any) {
        lookUpFilter.lookupImage = PictureInput(imageName: "lookup_amaro")
    }
    
    @IBAction func onTapFilter2(_ sender: Any) {
        lookUpFilter.lookupImage = PictureInput(imageName: "lookup_bw")
    }
    
    
}

