//
//  CollectionViewController.swift
//  SoySauce
//
//  Created by Hirose.Yudai on 2016/02/12.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: CollectionView!
    
    class var baseShoyus: [SoySauce] {
        return [
            SoySauce(name: "curry"),
            SoySauce(name: "ebi"),
            SoySauce(name: "inaka"),
            SoySauce(name: "kake"),
            SoySauce(name: "kaki"),
            SoySauce(name: "kikkoman"),
            SoySauce(name: "koori"),
            SoySauce(name: "koumi"),
            SoySauce(name: "marudaizu"),
            SoySauce(name: "ninniku"),
            SoySauce(name: "siro"),
            SoySauce(name: "ususio")
        ]   
    }
    
    let shoyus = Array(count: 10, repeatedValue: CollectionViewController.baseShoyus).flatMap { $0 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.source = CollectionSource().createSection { (section: CollectionSection) in
            section.createItems(3) { (index: UInt, item: Item<DefaultCollectionViewCell>) in
                item.sizeFor = { _ -> CGSize? in
                    return UIScreen.mainScreen().bounds.size
                }
                item.configureCell = configureLargeCell(index)
            }
            
            section.createItems(shoyus) { (shoyu: SoySauce, item: Item<DefaultCollectionViewCell>) in
                item.size = gridSize()
                item.configureCell = configureGridCell(shoyu)
                item.didSelect = { (_, _, indexPath) in
                    print(indexPath.item)
                }
            }
        }
        
        self.collectionView.reloadData()
    }
    
    private func gridSize() -> CGSize {
        let edge = (UIScreen.mainScreen().bounds.size.width / 3) - 1
        return CGSizeMake(edge, edge)
    }

    private func configureGridCell<T: DefaultCollectionViewCell>(shoyu: SoySauce) -> (T, Item<T>.ItemInformation) -> Void {
        return { cell, _ in
            cell.setupWith(DefaultCollectionViewCellModel(shoyu: shoyu))
        }
    }
    
    private func configureLargeCell<T: DefaultCollectionViewCell>(index: UInt) -> (T, Item<T>.ItemInformation) -> Void {
        let shoyu = shoyus[Int(index)]
        return { cell, _ in
            cell.setupWith(DefaultCollectionViewCellModel(shoyu: shoyu))
        }
    }
    
    deinit {
        print("CollectionViewController deinit")
    }

}

struct DefaultCollectionViewCellModel {
    var shoyu: SoySauce
    
    var name: String {
        return shoyu.name
    }
    
    var image: UIImage? {
        return UIImage(named: shoyu.name)
    }
}

class DefaultCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func setupWith(viewModel: DefaultCollectionViewCellModel) {
        label.text = viewModel.name
        imageView.image = viewModel.image
    }
    
    deinit {
        print("DefaultviewCell deinit")
    }
}

class CollectionView: UICollectionView {
    
    deinit {
        print("CollectionView deinit")
    }
}

struct SoySauce {
    let name: String
}