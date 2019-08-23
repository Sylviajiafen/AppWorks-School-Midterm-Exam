//
//  ListManager.swift
//  KKKokoro
//
//  Created by Sylvia Jia Fen  on 2019/8/23.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation

class ListManager {
    
    weak var delegate: ListManagerDelegate?
    
    func fetchList() {
        
        // URL
        let listURL = URL(string: "https://api.kkbox.com/v1.1/new-hits-playlists/DZrC8m29ciOFY2JAm3/tracks?territory=TW&limit=20")
        
        guard let url = listURL else {return}
        
        var listRequest = URLRequest(url: url)
        
        // Header
        guard let accestoken = AccessTokenManger.shared.keychain["accessToken"] else {return}
        listRequest.allHTTPHeaderFields = ["Authorization": "\(accestoken)"]
        
        // task
        let decoder = JSONDecoder()
        
        let task = URLSession.shared.dataTask(with: listRequest) { (data, response, error) in
            
            guard error == nil else { print(error?.localizedDescription ?? "error"); return}
            
            guard let data = data, let response = response as? HTTPURLResponse else {return}
            
            print("status: \(response.statusCode)")
            
            do { let listData = try decoder.decode(HitList.self, from: data)
                
                self.delegate?.manager(self, didGet: listData)
                
            } catch {
                
                print("decode error: \(error)")
                
                self.delegate?.manager(self, didFailWith: error)
            }
        }
        
        task.resume()
    }
}

protocol ListManagerDelegate: AnyObject {
    
    func manager(_ manager: ListManager, didGet listsData: HitList)
    
    func manager(_ manager: ListManager, didFailWith error: Error)
}
