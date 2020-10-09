//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Trevor Bursach on 10/6/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchPostsSearchBar: UISearchBar!
    
    //MARK: - Property
    
    var image: UIImage?
    var posts: [Post] = []
    var resultsArray: [Post] = []
    var isSearching: Bool = false
    var dataSource: [Post] {
        if isSearching == true {
            return resultsArray
        } else {
            return PostController.shared.posts
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchPostsSearchBar.delegate = self
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.resultsArray = PostController.shared.posts
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        let post = dataSource[indexPath.row]
        cell.post = post
        cell.captionLabel.text = post.caption
        cell.commentLabel.text = "Comments: \(post.comments.count)"
        cell.postImageView.image = post.postPhoto

        return cell
    }
    
    @objc func loadData() {
        PostController.shared.fetchPosts { (result) in
            switch result {
            
            case .success(let posts):
                guard let posts = posts else { return }
                PostController.shared.posts = posts
                self.updateViews()
            case .failure(let error):
                print("==========Error==========")
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                print("==========Error==========")
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? PostDetailTableViewController else { return }
            
            let selectedPost = dataSource[indexPath.row]
            destinationVC.post = selectedPost
        }
    }

} // END OF CLASS

extension PostListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsArray = PostController.shared.posts.filter({ $0.searchForWordThatMatches(searchTerm: searchText)})
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = PostController.shared.posts
        tableView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
        
    }
}

extension PostListTableViewController: PhotoSelectorDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        self.image = image
    }
}
