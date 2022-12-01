//
//  DataService.swift
//  iGram
//
//  Created by Alexandr Kozin on 01.12.2022.
//

// Used to handle upload and download data (other than User) from our Database
import Foundation
import SwiftUI
import FirebaseFirestore

class DataService {
    
    // MARK: PROPERTIES
    
    static let instance = DataService()
    
    private var REF_POSTS = DB_BASE.collection("posts")
    
    // MARK: CREATE FUNCTION
    
    func uploadPost(image: UIImage, caption: String?, displayName: String, userID: String, handler: @escaping (_ success: Bool) -> ()) {
        
        // Create new post document
        let document = REF_POSTS.document()
        let postID = document.documentID
        
        // Upload image to Storage
        ImageManager.instance.uploadPostImage(postID: postID, image: image) { (success) in
            
            if success {
                // Successfully uploaded image data to Storage
                // Now upload post data to Database
                
                let postData: [String: Any] = [
                    DatabasePostField.postID: postID,
                    DatabasePostField.userID: userID,
                    DatabasePostField.displayName: displayName,
                    DatabasePostField.caption: caption,
                    DatabasePostField.dateCreated: FieldValue.serverTimestamp(),
                ]
                
                document.setData(postData) { (error) in
                    if let error = error {
                        print("Error uploading data to post document. \(error)")
                        handler(false)
                        return
                    } else {
                        // return back to the app
                        handler(true)
                        return
                    }
                }
            } else {
                print("Error uploading post image to Firebase")
                handler(false)
                return
            }
            
        }
        
    }
    
}
