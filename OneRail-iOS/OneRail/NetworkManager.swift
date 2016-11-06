//
//  NetworkManager.swift
//  OneRail
//
//  Created by Danny Bravo on 05/11/2016.
//  Copyright © 2016 HackTrain. All rights reserved.
//

import Foundation
import CoreLocation

private let LOCAL_SERVER = "10.11.10.123"

class NetworkManager {
    
    let sessionManager = URLSession(configuration: URLSessionConfiguration.default)
    
    func notifyBeaconDetection(beaconId: NSNumber, userId: String) {
        let urlString = "http://\(LOCAL_SERVER):8080/api/view_beacon"
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["client_uuid":userId, "beacon_uuid": "\(beaconId)"]
        let data = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        callEndpoint(with: urlRequest, data: data, retryBlock: {
            self.notifyBeaconDetection(beaconId: beaconId, userId: userId)
        })
    }
    
    func notifyBeaconSignalLost(userId: String) {
        let urlString = "http://\(LOCAL_SERVER):8080/api/exit_region"
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = ["client_uuid":userId]
        let data = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        callEndpoint(with: urlRequest, data: data, retryBlock: {
            self.notifyBeaconSignalLost(userId: userId)
        })
    }
    
    func callEndpoint(with request: URLRequest, data: Data, retryBlock: @escaping ()->()) {
        let task = sessionManager.uploadTask(with: request, from: data, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: retryBlock)
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                print((response as? HTTPURLResponse)?.statusCode ?? -1)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: retryBlock)
            } else {
                print("******************")
                print("BEACON REGISTERED!")
                print("******************")
            }
        })
        task.resume()
    }
    
}
