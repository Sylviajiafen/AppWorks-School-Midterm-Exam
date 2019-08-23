//
//  AccessTokenManager.swift
//  KKKokoro
//
//  Created by Sylvia Jia Fen  on 2019/8/23.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation
import KeychainAccess


class AccessTokenManger {
    
    let keychain = Keychain()
    
    static let shared = AccessTokenManger()
    
    func getPostString(params: [String: Any]) -> String {
        
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    

    func httpPostRequest() {
        
        //URL
        let tokenURL = URL(string: "https://account.kkbox.com/oauth2/token")
    
        guard let url = tokenURL else {return}
        
        var tokenRequest = URLRequest(url: url)
        
        // Method
        tokenRequest.httpMethod = "POST"
        
        // Header
        tokenRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // BODY
        let params = ["grant_type": "client_credentials",
                      "client_id": "c7498e87ee0c66ffed1d0e880748c3b4",
                      "client_secret": "f01807407c2102aec0baf820774e2385"]
        
        let postingString = self.getPostString(params: params)
        
        tokenRequest.httpBody = postingString.data(using: .utf8)
        
        // Sending Request
        let decoder = JSONDecoder()
        
        let task = URLSession.shared.dataTask(with: tokenRequest) { (data, response, error) in
            
            guard error == nil else { print(error?.localizedDescription ?? "error"); return}
            
            guard let data = data, let response = response as? HTTPURLResponse else {return}
            
            print("status: \(response.statusCode)")
            
            do { let accessData = try decoder.decode(AccessToken.self, from: data)
                
                self.keychain["accessToken"] = "\(accessData.tokenType) \(accessData.accessToken)"
                
                print("token: \(String(describing: self.keychain["accessToken"]))")
                
            } catch {
                
                print(error)
            }
        }
        
        task.resume()
    }
    
}

