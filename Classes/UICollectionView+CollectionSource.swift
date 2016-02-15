//
//  UICollectionView+CollectionSource.swift
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
    public var source: CollectionSource? {
        set {
            objc_setAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.Source, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            dataSource = newValue
            delegate = newValue
        }
        get {
            return objc_getAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.Source) as? CollectionSource
        }
    }
}


