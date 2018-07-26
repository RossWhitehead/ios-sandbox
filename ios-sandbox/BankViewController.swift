//
//  BankViewController.swift
//  ios-sandbox
//
//  Created by Ross Whitehead on 21/07/2018.
//  Copyright © 2018 Ross Whitehead. All rights reserved.
//

import UIKit
import CouchbaseLiteSwift

class BankViewController: UIViewController {
    var replicator: Replicator?
    
    @IBOutlet weak var transactionsTableView: UITableView!
    
    var list = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test query
        let query = QueryBuilder
            .select(SelectResult.expression(Meta.id), SelectResult.all())
            .from(DataSource.database(DatabaseManager.instance.db!))
        
        let token = query.addChangeListener { (change) in
            for result in change.results! {
                let key =  result.string(at: 0)!
                print(key)
                let title = "Transaction" + key
                if(!self.list.contains(title)){
                    self.list.insert("Transaction" + result.string(at: 0)!, at: 0)
                }
                self.transactionsTableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BankViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "transactionCell")
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
}

extension BankViewController : UITableViewDelegate {
    
}

