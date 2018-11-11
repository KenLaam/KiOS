//
//  ViewController.swift
//  KCamera
//
//  Created by Ken Lâm on 11/7/18.
//  Copyright © 2018 KPU. All rights reserved.
//

import UIKit
import SCRecorder

class ViewController: UIViewController {

    @IBOutlet weak var btnRecord: UIButton!
    
    var recorder: SCRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configRecorder()
    }
    
    func configUI() {
        btnRecord.addTarget(self, action: #selector(onTapBtn), for: .touchUpInside)
    }
    
    func configRecorder() {
        recorder = SCRecorder()
        recorder.captureSessionPreset = AVCaptureSession.Preset.hd1920x1080.rawValue
        recorder.device = .back
        recorder.autoSetVideoOrientation = true
        recorder.delegate = self
        recorder.session = SCRecordSession()
        
        let video = recorder.videoConfiguration
        video.enabled = true
        video.size = self.view.bounds.size
        video.timeScale = 1
        video.sizeAsSquare = false
        
        let audio = recorder.audioConfiguration
        audio.enabled = true
        
        let photo = recorder.photoConfiguration
        photo.enabled = false
        
        let filterBW = SCFilter(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "filter_black_white", ofType: "cisf")!))
        
//        video.filter = filterBW
        recorder.startRunning()
        recorder.previewView = self.view
    }


    @objc func onTapBtn() {
        btnRecord.isSelected.toggle()
        
        if btnRecord.isSelected {
            let session = SCRecordSession()
            session.fileType = AVFileType.mp4.rawValue
            recorder.session = session
            recorder.record()
        } else {
            recorder.pause {
                self.exportVideo(self.recorder.session!)
            }
        }
    }
    
    func exportVideo(_ session: SCRecordSession) {
        let duration = session.duration
        debugPrint(duration)
        session.mergeSegments(usingPreset: AVAssetExportPresetHighestQuality) { url, error in
            if error != nil {
                debugPrint("Cannot export \(error!)")
            } else {
                let saveOperation = SCSaveToCameraRollOperation()
                saveOperation.saveVideoURL(url, completion: { path, e in
                    if e != nil {
                        debugPrint("Error \(e!)")
                    } else {
//                        KPhoto.sharedInstance.save(url: URL(string: path!)!)
                    }
                })
            }
        }
//        let asset = session.assetRepresentingSegments()
//        let assetExport = SCAssetExportSession(asset: asset)
//        assetExport.outputUrl = session.outputUrl
//        assetExport.outputFileType = AVFileType.mp4.rawValue
//        assetExport.exportAsynchronously {
//            if assetExport.error != nil {
//                debugPrint("Error \(assetExport.error)")
//            } else {
//                debugPrint("Done")
//            }
//        }
    }
}

extension ViewController: SCRecorderDelegate {
    
}

