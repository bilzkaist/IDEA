//
//  MyTableViewCell.swift
//  IDEA
//
//  Created by Bilal Dastagir on 2020/07/19.
//  Copyright © 2020 Bilal Dastagir. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    static let identifier = "MyTableViewCell"
    
    static func nib() -> UINib
    {
        return UINib(nibName: "MyTableViewCell", bundle: nil)
    }
    
    public func configure(with uuid: String, with title: String, with subtitle: String, with rssi: String, with distance: String, with status: String, imageName: String)
    {
        myUUID.text = uuid
        myLabel.text = title
        mySubLabel.text = subtitle
        myRSSI.text = rssi
        myDistance.text = distance
        myStatus.text  = status
        myImageView.image = UIImage(systemName: imageName)
    }
    
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var myUUID: UILabel!
    @IBOutlet var myLabel: UILabel!
    @IBOutlet var mySubLabel: UILabel!
    @IBOutlet var myRSSI: UILabel!
    @IBOutlet var myDistance: UILabel!
    @IBOutlet var myStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myImageView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
