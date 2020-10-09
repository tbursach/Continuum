//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Trevor Bursach on 10/6/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    //MARK: - Properties
    
    var post: Post? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    //MARK: - Actions
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        presentCommentAlert()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
//        let activityController = UIActivityViewController(activityItems: <#T##[Any]#>, applicationActivities: <#T##[UIActivity]?#>)
    }
    
    @IBAction func followPostButtonTapped(_ sender: Any) {
    }
    
    //MARK: - Helper Functions and Methods
    
    func updateViews() {
//        guard let post = post else { return }
        DispatchQueue.main.async {
            self.photoImageView.image = self.post?.postPhoto
            self.tableView.reloadData()
        }
    }
    
    func presentCommentAlert() {
        let alertController = UIAlertController(title: "Add Comment", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Add a comment..."
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
            
        }
        
        let cancelCommentAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        let addCommentAction = UIAlertAction.init(title: "Add Comment", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty,
                  let post = self.post else { return }
            
            PostController.shared.addComment(text: text, post: post) { (result) in
                switch result {

                case .success(_):
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
        alertController.addAction(cancelCommentAction)
        alertController.addAction(addCommentAction)
        
        present(alertController, animated: true)
    }
    
    @objc func loadData() {
        PostController.shared.fetchPosts { (result) in
            switch result {
            
            case .success(let post):
                guard let post = post else { return }
                PostController.shared.posts = post
                self.updateViews()
            case .failure(let error):
                print("==========Error==========")
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                print("==========Error==========")
            }
        }
        guard let post = post else { return }
        PostController.shared.fetchComments(for: post) { (result) in
            switch result {
            
            case .success(let comments):
                guard let comments = comments else { return }
                post.comments = comments
                self.updateViews()
            case .failure(let error):
                print("==========Error==========")
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                print("==========Error==========")
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post?.comments.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        let commentToDisplay = post?.comments[indexPath.row]
        cell.textLabel?.text = commentToDisplay?.text
        cell.detailTextLabel?.text = commentToDisplay?.timestamp.formatDate()
        
        return cell
    }


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

}

extension PostDetailTableViewController: PhotoSelectorDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        self.image = image
    }
}
