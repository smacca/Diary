//
//  CaptureViewController.swift
//  Diary
//
//  Created by Shaun McCarthy on 10/6/19.
//  Copyright © 2019 Shaun McCarthy. All rights reserved.
//

import UIKit
import MobileCoreServices


class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageCaptureView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    
    let processor = ScaledElementProcessor()
    var frameSublayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Notifications to slide the keyboard up
        NotificationCenter.default.addObserver(self, selector: #selector(CaptureViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CaptureViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        imageCaptureView.layer.addSublayer(frameSublayer)
        drawFeatures(in: imageCaptureView)
    }
    
    // Access camera and take a photo
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Camera Not Available", message: "A camera is not available. Please try picking an image from the image library instead.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: Keyboard slide up
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    private func removeFrames() {
        guard let sublayers = frameSublayer.sublayers else { return }
        for sublayer in sublayers {
            sublayer.removeFromSuperlayer()
        }
    }
    
    // 1
    private func drawFeatures(in imageView: UIImageView, completion: (() -> Void)? = nil) {
        removeFrames()
        processor.process(in: imageView) { text, elements in
            elements.forEach() { element in
                self.frameSublayer.addSublayer(element.shapeLayer)
            }
        }
    }
}

extension CaptureViewController: UIPopoverPresentationControllerDelegate {
    // MARK: UIImagePickerController
    
    private func presentImagePickerController(withSourceType sourceType: UIImagePickerController.SourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        controller.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage =
            info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageCaptureView.contentMode = .scaleAspectFit
            let fixedImage = pickedImage.fixOrientation()
            imageCaptureView.image = fixedImage
            drawFeatures(in: imageCaptureView)
        }
        dismiss(animated: true, completion: nil)
    }
    

}
