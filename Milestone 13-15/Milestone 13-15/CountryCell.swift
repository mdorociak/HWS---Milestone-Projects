//
//  CountryCell.swift
//  Milestone 13-15
//
//  Created by lz on 03/08/2024.
//

import UIKit

class CountryCell: UITableViewCell {

    let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupViews() {
                contentView.addSubview(flagImageView)
                contentView.addSubview(nameLabel)
                
            NSLayoutConstraint.activate([
                    flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                    flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    flagImageView.widthAnchor.constraint(equalToConstant: 50),
                    flagImageView.heightAnchor.constraint(equalToConstant: 50),
                
                    nameLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 10),
                    nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                    nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                    nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
                ])
        }

}
