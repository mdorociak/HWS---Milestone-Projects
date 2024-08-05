//
//  DetailViewController.swift
//  Milestone 13-15
//
//  Created by lz on 03/08/2024.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var country: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.tableView.register(FlagCell.self, forCellReuseIdentifier: "FlagCell")
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlagCell", for: indexPath) as? FlagCell else {
            fatalError("Unable to dequeue a FlagCell.")
        }
        
        if let country = country {
            cell.configure(with: country)
        }
        
        return cell
    }
    
}
