//
//  ViewController.swift
//  Milestone 13-15
//
//  Created by lz on 03/08/2024.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CountryCell.self, forCellReuseIdentifier: "CountryCell")
        loadCountries()
        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        do {
            let jsonCountries = try decoder.decode(CountryList.self, from: json)
            countries = jsonCountries.countries
            tableView.reloadData()
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
    
    func loadCountries() {
        if let url = Bundle.main.url(forResource: "countries", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                countries.sort { $0.name < $1.name }
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCell else {
            fatalError("Unable to dequeue a CountryCell.")
        }
        let country = countries[indexPath.row]
        cell.nameLabel.text = country.name
        
        if let flagURL = URL(string: country.flag) {
            cell.flagImageView.loadImage(from: flagURL)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.country = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIImageView {
    func loadImage(from url: URL) {
        
        self.image = nil
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
        
            guard let data = data, error == nil else {
                print("Error loading image.")
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                    self.image = downloadedImage
                } else {
                    print("faled to create image from data")
                }
            }
        }
        task.resume()
    }
}
