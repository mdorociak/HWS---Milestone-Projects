import UIKit

class FlagCell: UITableViewCell {
    
    let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 4
        imageView.layer.masksToBounds = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let capitalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let populationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let funFactLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(flagImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(capitalLabel)
        contentView.addSubview(languageLabel)
        contentView.addSubview(populationLabel)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(funFactLabel)
        
        // Setup Constraints
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            flagImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            flagImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            flagImageView.heightAnchor.constraint(equalTo: flagImageView.widthAnchor, multiplier: 0.8),
            
            nameLabel.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            capitalLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            capitalLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            capitalLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            languageLabel.topAnchor.constraint(equalTo: capitalLabel.bottomAnchor, constant: 10),
            languageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            languageLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            populationLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 10),
            populationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            populationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            sizeLabel.topAnchor.constraint(equalTo: populationLabel.bottomAnchor, constant: 10),
            sizeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            sizeLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            funFactLabel.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 10),
            funFactLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            funFactLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            funFactLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with country: Country) {
        nameLabel.text = country.name
        capitalLabel.text = "Capital: \(country.capital)"
        languageLabel.text = "Language: \(country.official_language)"
        populationLabel.text = "Population: \(country.population)"
        sizeLabel.text = "Size: \(country.size_km2) km²"
        funFactLabel.text = "Fun fact: \(country.funFact)"
        
        if let url = URL(string: country.flag) {
            flagImageView.loadImage(from: url)
        }
    }
}
