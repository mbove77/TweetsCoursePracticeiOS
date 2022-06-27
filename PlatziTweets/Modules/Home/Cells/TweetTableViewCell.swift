//
//  TweetTableViewCell.swift
//  PlatziTweets
//
//  Created by Resonant Sports on 18/02/2021.
//

import UIKit
import Kingfisher

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setupCell(post: Post) {
        nameLabel.text = post.author.names
        nickNameLabel.text = post.author.nickname
        tweetTextLabel.text = post.text
        
        if post.hasImage {
            tweetImageView.kf.setImage(with: URL(string: post.imageUrl))
        } else {
            tweetImageView.isHidden = true
        }
        
        if !post.hasVideo {
            videoButton.isHidden = true
        }
        
        dateLabel.text = post.createdAt
    }
    
}
