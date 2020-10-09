//
//  PostController.swift
//  Continuum
//
//  Created by Trevor Bursach on 10/6/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class PostController {
    
    //MARK: - Singleton
    
    static var shared = PostController()
    
    //MARK: - Properties
    
    var posts: [Post] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func savePost(with caption: String, postPhoto: UIImage?, completion: @escaping (Result<Post?, PostError>) -> Void) {
        
        let newPost = Post(caption: caption, postPhoto: postPhoto)
        let postRecord = CKRecord(post: newPost)
        publicDB.save(postRecord) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let savedPost = Post(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
            
            print("Saved Post successfully")
            completion(.success(savedPost))
        }
    }
    
    func addComment(text: String, post: Post, completion: @escaping (Result<Comment, PostError>) -> Void) {
        let newComment = Comment(text: text, post: post)
        let commentRecord = CKRecord(comment: newComment)
        publicDB.save(commentRecord) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let savedComment = Comment(ckRecord: record, post: post) else { return completion(.failure(.couldNotUnwrap)) }
            
            print("Saved Comment successfully")
            completion(.success(savedComment))
        }
        
    }
    
    func createPostWith(postPhoto: UIImage?, caption: String, completion: @escaping (Result<Post?, PostError>) -> Void) {
//        guard let image = image else { return }
        
        let newPost = Post(caption: caption, postPhoto: postPhoto)
        let postRecord = CKRecord(post: newPost)
        publicDB.save(postRecord) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
                  let savedPost = Post(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
            
            print("Saved Post successfully")
            completion(.success(savedPost))
        }
    }
    
    func fetchPosts(completion: @escaping (Result<[Post]?, PostError>) -> Void) {
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostStrings.recordTypeKey, predicate: fetchAllPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
            
            print("Fetched Posts successfully")
            let fetchedPosts = records.compactMap({Post(ckRecord: $0) })
            completion(.success(fetchedPosts))
        }
    }
    
    func fetchComments(for post: Post, completion: @escaping (Result<[Comment]?, PostError>) -> Void) {
        let postReference = post.recordID
        let predicate = NSPredicate(format: "%K == %@", CommentStrings.postReferenceKey, postReference)
        let commentIDs = post.comments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compountPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: "Comment", predicate: compountPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
            
            print("Fetched Comments successfully")
            let fetchedComments = records.compactMap({Comment(ckRecord: $0, post: post) })
            completion(.success(fetchedComments))
        }
    }
    
} // END OF CLASS
