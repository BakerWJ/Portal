//
//  ScheduleLayout.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-28.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

protocol ScheduleLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
}

class ScheduleLayout: UICollectionViewLayout {
    var delegate: ScheduleLayoutDelegate!
    var numberOfColumns = 1;
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0;
    private var width: CGFloat {
        get {
            return collectionView!.bounds.width
        }
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize (width: width, height: contentHeight);
        }
    }
    
    override func prepare ()
    {
        if cache.isEmpty {
            
        }
    }
    
}
