//
//  Search.swift
//  ataf
//
//  Created by ned on 06/03/2018.
//  Copyright © 2018 ned. All rights reserved.
//

import UIKit

class Search: UITableViewController, UISearchBarDelegate {
    
    lazy var searchBar = UISearchBar()
    var delegate : canAddBusStop? = nil
    var stops : [BusStop] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cerca Fermata"
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = tableViewBackgroundColor
        
        searchBar.delegate = self
        searchBar.placeholder = "Fermata o Codice Fermata"
        searchBar.tintColor = purple
        searchBar.becomeFirstResponder()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        tableView.register(UINib(nibName: "StopCell", bundle: nil), forCellReuseIdentifier: "stop")
        
        let openButt = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelAndClose))
        self.navigationItem.rightBarButtonItem = openButt
        
        delay(0.5) { self.reload() }
        
    }
    
    @objc func cancelAndClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            reload()
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.2)
        }
    }
    
    @objc func reload() {
        if let text = searchBar.text {
            Network.search(text: text) { busStops in
                self.stops = busStops
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stops.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stop", for: indexPath) as! StopCell
        
        cell.name.text = stops[indexPath.row].name
        cell.icon.image = #imageLiteral(resourceName: "stop_point")
        
        let addButton =  UIButton(type: .contactAdd)
        addButton.tag = indexPath.row
        addButton.addTarget(self, action: #selector(self.didClickAddButton), for: .touchUpInside)
        cell.accessoryView = addButton
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // MARK: - didSelectRow
    
    @objc func didClickAddButton(sender: UIButton) {
        if stops.indices.contains(sender.tag) {
            self.delegate?.addStop(stop: stops[sender.tag])
            dismiss(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.addStop(stop: stops[indexPath.row])
        dismiss(animated: true)
    }
    
}
