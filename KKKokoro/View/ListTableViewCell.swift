//
//  ListTableViewCell.swift
//  KKKokoro
//
//  Created by Sylvia Jia Fen  on 2019/8/23.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var heartBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        heartBtn.setImage(UIImage(named: "icons8-heart-24-selecteed"), for: .selected)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
