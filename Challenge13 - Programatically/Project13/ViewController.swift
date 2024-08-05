//
//  ViewController.swift
//  Project13
//
//  Created by lz on 08/07/2024.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var grayView: UIView!
    var imageView: UIImageView!
    var intensityLabel: UILabel!
    var intensitySlider: UISlider!
    var radiusLabel: UILabel!
    var radiusSlider: UISlider!
    var changeFilterButton: UIButton!
    var saveButton: UIButton!
    
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    var currentFilterName = "Choose filter" {
        didSet {
            changeFilterButton.setTitle(currentFilterName, for: .normal)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YICIFP"

        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
        setupView()
        setupActions()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radiusSlider.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
    
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        self.imageView.alpha = 0
        UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
            self.imageView.alpha = 1
        })
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        
        currentFilterName = actionTitle
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }

    @objc func changeFilter() {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = changeFilterButton
            popoverController.sourceRect = changeFilterButton.bounds
        }
        
        present(ac, animated: true)
    }
    
    @objc func save() {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Error!", message: "Select the picture first!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            return
            
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_: didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func intensityChanged() {
        applyProcessing()
    }
    
    @objc func radiusChanged() {
        applyProcessing()
    }
    
    
    func setupView() {
        self.view.backgroundColor = .white

        grayView = UIView()
        grayView.translatesAutoresizingMaskIntoConstraints = false
        grayView.backgroundColor = .darkGray
        view.addSubview(grayView)
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        grayView.addSubview(imageView)
        
        intensityLabel = UILabel()
        intensityLabel.translatesAutoresizingMaskIntoConstraints = false
        intensityLabel.text = "Intensity"
        intensityLabel.textAlignment = .right
        view.addSubview(intensityLabel)
        
        intensitySlider = UISlider()
        intensitySlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(intensitySlider)
        
        radiusLabel = UILabel()
        radiusLabel.translatesAutoresizingMaskIntoConstraints = false
        radiusLabel.text = "Radius"
        radiusLabel.textAlignment = .right
        view.addSubview(radiusLabel)
        
        radiusSlider = UISlider()
        radiusSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(radiusSlider)
        
        changeFilterButton = UIButton(type: .system)
        changeFilterButton.translatesAutoresizingMaskIntoConstraints = false
        changeFilterButton.setTitle(currentFilterName, for: .normal)
        view.addSubview(changeFilterButton)
        
        saveButton = UIButton(type: .system)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            grayView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            grayView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            grayView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            grayView.heightAnchor.constraint(equalToConstant: 470),
            
            imageView.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: grayView.bottomAnchor, constant: -10),
            
            intensityLabel.topAnchor.constraint(equalTo: grayView.bottomAnchor, constant: 28),
            intensityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            intensityLabel.widthAnchor.constraint(equalToConstant: 72),
            intensityLabel.heightAnchor.constraint(equalToConstant: 21),
            
            intensitySlider.centerYAnchor.constraint(equalTo: intensityLabel.centerYAnchor),
            intensitySlider.leadingAnchor.constraint(equalTo: intensityLabel.trailingAnchor, constant: 8),
            intensitySlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            radiusLabel.topAnchor.constraint(equalTo: intensityLabel.bottomAnchor, constant: 28),
            radiusLabel.centerXAnchor.constraint(equalTo: intensityLabel.centerXAnchor),
            radiusLabel.widthAnchor.constraint(equalToConstant: 72),
            radiusLabel.heightAnchor.constraint(equalToConstant: 21),
            
            radiusSlider.centerYAnchor.constraint(equalTo: radiusLabel.centerYAnchor),
            radiusSlider.leadingAnchor.constraint(equalTo: radiusLabel.trailingAnchor, constant: 8),
            radiusSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            changeFilterButton.topAnchor.constraint(equalTo: radiusLabel.bottomAnchor, constant: 22),
            changeFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            changeFilterButton.widthAnchor.constraint(equalToConstant: 120),
            changeFilterButton.heightAnchor.constraint(equalToConstant: 44),
            changeFilterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            saveButton.centerYAnchor.constraint(equalTo: changeFilterButton.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 60),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func setupActions() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        changeFilterButton.addTarget(self, action: #selector(changeFilter), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        intensitySlider.addTarget(self, action: #selector(intensityChanged), for: .valueChanged)
        radiusSlider.addTarget(self, action: #selector(radiusChanged), for: .valueChanged)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

