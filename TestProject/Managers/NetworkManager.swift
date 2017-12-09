//
//  NetworkManager.swift
//  TestProject
//
//  Created by zagid on 08.12.17.
//  Copyright © 2017 zagid. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Topic {
    var name: String?
    var slug: String?
}

class NetworkManager {
    let baseURL = "https://api.producthunt.com/v1/"
    let accessToken = "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
    
    func loadTopics(completion: @escaping ([Topic]?, String?) -> ()) {
        var topics: [Topic] = []
        
        let topicsURL = baseURL + "topics"
        guard let url = URL(string: topicsURL) else { return }
        
        let params = [ "access_token": accessToken ]
        
        Alamofire.request(url, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                let jsonTopics = json["topics"].arrayValue
                
                for jsonTopic in jsonTopics {
                    let name = jsonTopic["name"].string
                    let slug = jsonTopic["slug"].string
                    
                    let topic = Topic(name: name, slug: slug)
                    topics.append(topic)
                }
                
                completion(topics, nil)
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func loadPosts(from topic: Topic, completion: @escaping ([Product]?, String?) -> ()) {
        var products: [Product] = []
        
        let postsURL = baseURL + "posts/all"
        guard let url = URL(string: postsURL) else { return }
        guard let slug = topic.slug else { return }
        
        let params = [
            "access_token": accessToken,
            "search[category]": slug
        ]
        
        Alamofire.request(url,  parameters: params).responseJSON { response in
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                let jsonProducts = json["posts"].arrayValue
                
                for jsonProduct in jsonProducts {
                    let name = jsonProduct["name"].string
                    let description = jsonProduct["tagline"].string
                    let upvotes = jsonProduct["votes_count"].int
                    let imageURL = jsonProduct["thumbnail"]["image_url"].url
                    let screenshotURL = jsonProduct["screenshot_url"]["850px"].url
                    let url = jsonProduct["discussion_url"].url
                    
                    let product = Product(name: name, imageURL: imageURL, screenshotURL: screenshotURL, description: description, upvotes: upvotes, url: url)
                    products.append(product)
                }
                
                completion(products, nil)
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
