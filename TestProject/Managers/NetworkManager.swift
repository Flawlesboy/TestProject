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
    
    func loadTopics() {
        var topics: [Topic] = []
        
        let topicsURL = baseURL + "topics"
        guard let url = URL(string: topicsURL) else { return }
        
        let params: [String: String] = [ "access_token": accessToken ]
        
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
                print(topics)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
