//  DBService+Posts.swift
//  POSTR
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation
import UIKit
import Firebase


extension DBService {
    //    public func addPosts(caption: String, category: String, postImageStr: String, userImageStr: String, image: UIImage) {
    public func addPost(caption: String, category: String, postImageStr: String, userImageStr: String) {
        let childByAutoId = DBService.manager.getPosts().childByAutoId()
        childByAutoId.setValue(["postID"        : DBService.manager.getPosts().childByAutoId().key,
                                "userID"        : AuthUserService.getCurrentUser()!.uid,
                                "caption"       : caption,
                                "category"      : category,
                                "date"          : formatDate(with: Date()),
                                "username"      : AuthUserService.getCurrentUser()!.displayName!,
                                "numOfComments" : 0,
                                "upvoteCount"   : 0,
                                "downvoteCount" : 0,
                                "currentVotes"  : 0,
                                "postImageStr"  : postImageStr,
                                "userImageStr"  : userImageStr,
                                "postFlagCount" : 0]) { (error, dbRef) in
                                    if let error = error {
                                        print("addPosts error: \(error)")
                                    } else {
                                        print("posts added @ database reference: \(dbRef)")
                                        // add an image to storage
                                        // StorageService.manager.storeImage(image: image, postId: childByAutoId.key)
                                        // TODO: add image to database
                                    }
        }
    }
    
    func loadAllPosts(completionHandler: @escaping ([Post]?) -> Void) {
        let ref = DBService.manager.getPosts()
        ref.observe(.value) { (snapshot) in
            var allPosts = [Post]()
            for child in snapshot.children {
                let dataSnapshot = child as! DataSnapshot
                if let dict = dataSnapshot.value as? [String: Any] {
                    let post = Post.init(dict: dict)
                    allPosts.append(post)
                }
            }
            completionHandler(allPosts)
        }
    }
    
    func loadUserPosts(userID: String, completionHandler: @escaping ([Post]?) -> Void) {
        let ref = DBService.manager.getPosts()
        ref.observe(.value) { (snapshot) in
            var userPosts = [Post]()
            for child in snapshot.children {
                let dataSnapshot = child as! DataSnapshot
                if let dict = dataSnapshot.value as? [String: Any] {
                    let post = Post.init(dict: dict)
                    if userID == post.userID {
                        userPosts.append(post)
                    }
                }
            }
            completionHandler(userPosts)
        }
    }
    
}
