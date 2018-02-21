//
//  BookTableViewCell.swift
//  CoreDataPOC
//
//  Created by Techjini on 1/12/18.
//  Copyright © 2018 Techjini. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    
    var book: Book? {
        didSet {
            titleLabel.text = book?.title ?? ""
            descriptionLabel.text = book?.description ?? ""
            publisherLabel.text = "Publisher: \(book?.publisher ?? "")"
            publishedDateLabel.text = "Date: \(book?.publishDate ?? "")"
            authorsLabel.text = "By:\(book?.authors ?? "")"
            guard let url = book?.imageUrl else {
                bookImageView.image = #imageLiteral(resourceName: "placeHolder")
                return
            }
            CoreService(request: URLRequest(url: url)).makeRequest {
                [weak self] (data, error) in
                guard let data = data else { return }
                self?.bookImageView.image = UIImage(data: data)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
