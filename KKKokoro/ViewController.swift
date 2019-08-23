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
        let listManager = ListManager()
        listManager.fetchList()
        listManager.delegate = self
        
    }
    
    @IBOutlet weak var topImage: UIImageView!
    let topViewURL = URL(string: "https://i.kfs.io/playlist/global/26541395v266/cropresize/600x600.jpg")
    
    @IBOutlet weak var listTableView: UITableView!
    
    var hotList: HitList?
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let hotList = hotList else { return 1 }
        
        return hotList.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}

extension ViewController: ListManagerDelegate {
    
    func manager(_ manager: ListManager, didGet listsData: HitList) {
        
        hotList = listsData
        
        print("VC拿到： \(hotList)")
        
    }
    
    func manager(_ manager: ListManager, didFailWith error: Error) {
        
    }
    
    
    
}
