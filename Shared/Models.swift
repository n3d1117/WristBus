//
//  Models.swift
//  ataf
//
//  Created by ned on 06/03/2018.
//  Copyright © 2018 ned. All rights reserved.
//

import Foundation

func ==(lhs: BusStop, rhs: BusStop) -> Bool {
    return lhs.node == rhs.node
}

func ==(lhs: Transit, rhs: Transit) -> Bool {
    return lhs.line == rhs.line && lhs.time == rhs.time && lhs.direction == rhs.direction
}

class Transit: Equatable {
    var line: String = ""
    var time: String = ""
    var direction: String = ""
    
    convenience init(line: String, time: String, direction: String) {
        self.init()
        self.line = line
        self.time = time
        self.direction = direction
    }
}

class BusStop: Equatable {
    var name: String = ""
    var node: String = ""
    var transits: [Transit] = []
    
    init(name: String, node: String) {
        self.name = name
        self.node = node
    }
    
    convenience init(dictionary: [String: String]) {
        self.init(name: dictionary["name"] ?? "", node: dictionary["node"] ?? "")
    }
    
    convenience init() {
        self.init(name: "", node: "")
    }
}

#if os(iOS)
    
    import UIKit
    
    extension BusStop {
        
        func toArray() -> [String: String] {
            return [
                "name": self.name,
                "node": self.node
            ]
        }
        
        class func allStops() -> [BusStop] {
            let defaults = UserDefaults.standard
            let stops = defaults.object(forKey: "stops") as? [[String:String]] ?? [[String:String]]()
            var arr = [BusStop]()
            for stop in stops { arr.append(BusStop(dictionary: stop)) }
            return arr
        }
        
        class func addStop(stop: BusStop) {
            let defaults = UserDefaults.standard
            var stops = defaults.object(forKey: "stops") as? [[String:String]] ?? [[String:String]]()
            stops.append(stop.toArray())
            defaults.set(stops, forKey: "stops")
            defaults.synchronize()
            updateShortcuts()
        }
        
        class func removeStop(at: Int) {
            let defaults = UserDefaults.standard
            var stops = defaults.object(forKey: "stops") as? [[String:String]] ?? [[String:String]]()
            stops.remove(at: at)
            defaults.set(stops, forKey: "stops")
            defaults.synchronize()
            updateShortcuts()
        }
        
        class func moveStop(from: Int, to: Int) {
            let defaults = UserDefaults.standard
            var stops = defaults.object(forKey: "stops") as? [[String:String]] ?? [[String:String]]()
            let tmp = stops[from]
            stops.remove(at: from)
            stops.insert(tmp, at: to)
            defaults.set(stops, forKey: "stops")
            defaults.synchronize()
            updateShortcuts()
        }
        
        class func updateShortcuts() {
            var items : [UIApplicationShortcutItem] = []
            var stops = self.allStops()
            
            for i in 0..<stops.count {
                if i < 4 {
                    let item = UIApplicationShortcutItem(
                        type: "\(i)",
                        localizedTitle: stops[i].name,
                        localizedSubtitle: stops[i].node,
                        icon: UIApplicationShortcutIcon(type: .markLocation)
                    )
                    items.append(item)
                }
            }
            
            UIApplication.shared.shortcutItems = items
        }
        
        // iOS to Watch
        class func unorderedWrappedDataForWatch() -> [String:String] {
            let defaults = UserDefaults.standard
            let stops = defaults.object(forKey: "stops") as? [[String:String]] ?? [[String:String]]()
            var dict: [String:String] = [String:String]()
            for i in 0..<stops.count {
                if let name = stops[i]["name"] {
                    dict["\(i) " + name] = stops[i]["node"]
                }
            }
            return dict
        }
    }
    
#endif

#if os(watchOS)
    extension BusStop {
        
        class func saveStopsLocally(from: [String:String]) {
            
            let defaults = UserDefaults.standard
            
            var orderedData = Array(from.keys).sorted(by: <)
            var dict: [[String:String]] = [[String:String]]()
            
            for i in 0..<from.count {
                if let node = from[orderedData[i]] {
                    dict.append([
                        "name": trimWhiteSpace(from: orderedData[i]),
                        "node": node
                    ])
                }
            }
            
            defaults.set(dict, forKey: "stops_watch")
            defaults.synchronize()
        }
        
        class func allStops() -> [BusStop] {
            let defaults = UserDefaults.standard
            let stops = defaults.object(forKey: "stops_watch") as? [[String:String]] ?? [[String:String]]()
            var arr = [BusStop]()
            for stop in stops { arr.append(BusStop(dictionary: stop)) }
            return arr
        }
        
        class func trimWhiteSpace(from string: String) -> String {
            if let idx = string.index(of: " ") {
                let pos = string.distance(from: string.startIndex, to: idx)
                var to = string
                to.removeFirst(pos+1)
                return to
            }
            return ""
        }
    }
    
#endif
