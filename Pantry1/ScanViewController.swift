//
//  ScanViewController.swift
//  Pantry1
//
//  Created by Dennis Wong on 12/8/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import AVFoundation
import UIKit
import Photos

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // MARK: Properties
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var messageLabel: UILabel!
    
    var barcodes = [Barcode]()
    
    // MARK: Camera properties
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]

    /* scanned barcode and product id values */
    var barcodeValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the barcodes table from Pantry DB
        if let savedBarcodes = Barcode.loadBarcodesFromDB() {
            barcodes += savedBarcodes
        }
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            
            // Set the input devie on the capture session
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the callback
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the videoPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Move the top bar and message layer to the front
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: topBar)
            
            // Initialize the QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
        } catch {
            // If any error occurs, simply print it and don't continue
            print(error)
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR/barcode is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                barcodeDetected(metadataObj.stringValue)
            }
        }
    }
    
    func barcodeDetected(_ code: String) {
        // Remove the spaces.
        let trimmedCode = code.trimmingCharacters(in: .whitespaces)
        
        // EAN or UPC?
        // Check for added "0" at beginning of code.
        let trimmedCodeString = "\(trimmedCode)"
        
        if trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1 {
            barcodeValue = String(trimmedCodeString.characters.dropFirst())
        } else {
            barcodeValue = trimmedCodeString
        }

        // search the barcode in DB
        let productId = Barcode.findProductIdByBarcode(value: barcodeValue!)
        let product = Product.findProductById(id: productId)
        var alertMessage: String? = nil
        var alertTitle: String? = nil
        var okAction = UIAlertAction()
        
        if product != nil {
            let brand = product?.brand
            let name = product?.name
            print("Found " + brand! + " " + name!)
            
            // Product found, need to add the product to inventory
            alertMessage = (brand! + " " + name!)
            alertTitle = "Found a Product!"
            okAction = UIAlertAction(title: "Update Inventory", style: .default, handler: { action in
                self.performSegue(withIdentifier: "ScanAddItem", sender: self)
            })
        }
        else {
            // Product NOT found, add new product if desired
            alertMessage = barcodeValue
            alertTitle = "Found a Barcode!"
            okAction = UIAlertAction(title: "Add New Product", style: .default, handler: { action in
                self.performSegue(withIdentifier: "ScanAddProduct", sender: self)
            })
        }
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: { action in
            
            // TODO: understand what this line is for
            guard self.navigationController?.popViewController(animated: true) != nil
                else {
                    print("No navigation controller")
                    return;
                }
        })
        
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        messageLabel.text = barcodeValue
        
        // Vibrate the device to give the user some feedback.
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    
    // MARK: - Navigation
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated:true, completion:nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let productId = Barcode.findProductIdByBarcode(value: barcodeValue!)
        let barcode = Barcode(barcode: barcodeValue!, type: "", productId: productId)
        if segue.identifier == "ScanAddItem" {
            let nextViewController = segue.destination as! AddItemViewController
            nextViewController.barcode = barcode
        }
        else {
            let nextViewController = segue.destination as! AddProductViewController
            nextViewController.barcode = barcode
        }
    }
    

}
