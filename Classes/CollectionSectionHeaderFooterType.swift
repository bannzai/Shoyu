//
//  CollectionSectionHeaderFooterType.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/17.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public protocol CollectionSectionHeaderFooterType {
    var reuseIdentifier: String? { get }
    var size: CGSize? { get set }
}

protocol CollectionSectionHeaderFooterDelegateType {
    func configureView(collectionView: UICollectionView, view: UICollectionReusableView, section: Int)
    func sizeFor(collectionView: UICollectionView, section: Int) -> CGSize?
    func viewFor(collectionView: UICollectionView, section: Int) -> UICollectionReusableView?
}
