//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Trevor Bursach on 10/6/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    //MARK: - Properties
    
    var post: Post? {
        didSet {
            func updateViews() {
                guard let post = post else { return }
                DispatchQueue.main.async {
                    self.postImageView.image = post.postPhoto
                    self.captionLabel.text = post.caption
                    self.commentLabel.text = "Comments: \(post.comments.count)"
                }
            }
        }
    }
    

} // END OF CLASS

extension PostTableViewCell: PhotoSelectorDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        self.postImageView.image = image
    }
}
