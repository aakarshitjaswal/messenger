//
//  StorageManager.swift
//  Messenger
//
//  Created by Aakarshit Jaswal on 18/03/22.
//

import Foundation
import FirebaseStorage

typealias UploadPictureResult = (Result<String, Error>) -> Void

class StorageManager {
    //Creating storageManager singleton
    static let storageManager = StorageManager()
    
    //Creating referance to instance of FIRStorage
    let storage = Storage.storage().reference()
    
    ///Uploads profile picture to the firebase storage and returns completion with url string to download
    func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureResult) {
        storage.child("image/\(fileName)").putData(data, metadata: nil) { storageMetaData, error in
            guard error == nil else {
                print("Couldn't Upload file")
                return
            }
            
            //Getting the download URL
            self.storage.child("image/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    print("Error fetching the download URL")
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                //passing the urlstring into completion
                completion(.success(urlString))
                
            }
        }
    }
    
    //Download Firebase reference URL
    func downloadURL(for path: String, completion: @escaping (Result<URL,Error>) -> Void) {
        let reference = storage.child(path)
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadURL))
                return
            }
            
            completion(.success(url))
        }
    }
    
    //Download the image with url and set imageView as image
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("error occured while downloading the image data ")
                return
            }
            print(data)
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }.resume()
    }

}

//error enum for storage
enum StorageErrors: Error {
    case failedToUpload
    case failedToGetDownloadURL
}

