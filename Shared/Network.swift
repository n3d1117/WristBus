//
//  Network.swift
//  ataf
//
//  Created by ned on 06/03/2018.
//  Copyright © 2018 ned. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Network {
    
    static let endpoint = "http://www.temporealeataf.it/Mixer/Rest/PublicTransportService.svc/single"
    static let searchEndpoint = "http://www.temporealeataf.it/Mixer/Rest/PublicTransportService.svc/search"
    
    static let ticket = "YOUR_TICKET"
    
    static let headers : HTTPHeaders = ["User-Agent": "ataf/1.4.1 CFNetwork/711.4.6 Darwin/14.0.0"]
    
    static func params(node: String) -> [String : String] {
        return [
            "lat": "43.787796666666665",
            "lon": "11.249808333333334",
            "nodeId": node,
            "s": Serialize.getDynamicPassword(a: ticket),
            "getSchedule": "true",
            "getActive": "false",
            "getLine": "true"
        ]
    }
    
    static func searchParams(text: String) -> [String : String] {
        return [
            "urLat": "44",
            "urLon": "12",
            "llLat": "43",
            "llLon": "10",
            "getId": "true",
            "maxResults": "10",
            "getDist": "false",
            "cenLat": "(null)",
            "cenLon": "(null)",
            "st": text,
            "s": Serialize.getDynamicPassword(a: ticket)
        ]
    }
    
    class func request(node: String, success:@escaping (_ stop: BusStop) -> Void) {
        Alamofire.request(endpoint, parameters: params(node: node), headers: headers)
            .responseJSON { response in
            
                if let value = response.result.value {
                    let json = JSON(value)
                
                    let stop = BusStop(name: json["n"].stringValue, node: json["id"].stringValue)
                    
                    for i in 0..<json["s"].count {
                        let tmp = Transit(
                            line: json["s"][i]["n"].stringValue,
                            time: self.decodeTime(from: json["s"][i]["d"].stringValue),
                            direction: json["s"][i]["t"].stringValue
                        )
                        if !stop.transits.contains(tmp) { stop.transits.append(tmp) }
                    }
                
                    success(stop)
                }
            }
    }
    
    class func search(text: String, success:@escaping (_ stops: [BusStop]) -> Void) {
        Alamofire.request(searchEndpoint, parameters: searchParams(text: text), headers: headers)
            .responseJSON { response in
                if let value = response.result.value {
                    let json = JSON(value)
                
                    var arr : [BusStop] = []
                
                    for i in 0..<json.count {
                        arr.append(
                            BusStop(
                                name: json[i]["n"].stringValue,
                                node: json[i]["id"].stringValue
                            )
                        )
                    }
                
                    success(arr)
                }
            }
    }
    
    class func decodeTime(from: String) -> String {
        if let converted = Int(String(from.prefix(4))) {
            let dst: Double = NSTimeZone.local.isDaylightSavingTime() ? 2.0 : 1.0
            let tmp: Double = Double((Double(converted) / 360) + dst)
            let hour: String = Int(tmp) == 24 ? "00" : "\(Int(tmp))"
            let minuteInt: Int = Int(Float(modf(tmp).1) * 60)
            let minute: String = minuteInt < 10 ? "0\(minuteInt)" : "\(minuteInt)"
            return "\(hour):\(minute)"
        }
        return ""
    }
}
