//
//  ViewController.swift
//  KKKokoro
//
//  Created by Sylvia Jia Fen  on 2019/8/23.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定上方圖片
        topImage.kf.setImage(with: topViewURL)
        
        // POST API
        AccessTokenManger.shared.httpPostRequest()
        
        // GET API
        listManager.fetchList(paging: paging)
        listManager.delegate = self
        
    }
    
    let listManager = ListManager()
    var paging: Int = 0
    
    @IBOutlet weak var topImage: UIImageView!
    let topViewURL = URL(string: "https://i.kfs.io/playlist/global/26541395v266/cropresize/600x600.jpg")
    
    @IBOutlet weak var listTableView: UITableView!
    
    var hotList: HitList?
    
    var hotlistData: [Data] = []
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return hotlistData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}

extension ViewController: ListManagerDelegate {
    
    func manager(_ manager: ListManager, didGet listsData: HitList) {
        
        hotList = listsData
        
        hotlistData.append(contentsOf: listsData.data)
        
        print("VC拿到： \(hotList)")
        print("=======data: \(hotlistData)")
        
        if listsData.paging.next != nil {
            
            paging += 1
            
            listManager.fetchList(paging: paging)
            
            hotlistData.append(contentsOf: listsData.data)
            
        }
        
    }
    
    func manager(_ manager: ListManager, didFailWith error: Error) {
        
    }
    
    
    
}
