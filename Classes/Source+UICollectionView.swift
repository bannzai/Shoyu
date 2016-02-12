//
//  Source+UICollectionView.swift
//  Shoyu
//
//  Created by Hirose.Yudai on 2016/02/12.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit
import ObjectiveC

struct UICollectionViewAssociatedObjectHandle {
    static var Source: UInt8 = 1
}

public extension UICollectionView {
    public var source: Source? {
        set {
            objc_setAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.Source, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            dataSource = newValue
            delegate = newValue
        }
        get {
            return objc_getAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.Source) as? Source
        }
    }
}
extension Source: UICollectionViewDataSource {
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionFor(section).rowCount
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let row = sectionFor(indexPath).rowFor(indexPath)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(row.reuseIdentifier, forIndexPath: indexPath)
        if let delegate = row as? ItemDelegateType {
            delegate.configureCell(collectionView, cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
}

extension Source: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let row = sectionFor(indexPath).rowFor(indexPath)
        if let delegate = row as? ItemDelegateType,
            let size = delegate.sizeFor(collectionView, indexPath: indexPath) {
                return size
        }
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout.itemSize
        }
        fatalError()
    }
}

// MARK: - Table view delegate

extension Source: UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let row = sectionFor(indexPath).rowFor(indexPath) as? ItemDelegateType
        row?.didSelect(collectionView, indexPath: indexPath)
    }
}