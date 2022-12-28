//
//  ViewController.swift
//  Project13
//
//  Created by Дария Григорьева on 28.12.2022.
//
import CoreImage
import UIKit

class ViewController: UIViewController {
    
    private var currentImage: UIImage?
    private var context = CIContext()
    private var currentFilter = CIFilter(name: "CISepiaTone") ?? CIFilter()
    
    private let baseView: UIView = {
        let baseView = UIView()
        baseView.backgroundColor = .darkGray
        return baseView
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let intensityLabel: UILabel = {
        let label = UILabel()
        label.text = "Intensity:"
        return label
    }()
    
    private let labelRadius: UILabel = {
        let label = UILabel()
        label.text = "Pixel:"
        return label
    }()
    
    private lazy var intensitySlider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(intensityChanged(_:)), for: .valueChanged)
        slider.value = 0.5
        return slider
    }()
    
    private lazy var radiusSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.3
        slider.addTarget(self, action: #selector(radiusChanged(_:)), for: .valueChanged)
        slider.tintColor = .green
        return slider
    }()
    
    private lazy var changeFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle("CISepiaTone", for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(changeFilter(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
        setupNavigationBar()
        
    }
    
    private func setupView() {
        view.addSubview(baseView)
        baseView.addSubview(imageView)
        view.addSubview(intensityLabel)
        view.addSubview(intensitySlider)
        view.addSubview(changeFilterButton)
        view.addSubview(saveButton)
        view.addSubview(radiusSlider)
        view.addSubview(labelRadius)
        
        baseView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        intensityLabel.translatesAutoresizingMaskIntoConstraints = false
        intensitySlider.translatesAutoresizingMaskIntoConstraints = false
        changeFilterButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        radiusSlider.translatesAutoresizingMaskIntoConstraints = false
        labelRadius.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: guide.topAnchor),
            baseView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 12),
            baseView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -12),
            baseView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            imageView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -10),
            
            intensityLabel.centerYAnchor.constraint(equalTo: intensitySlider.centerYAnchor),
            intensityLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            
            labelRadius.centerYAnchor.constraint(equalTo: radiusSlider.centerYAnchor),
            labelRadius.leadingAnchor.constraint(equalTo: intensityLabel.leadingAnchor),
            
            intensitySlider.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            intensitySlider.leadingAnchor.constraint(equalTo: intensityLabel.trailingAnchor, constant: 12),
            intensitySlider.topAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 12),
            
            radiusSlider.trailingAnchor.constraint(equalTo: intensitySlider.trailingAnchor),
            radiusSlider.leadingAnchor.constraint(equalTo: intensitySlider.leadingAnchor),
            radiusSlider.topAnchor.constraint(equalTo: intensitySlider.bottomAnchor, constant: 12),
            
            changeFilterButton.widthAnchor.constraint(equalToConstant: 200),
            changeFilterButton.heightAnchor.constraint(equalToConstant: 44),
            changeFilterButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 12),
            changeFilterButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -12),
            
            saveButton.widthAnchor.constraint(equalToConstant: 60),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            saveButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -12),
            saveButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Photo filter"
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func save(_ sender: UIButton) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "No image", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            
        }
    }
    
    private func setFilter(action: UIAlertAction) {
        guard let actionTitle = action.title else {
            return
        }
        
        guard let filter = CIFilter(name: actionTitle) else {
            return
        }
        
        guard let currentImage else {
            return
        }
        
        currentFilter = filter
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        changeFilterButton.setTitle(actionTitle, for: .normal)
        applyProcessing()
    }
    
    @objc private func radiusChanged(_ sender: UISlider) {
        guard let currentImage else {
            return
        }
        
        let filter = CIFilter(name: "CIPixellate")
        let beginImage = CIImage(image: currentImage)
        filter?.setValue(beginImage, forKey: kCIInputImageKey)
        filter?.setValue(sender.value * 10, forKey: kCIInputScaleKey)
        
        guard let outputImage = filter?.outputImage else {
            return
        }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            self.currentImage = processedImage
            imageView.image = currentImage
        }
        
    }
    
    @objc private func intensityChanged(_ sender: UISlider) {
        applyProcessing()
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
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

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        currentImage = image
        
        let beginImage = CIImage(image: image)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
        dismiss(animated: true)
    }
    
    private func applyProcessing() {
        guard let currentImage else {
            return
        }
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(intensitySlider.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            self.currentImage = processedImage
            imageView.image = processedImage
        }
        
    }
}

extension ViewController: UINavigationControllerDelegate {
    
}

