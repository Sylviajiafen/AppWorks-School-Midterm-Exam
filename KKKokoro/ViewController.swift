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

    @IBOutlet weak var topBackView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        // 設定上方圖片
        topImage.kf.setImage(with: topViewURL)
        topBackView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.width)
        cachedImageViewSize = topBackView.frame
        
        // POST API
        AccessTokenManger.shared.httpPostRequest()
        
        // GET API
        listManager.fetchList(paging: paging)
        listManager.delegate = self
        
    }
    
    @IBOutlet weak var topImage: UIImageView!
    
    let topViewURL = URL(string: "https://i.kfs.io/playlist/global/26541395v266/cropresize/600x600.jpg")
    
    var cachedImageViewSize: CGRect?
    
    @IBOutlet weak var listTableView: UITableView!
    
    let listManager = ListManager()
    
    var paging: Int = 0
    
    var hotList: HitList?
    
    var hotlistData: [Data] = [] {
        
        didSet {
            
            listTableView.reloadData()
                
            if hotList?.data.count ?? 0 == 20 && hotList?.paging.next != nil {
                    paging += 1
                
                    listManager.fetchList(paging: paging)
                }
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


extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return hotlistData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y: CGFloat = -scrollView.contentOffset.y
        
        if y > 0 {
                
                guard let cachedImageViewSize = self.cachedImageViewSize else {return}
            
                self.topImage.frame = CGRect(
                    x: 0,
                    y: scrollView.contentOffset.y,
                    width: cachedImageViewSize.size.width + y,
                    height: cachedImageViewSize.size.height + y)
            
                self.topImage.center = CGPoint(x: self.view.center.x, y: self.topImage.center.y)
            
        }
    }
}

extension ViewController: ListManagerDelegate {
    
    func manager(_ manager: ListManager, didGet listsData: HitList) {
        
        hotList = listsData
        
        DispatchQueue.main.async {
            
            self.hotlistData.append(contentsOf: listsData.data)
        
        }
        
    }
    
    func manager(_ manager: ListManager, didFailWith error: Error) {
        
    }
    
}
