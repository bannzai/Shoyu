//
//  CollectionSectionHeaderFooter.swift
//  Shoyu
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public class CollectionSectionHeaderFooter<Type: UICollectionReusableView>: CollectionSectionHeaderFooterType {
    public typealias SectionHeaderFooterInformation = (headerFooter: CollectionSectionHeaderFooter<Type>, collectionView: UICollectionView, section: Int)
    
    public init() { }
    
    public init(@noescape closure: (CollectionSectionHeaderFooter<Type> -> Void)) {
        closure(self)
    }
    
    private var _reuseIdentifier: String?
    public var reuseIdentifier: String? {
        set {
            _reuseIdentifier = newValue
        }
        get {
            if let identifier = _reuseIdentifier {
                return identifier
            }
            if let identifier = Type() as? ReuseIdentifierType {
                return identifier.identifier
            }
            return nil
        }
    }
    
    public var size: CGSize?
    
    public var configureView: ((Type, SectionHeaderFooterInformation) -> Void)?
    public var sizeFor: (SectionHeaderFooterInformation -> CGSize?)?
}

extension CollectionSectionHeaderFooter: CollectionSectionHeaderFooterDelegateType {
    
    func configureView(collectionView: UICollectionView, view: UICollectionReusableView, section: Int) {
        guard let genericView = view as? Type else {
            fatalError()
        }
        configureView?(genericView, (self, collectionView, section))
    }
    
    func sizeFor(collectionView: UICollectionView, section: Int) -> CGSize? {
        return sizeFor?((self, collectionView, section)) ?? size
    }
}
