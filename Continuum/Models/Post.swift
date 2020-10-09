//
//  Post.swift
//  Continuum
//
//  Created by Trevor Bursach on 10/6/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

struct PostStrings {
    static let recordTypeKey = "Post"
    fileprivate static let photoDataKey = "photoData"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let captionKey = "caption"
    fileprivate static let photoAssetKey = "photoAsset"
    
}

class Post {
    
    var photoData: Data?
    var timestamp: Date
    var caption: String
    var comments: [Comment]
    var postPhoto: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        }
        
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var recordID: CKRecord.ID
    var photoAsset: CKAsset? {
        get {
            guard let data = photoData else { return nil }
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try data.write(to: fileURL)
            } catch {
                print("==========Error==========")
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                print("==========Error==========")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(timestamp: Date = Date(), caption: String, comments: [Comment] = [], postPhoto: UIImage?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.timestamp = timestamp
        self.caption = caption
        self.comments = comments
        self.recordID = recordID
        self.postPhoto = postPhoto
    }
    
} // END OF CLASS

extension Post: SearchableRecord {
    func searchForWordThatMatches(searchTerm: String) -> Bool {
        
        if caption.contains(searchTerm){
            return true
        }
        for comment in comments {
            return comment.text.contains(searchTerm)
        }
        return false
    }
    
}

extension Post {
    convenience init?(ckRecord: CKRecord) {
        guard let caption = ckRecord[PostStrings.captionKey] as? String,
              let timestamp = ckRecord[PostStrings.timestampKey] as? Date else { return nil }

        var foundPhoto: UIImage?

        if let photoAsset = ckRecord[PostStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("==========Error==========")
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                print("==========Error==========")
            }
        }

        self.init(timestamp: timestamp, caption: caption, postPhoto: foundPhoto, recordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: PostStrings.recordTypeKey, recordID: post.recordID)
        
        setValuesForKeys([
            PostStrings.captionKey : post.caption,
            PostStrings.timestampKey : post.timestamp,
        ])
        
        if post.photoAsset != nil {
            setValue(post.photoAsset, forKey: PostStrings.photoAssetKey)
        }
    }
}
