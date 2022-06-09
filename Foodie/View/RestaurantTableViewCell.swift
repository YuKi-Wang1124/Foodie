//
//  RestaurantTableViewCell.swift
//  Foodie
//
//  Created by 王昱淇 on 2022/5/31.
//

import UIKit


class RestaurantTableViewCell: UITableViewCell {

    // 表格清單內容
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView! {
        didSet {
            // 圓形照片
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
            thumbnailImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var heartImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
