//
//  QRScannerViewController.swift
//  QRCodeReader
//
//  Created by Jakub Iwaszek on 19/04/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetUp()
        let captureSession = AVCaptureSession()
        //RealmDb.init()
        //let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get to the back phone camera")
            return
        }
        
        /*guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get to the back phone camera")
            return
        }*/
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
            
        } catch {
            print(error)
            return
        }

        // Do any additional setup after loading the view.
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var alert: UIAlertController!
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        //if metadataObj.type == AVMetadataObject.ObjectType.qr {
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        qrCodeFrameView?.frame = barCodeObject!.bounds
        if metadataObj.stringValue != nil {
            alert = UIAlertController(title: "Code", message: metadataObj.stringValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (action) in
                UIPasteboard.general.string = metadataObj.stringValue
            }))
            
            if !(self.navigationController?.visibleViewController?.isKind(of: UIAlertController.self))!{
                print("aa")
                self.present(alert, animated: true) {
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    print("once")
                    let newScannedCode = ScannedCode(metadata: metadataObj.stringValue!, date: Date())
                    RealmDb.shared.addNewScannedCode(newScannedCode: newScannedCode)
                }
            }
            
        }
        //}
        
    }
    
    func buttonSetUp() {
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        button.setTitleColor(UIColor(red: 0.9098, green: 0.4392, blue: 0, alpha: 1.0), for: .normal)
        button.setTitle("History", for: .normal)
        button.addTarget(self, action: #selector(historyClickedButton), for: .touchUpInside)
        navigationItem.titleView = button
    }
    
    @objc func historyClickedButton() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CodesHistoryTableViewController") as! CodesHistoryTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
