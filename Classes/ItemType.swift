//
//  ItemType.swift
//  Shoyu
//
//  Created by Hirose.Yudai on 2016/02/12.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

public protocol ItemType {
    var reuseIdentifier: String { get set }
    var size: CGSize? { get }
}

protocol ItemDelegateType {
    func configureCell(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: NSIndexPath)
    func sizeFor(tableView: UICollectionView, indexPath: NSIndexPath) -> CGSize?
    func didSelect(tableView: UICollectionView, indexPath: NSIndexPath)
}