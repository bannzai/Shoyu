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

public final class CollectionSource: NSObject {
    public private(set) var sections = [SectionType]()
    
    public override init() {
        super.init()
    }
    
    public convenience init(@noescape closure: (CollectionSource -> Void)) {
        self.init()
        closure(self)
    }
    
    public var didMoveRow: ((NSIndexPath, NSIndexPath) -> Void)?
    
    public func addSection(section: SectionType) -> Self {
        sections.append(section)
        return self
    }
    
    public func addSections(sections: [SectionType]) -> Self {
        self.sections.appendContentsOf(sections)
        return self
    }
    
    public func createSection<H, F>(@noescape closure: (Section<H, F> -> Void)) -> Self {
        return addSection(Section<H, F>() { closure($0) })
    }
    
    public func createSections<H, F, E>(elements: [E], @noescape closure: ((E, Section<H, F>) -> Void)) -> Self {
        return addSections(
            elements.map { element -> Section<H, F> in
                return Section<H, F>() { closure(element, $0) }
                }.map { $0 as SectionType }
        )
    }
    
    public func createSections<H, F>(count: UInt, @noescape closure: ((UInt, Section<H, F>) -> Void)) -> Self {
        return createSections([UInt](0..<count), closure: closure)
    }
}

public extension CollectionSource {
    public func sectionFor(section: Int) -> SectionType {
        return sections[section]
    }
    
    public func sectionFor(indexPath: NSIndexPath) -> SectionType {
        return sectionFor(indexPath.section)
    }
    
    public func moveRow(sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath) {
        let row = sectionFor(sourceIndexPath).removeRow(sourceIndexPath.row)
        sectionFor(destinationIndexPath).insertRow(row, index: destinationIndexPath.row)
    }
}

extension CollectionSource: UICollectionViewDataSource {
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionFor(section).itemCount
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = sectionFor(indexPath).itemFor(indexPath)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(item.reuseIdentifier, forIndexPath: indexPath)
        if let delegate = item as? ItemDelegateType {
            delegate.configureCell(collectionView, cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
}

extension CollectionSource: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let item = sectionFor(indexPath).itemFor(indexPath)
        if let delegate = item as? ItemDelegateType,
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

extension CollectionSource: UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = sectionFor(indexPath).itemFor(indexPath) as? ItemDelegateType
        item?.didSelect(collectionView, indexPath: indexPath)
    }
}