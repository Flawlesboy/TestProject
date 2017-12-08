//
//  ProductListModel.swift
//  TestProject
//
//  Created by zagid on 08.12.17.
//  Copyright © 2017 zagid. All rights reserved.
//

import Foundation

struct Product {
    var name: String?
    var imageURL: URL?
    var screenshotURL: URL?
    var description: String?
    var upvotes: Int?
}

protocol ProductListModelDelegate: class {
    func setup(topics: [Topic])
    func setup(products: [Product])
    func show(error: String)
}

class ProductListModel {
    let networkManager: NetworkManager
    weak var delegate: ProductListModelDelegate?
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func loadTopics() {
        networkManager.loadTopics { [weak self] topics, error in
            if let error = error {
                self?.delegate?.show(error: error)
            }
            
            if let topics = topics {
                self?.delegate?.setup(topics: topics)
            }
        }
    }
    
    func loadProducts(from topic: Topic) {
        networkManager.loadPosts(from: topic) { [weak self] products, error in
            if let error = error {
                self?.delegate?.show(error: error)
            }
            
            if let products = products {
                self?.delegate?.setup(products: products)
            }
        }
    }
}
