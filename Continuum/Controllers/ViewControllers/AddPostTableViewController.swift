//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Trevor Bursach on 10/6/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var addCaptionTextField: UITextField!
    
    //MARK: - Properties
    
    let imagePicker = UIImagePickerController()
    var image: UIImage?
    
    //MARK: - Lifecycle Functions
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        addCaptionTextField.text = ""
    }
    
    //MARK: - Actions
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        guard let caption = addCaptionTextField.text, !caption.isEmpty else { return }
        
        PostController.shared.savePost(with: caption, postPhoto: image) { (result) in
            switch result {

            case .success(let post):
                guard let post = post else { return }
                PostController.shared.posts.insert(post, at: 0)
                self.updateViews()
            case .failure(let error):
                print("==========Error==========")
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                print("==========Error==========")
            }
        }
        
//        PostController.shared.createPostWith(postPhoto: image, caption: caption) { (result) in
//            switch result {
//
//            case .success(let post):
//                guard let post = post else { return }
//                PostController.shared.posts.insert(post, at: 0)
//                self.updateViews()
//            case .failure(let error):
//                print("==========Error==========")
//                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                print("==========Error==========")
//            }
//        }
        
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func cancelPostButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPickerVC" {
            let destinationVC = segue.destination as? PhotoSelectorViewController
            destinationVC?.delegate = self
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
} // END OF CLASS

extension AddPostTableViewController: PhotoSelectorDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        self.image = image
    }
}
