//
//  ProductViewController.swift
//  TestProject
//
//  Created by zagid on 08.12.17.
//  Copyright © 2017 zagid. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices

class ProductViewController: UIViewController {
    
    @IBOutlet weak var screenshotImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var model: ProductModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.delegate = self
        model?.loadProduct()
    }
    
    @IBAction func getitAction(_ sender: Any) {
        model?.openProductSite()
    }
}

extension ProductViewController: ProductModelDelegate {
    func open(url: URL) {
        let sfc = SFSafariViewController(url: url)
        self.present(sfc, animated: true, completion: nil)
    }
    
    func setup(product: Product) {
        self.screenshotImageView.sd_setImage(with: product.screenshotURL)
        self.nameLabel.text = product.name
        self.descriptionLabel.text = product.description
        
        if let upvotes = product.upvotes {
            self.upvotesLabel.text = "Upvotes: \(upvotes)"
        }
    }
}
