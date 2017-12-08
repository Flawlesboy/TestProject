import UIKit
import SDWebImage
import BTNavigationDropdownMenu

class ProductListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var model: ProductListModel?
    
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = ProductListModel()
        model?.delegate = self
        model?.loadTopics()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let product = products[indexPath.row]
        cell.productImageView.sd_setImage(with: product.imageURL, completed: nil)
        cell.nameLabel.text = product.name
        cell.productDescription.text = product.description
        
        if let upvotes = product.upvotes {
            cell.upvotesLabel.text = "Upvotes: \(upvotes)"
        }
        
        return cell
    }
}

extension ProductListViewController: ProductListModelDelegate {
    func setup(products: [Product]) {
        self.products = products
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func setup(topics: [Topic]) {
        let items = topics.flatMap({ $0.name })
        
        let menuView = BTNavigationDropdownMenu(title: "Tech", items: items)
        menuView.arrowTintColor = .black
        menuView.animationDuration = 0.1
        
        menuView.didSelectItemAtIndexHandler = { [weak self] indexPath in
            let topic = topics[indexPath]
            self?.model?.loadProducts(from: topic)
        }
        
        self.navigationItem.titleView = menuView
        self.model?.loadProducts(from: Topic(name: nil, slug: "tech"))
    }
    
    func show(error: String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
