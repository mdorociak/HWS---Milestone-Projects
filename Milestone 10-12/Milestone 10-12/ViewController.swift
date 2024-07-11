//
//  ViewController.swift
//  Milestone 10-12
//
//  Created by lz on 01/07/2024.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddPictureButton()
        tableView.register(PictureCell.self, forCellReuseIdentifier: "Picture")
        loadPictures()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Unable to dequeue a PictureCell.")
        }
        
        let picture = pictures[indexPath.row]
        cell.captionLabel.text = picture.picName
        
        let path = getDocumentsDirectory().appendingPathComponent(picture.picImage)
        cell.pictureImageView.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = DetailViewController()
        let path = getDocumentsDirectory().appendingPathComponent(pictures[indexPath.row].picImage)

        dvc.selectedImageName = pictures[indexPath.row].picName
        dvc.imagePath = path
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    func setupAddPictureButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
    }
    
    @objc func addPicture() {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pic = info[.editedImage] as? UIImage else { return }
        
        let pictureName = UUID().uuidString
        let picturePath = getDocumentsDirectory().appendingPathComponent(pictureName)
        
        if let jpegData = pic.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: picturePath)
        }
        
        dismiss(animated: true) {
            self.nameAPicture(imagePath: picturePath.path, pictureName: pictureName)
        }
    }
    
    func nameAPicture(imagePath: String, pictureName: String) {
        let ac = UIAlertController(title: "Name you picture", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {[unowned self, ac] _ in
            let name = ac.textFields?[0].text ?? "Unknown"
            let picture = Picture(picName: name, picImage: pictureName)
            self.pictures.append(picture)
            self.savePictures()
            self.tableView.reloadData()
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func loadPictures() {
        let defaults = UserDefaults.standard
        if let savedPics = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPics)
            } catch {
                print("Failed to load pictures.")
            }
        }
    }
    
    func savePictures() {
        let jsonEncoder = JSONEncoder()
        
        if let savedPic = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedPic, forKey: "pictures")
        } else {
            print("Failed to save a picture.")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

