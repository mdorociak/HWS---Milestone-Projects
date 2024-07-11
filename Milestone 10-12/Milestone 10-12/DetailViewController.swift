//
//  DetailViewController.swift
//  Milestone 10-12
//
//  Created by lz on 03/07/2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    var imageView = UIImageView()
    var selectedImageName: String?
    var imagePath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()

        title = selectedImageName
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.image = UIImage(contentsOfFile: imagePath.path)
        
        view.addSubview(imageView)
                
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
            
    }

}
