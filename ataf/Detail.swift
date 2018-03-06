//
//  Detail.swift
//  ataf
//
//  Created by ned on 06/03/2018.
//  Copyright © 2018 ned. All rights reserved.
//

import UIKit

class Detail: UITableViewController {
    
    var stop: BusStop = BusStop()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setTitle(title: self.stop.name, subtitle: "CODICE FERMATA: " + self.stop.node)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = tableViewBackgroundColor
        
        tableView.register(UINib(nibName: "TransitCell", bundle: nil), forCellReuseIdentifier: "transit")
        tableView.register(UINib(nibName: "TransitHeader", bundle: nil), forCellReuseIdentifier: "transit_header")
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.reloadRequest), for: .valueChanged)
        
        let refreshButt = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.beginReload))
        self.navigationItem.rightBarButtonItem = refreshButt
        
        self.refreshControl?.beginRefreshingManually(animated: false)
        
    }
    
    @objc func beginReload() {
        if let control = self.refreshControl, !control.isRefreshing {
            self.refreshControl?.beginRefreshingManually(animated: true)
        }
    }
    
    @objc func reloadRequest() {
        Network.request(node: self.stop.node) { busStop in
            delay(0.3) {
                self.stop = busStop
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stop.transits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transit", for: indexPath) as! TransitCell
        
        cell.time.text = stop.transits[indexPath.row].time
        cell.line.text = stop.transits[indexPath.row].line
        cell.dest.text = stop.transits[indexPath.row].direction
        
        cell.isUserInteractionEnabled = false
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: "transit_header") as? TransitHeader ?? nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
}

