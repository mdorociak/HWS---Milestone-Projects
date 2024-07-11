//
//  PictureCell.swift
//  Milestone 10-12
//
//  Created by lz on 05/07/2024.
//

import UIKit

class PictureCell: UITableViewCell {
    
    let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
            contentView.addSubview(pictureImageView)
            contentView.addSubview(captionLabel)
            
        NSLayoutConstraint.activate([
                pictureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                pictureImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                pictureImageView.widthAnchor.constraint(equalToConstant: 50),
                pictureImageView.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            NSLayoutConstraint.activate([
                captionLabel.leadingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: 10),
                captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                captionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                captionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
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
