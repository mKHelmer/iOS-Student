//
//  PostController.swift
//  Post
//
//  Created by Soul Master on 11/18/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation
class PostController {
    //create a PostController class
    //add a constant baseURL for the /posts/ subdirectory. this url will be used to build other urls throughout the app.
    
    let baseURL = URL(string: "http://devmtn-posts.firebaseio.com/posts")
    
    //MARK: - PROPERTIES
    //source of truth - add a posts property that will hold the Post objects that you pull and decode from the API
    
    var posts: [Post] = []
    
    //MARK: URLREQUEST
    
    ///globally accessible function for fetching Post objects
    //add amethod fetchPosts that provides a completion closure
    func fetchPosts(completion: @escaping (Result<[Post], PostError>) -> Void) {
        guard let unwrappedURL = baseURL else { completion(.failure(.invalidURL)); return }
        let getterEndpoint = unwrappedURL.appendingPathExtension("json")
        //create an instance of URLRequest and give it the getterEndpoint(set the requests's httpMethod and httpBody) the httpBody and httpMethod are used to tell the API what we are going to do with URLSessonDataTask. GET is used to receive the JSON data from the API
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        //create an instance of URLSessionDataTask. This method will make the network call and call the copletion closer with the Data?,URLResponse? and Error? results.
        URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.communicationError))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                //Call decode(from:) on your instance of the JSONDecoder. You will need to assign the return of this function to a constant named postsDictionary. This function takes in two arguments: a type [String:Post].self, and your instance of data that came back from the network request. This will decode the data into a [String:Post] (a dictionary with keys being the UUID that they are stored under on the database as you will see by inspecting the json returned from the network request, and values which should be actual instances of post).
                let decoder = JSONDecoder()
                let postsDictionary = try decoder.decode([String: Post].self, from: data)
                var posts = postsDictionary.compactMap({ $0.value })
                posts.sort(by:{ $0.timestamp > $1.timestamp})
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.unableToDecode))
            }
            
        }).resume()
    
    }//find a way to loop through the dictionary and return an array
    
}
enum PostError: LocalizedError {
    case invalidURL
    case communicationError
    case noData
    case noPosts
    case unableToDecode
}
