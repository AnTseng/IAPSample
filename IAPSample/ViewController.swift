//
//  ViewController.swift
//  IAPSample
//
//  Created by Ann on 2020/11/9.
//

/*
 Consumable(消耗的)
 可重覆購買的項目，比方 LINE 的虛擬金幣，養魚 App 的魚飼料等。

 Non-Consumable(不可消耗的)
 不可重覆購買的項目，比方購買 Taylor Swift 的單曲 love story。

 Auto-Renewable Subscription(自動訂閱)
 依時間收費，比方每個月$90，下個月到期時會自動續約扣款。(不過使用者自己也可另外取消自動訂閱)
 
 Non-Renewing Subscription(非自動訂閱)
 依時間收費，跟 Auto-Renewable Subscription 的差別在於它不會自動訂閱。
 */

import UIKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        return UITableView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        IAPManager.shared.getProducts()
        IAPManager.shared.delegate = self
        setUI()
        // 註冊 cell
        tableView.register(
          UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setUI() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension ViewController: IAPManagerDelegate {
    func getItems() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        guard IAPManager.shared.products.indices.contains(index) else { return }
        IAPManager.shared.buy(product: IAPManager.shared.products[index])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        IAPManager.shared.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        guard IAPManager.shared.products.indices.contains(indexPath.row) else { return cell }
        
        cell.textLabel?.text = IAPManager.shared.products[indexPath.row].localizedTitle
        return cell
    }
}
