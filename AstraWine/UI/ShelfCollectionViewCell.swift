//
//  CollectionViewCell.swift
//  AstraWine
//
//  Created by Михаил Иванов on 29.09.2021.
//

import UIKit

class ShelfCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var deletButton: UIButton!
    @IBOutlet var imageShelf: UIImageView!
    @IBOutlet var editButton: UIButton!
    
    var delegate: ChangeCellViewCollection!
    var index: Int!
    
    @IBAction func deletCell() {
        delegate.delete(from: index)
    }
    
    @IBAction func editCell() {
        delegate.editCell(from: index)
    }
    
}
