//
//  ProductModel.swift
//  TestProject
//
//  Created by zagid on 08.12.17.
//  Copyright © 2017 zagid. All rights reserved.
//

import Foundation

protocol ProductModelDelegate: class {
    func setup(product: Product)
    func open(url: URL)
}

class ProductModel {
    weak var delegate: ProductModelDelegate?
    
    var product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    func loadProduct() {
        delegate?.setup(product: product)
    }
    
    func openProductSite() {
        guard let url = product.url else { return }
        delegate?.open(url: url)
    }
}
