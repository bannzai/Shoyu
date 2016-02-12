//
//  CollectionViewController.swift
//  Shoyu
//
//  Created by Hirose.Yudai on 2016/02/12.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.source = Source().createSection { (section: Section) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
