import UIKit
import SDWebImage
import BTNavigationDropdownMenu

class ProductListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedTopic: Topic!
    
    var model: ProductListModel?
    
    var products: [Product] = []
    
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        model = ProductListModel()
        model?.delegate = self
        model?.loadTopics()
    }
    
    func startRefreshing() {
        self.tableView.refreshControl?.beginRefreshing()
        self.tableView.setContentOffset(CGPoint(x: 0, y: -self.refreshControl.frame.size.height), animated: true)
    }
    
    @objc func refreshData() {
        if let topic = selectedTopic {
            model?.loadProducts(from: topic)
        }
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
        cell.descriptionLabel.text = product.description
        
        if let upvotes = product.upvotes {
            cell.upvotesLabel.text = "Upvotes: \(upvotes)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        
        let productVC = UIStoryboard(name: "ProductViewController", bundle: nil).instantiateInitialViewController() as! ProductViewController
        let model = ProductModel(product: product)
        productVC.model = model
        
        navigationController?.pushViewController(productVC, animated: true)
    }
}

extension ProductListViewController: ProductListModelDelegate {
    func setup(products: [Product]) {
        self.products = products
        
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
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
            self?.selectedTopic = topic
            self?.model?.loadProducts(from: topic)
            self?.startRefreshing()
        }
        
        self.navigationItem.titleView = menuView
        self.selectedTopic = Topic(name: "Tech", slug: "tech")
        self.model?.loadProducts(from: selectedTopic)
        self.startRefreshing()
    }
    
    func show(error: String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
