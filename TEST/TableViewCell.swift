//
//  TableViewCell.swift
//  TEST
//
//  Created by Elizabeth Serykh on 20.01.2024.
//

import UIKit

class TableViewCell: UITableViewCell {

    let imagePerson: UIImageView = {
        let im = UIImageView()
        return im
    }()
    
    let namePerson: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(imagePerson)
        imagePerson.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imagePerson.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imagePerson.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
        ])
        
        addSubview(namePerson)
        namePerson.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            namePerson.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            namePerson.leadingAnchor.constraint(equalTo: imagePerson.leadingAnchor, constant: 10)
        ])
    }



}
