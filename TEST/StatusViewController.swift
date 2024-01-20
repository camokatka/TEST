//
//  StatusViewController.swift
//  TEST
//
//  Created by Elizabeth Serykh on 20.01.2024.
//

import Foundation
import UIKit

class StatusViewController: UIViewController {
    
    var status: String = ""
    var statusColor: UIColor = UIColor.clear
    
    let statusLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(statusLabel)
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        statusLabel.textColor = statusColor
        statusLabel.text = status
    }
}
