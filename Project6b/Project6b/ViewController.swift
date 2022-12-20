//
//  ViewController.swift
//  Project6b
//
//  Created by Дария Григорьева on 20.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let label1: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.red
        label.text = "THESE"
        label.sizeToFit()
        return label
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.cyan
        label.text = "ARE"
        label.sizeToFit()
        return label
    }()
    
    private let label3: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.yellow
        label.text = "SOME"
        label.sizeToFit()
        return label
    }()
    
    private let label4: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.green
        label.text = "AWESOME"
        label.sizeToFit()
        return label
    }()
    
    private let label5: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.orange
        label.text = "LABELS"
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    private func setupView() {
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        label4.translatesAutoresizingMaskIntoConstraints = false
        label5.translatesAutoresizingMaskIntoConstraints = false
        
        //        let viewsDictionary = ["label1": label1,
        //                               "label2": label2,
        //                               "label3": label3,
        //                               "label4": label4,
        //                               "label5": label5]
        //
        //        for label in viewsDictionary.keys {
        //            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|",
        //                                                               options: [],
        //                                                               metrics: nil,
        //                                                               views: viewsDictionary))
        //        }
        
        //        view.addConstraints(
        //            NSLayoutConstraint.constraints(
        //                withVisualFormat: "V:|[label1]-[label2]-[label3]-[label4]-[label5]",
        //                options: [],
        //                metrics: nil,
        //                views: viewsDictionary))
        
        // MARK: - With label Height
        //
        //        let metrics = ["labelHeight": 88]
        //        view.addConstraints(
        //            NSLayoutConstraint.constraints(
        //                withVisualFormat:"V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|",
        //                options: [],
        //                metrics: metrics,
        //                views: viewsDictionary))
        //    }
        //
        var previous: UILabel?
        let guide = view.safeAreaLayoutGuide
        for label in [label1, label2, label3, label4, label5] {
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            label.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.19).isActive = true
            
            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0).isActive = true
            }
            previous = label
        }
        
    }
    
}
