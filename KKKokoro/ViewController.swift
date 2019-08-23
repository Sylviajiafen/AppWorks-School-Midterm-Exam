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
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
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
    
    var hotlistData: [Data] = [] {
        
        didSet {
            
            listTableView.reloadData()

        }
        
    }
    
    var selected: [Bool] = {
        
        var array: [Bool] = []
        
        for times in 0...60 {
            array.append(false)
        }
        
        return array
        }() 
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return hotlistData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = listTableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath)
        
        guard let listCell = cell as? ListTableViewCell else { return UITableViewCell() }
        
        let imageUrl = URL(string: hotlistData[indexPath.row].album.images[0].url)
        
        listCell.albumImage.kf.setImage(with: imageUrl)
        
        listCell.songTitle.text = hotlistData[indexPath.row].name
        
        listCell.heartBtn.tag = indexPath.row
        
        listCell.heartBtn.addTarget(self, action: #selector(btnSelected(sender:)), for: .touchUpInside)
        
        listCell.heartBtn.isSelected = selected[indexPath.row]

        return listCell
        
    }
    
    @objc func btnSelected(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        selected[sender.tag] = sender.isSelected
        
    }
}

extension ViewController: ListManagerDelegate {
    
    func manager(_ manager: ListManager, didGet listsData: HitList) {
        
        hotList = listsData
        
        DispatchQueue.main.async {
            
            self.hotlistData.append(contentsOf: listsData.data)
        
        }
       
//        print("VC拿到： \(hotList)")
//        print("=======data: \(hotlistData)")
        
        if listsData.paging.next != nil {
            
            paging += 1
            
            listManager.fetchList(paging: paging)
            
        }
        
//        print(hotlistData.last)
//        print("===\(hotlistData.count)===")
//        print(hotlistData.last)
        
    }
    
    func manager(_ manager: ListManager, didFailWith error: Error) {
        
    }
    
}
