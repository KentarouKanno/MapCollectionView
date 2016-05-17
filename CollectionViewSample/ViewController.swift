//
//  ViewController.swift
//  CollectionViewSample
//
//  Created by Kentarou on 2016/05/17.
//  Copyright © 2016年 Kentarou. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    let cellRatio: CGFloat = 1.3
    
    var collectionViewMaxHeight: CGFloat {
        return UIScreen.mainScreen().bounds.height / 2
    }
    
    @IBOutlet weak var collectionViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.orientationChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func  orientationChange()  {
        if collectionViewHeightLayout.constant > collectionViewMaxHeight {
            collectionViewHeightLayout.constant = collectionViewMaxHeight
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        if let touchEvent = touches.first {
            if touchEvent.view?.tag == 5 {
                
                let dy = touchEvent.locationInView(view).y - touchEvent.previousLocationInView(view).y
                let height = collectionViewHeightLayout.constant - dy
                
                if 40 < height && height < collectionViewMaxHeight {
                    collectionViewHeightLayout.constant = height
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        
        let isLandscape = UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)
        let perRow = 2 + (isLandscape ? 1 : 0)
        adaptBeautifulGrid(perRow, gridLineSpace: 10.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let coordinate = CLLocationCoordinate2DMake(37.331652997806785, -122.03072304117417)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated:false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Apple "
        self.mapView.addAnnotation(annotation)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.title.text = "Apple";
        cell.image.image = UIImage(named: "apple")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20;
    }
    
    func adaptBeautifulGrid(numberOfGridsPerRow: Int, gridLineSpace space: CGFloat) {
        let inset = UIEdgeInsets( top: 0, left: space, bottom: space, right: space)
        adaptBeautifulGrid(numberOfGridsPerRow, gridLineSpace: space, sectionInset: inset)
    }
    
    func adaptBeautifulGrid(numberOfGridsPerRow: Int, gridLineSpace space: CGFloat, sectionInset inset: UIEdgeInsets) {
        guard let layout = imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        guard numberOfGridsPerRow > 0 else {
            return
        }
        let isScrollDirectionVertical = layout.scrollDirection == .Vertical
        var length = isScrollDirectionVertical ? imageCollectionView.frame.width : imageCollectionView.frame.height
        length -= space * CGFloat(numberOfGridsPerRow - 1)
        length -= isScrollDirectionVertical ? (inset.left + inset.right) : (inset.top + inset.bottom)
        let side = length / CGFloat(numberOfGridsPerRow)
        guard side > 0.0 else {
            return
        }
        layout.itemSize = CGSize(width: side, height: side * cellRatio)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.sectionInset = inset
        layout.invalidateLayout()
    }
}

