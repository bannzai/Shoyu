//
//  CollectionSource.swift
//  Shoyu
//
//  Created by Hirose.Yudai on 2016/02/12.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

public final class CollectionSource: NSObject {
    public private(set) var sections = [CollectionSectionType]()
    
    public override init() {
        super.init()
    }
    
    public convenience init(@noescape closure: (CollectionSource -> Void)) {
        self.init()
        closure(self)
    }
    
    public var didMoveRow: ((NSIndexPath, NSIndexPath) -> Void)?
    
    public func addSection(section: CollectionSectionType) -> Self {
        sections.append(section)
        return self
    }
    
    public func addSections(sections: [CollectionSectionType]) -> Self {
        self.sections.appendContentsOf(sections)
        return self
    }
    
    public func createSection<H, F>(@noescape closure: (CollectionSection<H, F> -> Void)) -> Self {
        return addSection(CollectionSection<H, F>() { closure($0) })
    }
    
    public func createSections<H, F, E>(elements: [E], @noescape closure: ((E, CollectionSection<H, F>) -> Void)) -> Self {
        return addSections(
            elements.map { element -> CollectionSection<H, F> in
                return CollectionSection<H, F>() { closure(element, $0) }
                }.map { $0 as CollectionSectionType }
        )
    }
    
    public func createSections<H, F>(count: UInt, @noescape closure: ((UInt, CollectionSection<H, F>) -> Void)) -> Self {
        return createSections([UInt](0..<count), closure: closure)
    }
}

public extension CollectionSource {
    public func sectionFor(section: Int) -> CollectionSectionType {
        return sections[section]
    }
    
    public func sectionFor(indexPath: NSIndexPath) -> CollectionSectionType {
        return sectionFor(indexPath.section)
    }
}

// MARK: - Collection view datasource

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
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let headerFooter = sectionFor(indexPath.section).reusableViewFor(kind) else {
            fatalError()
        }
        return sectionHeaderFooterViewFor(headerFooter, collectionView: collectionView, kind: kind, indexPath: indexPath)
    }
}

// MARK: - Collection view delegate

extension CollectionSource: UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = sectionFor(indexPath).itemFor(indexPath) as? ItemDelegateType
        item?.didSelect(collectionView, indexPath: indexPath)
    }
}

// MARK: - Collection view delegate flow layout

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
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError()
        }
        
        guard let header = sectionFor(section).reusableViewFor(UICollectionElementKindSectionHeader) else {
            return CGSizeZero
        }
        return sectionHeaderFooterSizeFor(header, collectionView: collectionView, section: section) ?? flowLayout.headerReferenceSize
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError()
        }
        
        guard let footer = sectionFor(section).reusableViewFor(UICollectionElementKindSectionFooter) else {
            return CGSizeZero
        }
        return sectionHeaderFooterSizeFor(footer, collectionView: collectionView, section: section) ?? flowLayout.headerReferenceSize
    }
    
}

// MARK: - Private method

extension CollectionSource {
    private func sectionHeaderFooterViewFor(headerFooter: CollectionSectionHeaderFooterType, collectionView: UICollectionView, kind: String, indexPath: NSIndexPath) -> UICollectionReusableView {
        // Dequeue
        if let identifier = headerFooter.reuseIdentifier {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: identifier, forIndexPath: indexPath)
            if let delegate = headerFooter as? CollectionSectionHeaderFooterDelegateType {
                delegate.configureView(collectionView, view: view, section: indexPath.section)
            }
            return view
        }
        
        fatalError()
    }
    
    private func sectionHeaderFooterSizeFor(headerFooter: CollectionSectionHeaderFooterType, collectionView: UICollectionView, section: Int) -> CGSize? {
        if let delegate = headerFooter as? CollectionSectionHeaderFooterDelegateType,
            let size = delegate.sizeFor(collectionView, section: section) {
                return size
        }
        return nil
    }
}