//
//  Main.swift
//  ataf
//
//  Created by ned on 06/03/2018.
//  Copyright © 2018 ned. All rights reserved.
//

import UIKit
import WatchConnectivity

class Main: UITableViewController, UIViewControllerPreviewingDelegate, canAddBusStop {
    
    var stops : [BusStop] { return BusStop.allStops() }
    
    var session: WCSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = tableViewBackgroundColor
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
        
        let logo = #imageLiteral(resourceName: "logo")
        let imageViewLogo = UIImageView(image: logo)
        imageViewLogo.frame = CGRect(x: 0, y: 0, width: 0, height: 23)
        imageViewLogo.contentMode = .scaleAspectFit
        navigationItem.titleView = imageViewLogo
        
        // Register for 3D Touch
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .available {
                registerForPreviewing(with: self, sourceView: tableView)
            }
        }
        
        tableView.register(UINib(nibName: "StopCell", bundle: nil), forCellReuseIdentifier: "stop")
        
        let openButt = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.openSearch))
        navigationItem.rightBarButtonItem = openButt
        navigationItem.leftBarButtonItem = editButtonItem
        
        sendDataToWatch()
        
    }
    
    func addStop(stop: BusStop) {
        if !stops.contains(stop) {
            BusStop.addStop(stop: stop)
            sendDataToWatch()
            self.tableView.reloadData()
        }
    }
    
    @objc func openSearch() {
        self.performSegue(withIdentifier: "show_search", sender: self)
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
        
        cell.accessoryType = .disclosureIndicator
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // MARK: - didSelectRow
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "show_stop", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_stop" {
            
            // Hide 'Back' text on next screen
            navigationItem.backBarButtonItem = UIBarButtonItem()
            
            if let index = tableView.indexPathForSelectedRow, let vc = segue.destination as? Detail {
                vc.stop = stops[index.row]
            }
        }
        if segue.identifier == "show_search" {
            if let nc = segue.destination as? UINavigationController {
                if let vc = nc.viewControllers.first as? Search {
                    vc.delegate = self
                }
            }
        }
    }
    
    // MARK: - 3d touch
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController!.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView?.indexPathForRow(at: location) else { return nil }
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
        if #available(iOS 9.0, *) { previewingContext.sourceRect = cell.frame }
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? Detail else { return nil }
        vc.stop = stops[indexPath.row]
        return vc
    }
    
    // MARK: - delete
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            BusStop.removeStop(at: indexPath.row)
            sendDataToWatch()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - reorder
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        BusStop.moveStop(from: sourceIndexPath.row, to: destinationIndexPath.row)
        sendDataToWatch()
    }
    
    func performShortcutSegue(_ index: Int) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? Detail {
            vc.stop = stops[index]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension Main : WCSessionDelegate {
    
    func sendDataToWatch() {
        if let validSession = session, validSession.isReachable {
            print("hi")
            do {
                try validSession.updateApplicationContext(BusStop.unorderedWrappedDataForWatch())
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
}
