//
//  AddTweetViewController.swift
//  PlatziTweets
//
//  Created by Resonant Sports on 25/02/2021.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift

class AddTweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var addTweetButton: UIButton!
    @IBOutlet weak var imageViewPreview: UIImageView!
    
    private var imagePicker: UIImagePickerController?
    
    @IBAction func addTweetAction() {
        saveTweet()
    }
    
    @IBAction func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openCamera() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTweetButton.layer.cornerRadius = 25
    }

    private func saveTweet() {
        if tweetTextView.text.isEmpty {
            NotificationBanner(title: "Error", subtitle: "Debes completar el mensaje para tweetear.", style: .warning).show()
        } else {
            let request = PostRequest(text: tweetTextView.text, imageUrl: nil, videoUrl: nil, location: nil)
            
            SVProgressHUD.show()
            
            SN.post(endpoint: Endpoints.post, model: request) { (response: SNResultWithEntity<Post, ErrorResponse>) in
                SVProgressHUD.dismiss()
                
                switch response {
                    case .success:
                        self.dismiss(animated: true, completion: nil)
                    
                    case .errorResult(let entity):
                        NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
                        
                    case .error(let error):
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                }
                
            }
        }
    }
}

extension AddTweetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker?.dismiss(animated: true, completion: nil)
        
        if info.keys.contains(.originalImage) {
            imageViewPreview.isHidden = false
            imageViewPreview.image = info[.originalImage] as? UIImage
        }
    }
}
