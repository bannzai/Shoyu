//
//  Item.swift
//  Shoyu
//
//  Created by Hirose.Yudai on 2016/02/12.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit


public class Item<T: UICollectionViewCell>: ItemType {
    
    public typealias ItemInformation = (item: Item<T>, collectionView: UICollectionView, indexPath: NSIndexPath)
    
    init() { }
    
    init(@noescape closure: (Item<T> -> Void)) {
        closure(self)
    }
    
    public var configureCell: ((T, ItemInformation) -> Void)?
    public var sizeFor: (ItemInformation -> CGSize?)?
    public var didSelect: (ItemInformation -> Void)?
    
    private var _reuseIdentifier: String?
    public var reuseIdentifier: String {
        set {
            _reuseIdentifier = newValue
        }
        get {
            if let identifier = _reuseIdentifier {
                return identifier
            }
            let identifier = T() as ReuseIdentifierType
            return identifier.identifier
        }
    }
    
    public var size: CGSize?
}

extension Item: ItemDelegateType {
    func configureCell(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        configureCell?(genericCell, (self, collectionView, indexPath))
    }
    
    func sizeFor(collectionView: UICollectionView, indexPath: NSIndexPath) -> CGSize? {
        return sizeFor?((self, collectionView, indexPath)) ?? size
    }
    
    func didSelect(collectionView: UICollectionView, indexPath: NSIndexPath) {
        didSelect?((self, collectionView, indexPath))
    }
}