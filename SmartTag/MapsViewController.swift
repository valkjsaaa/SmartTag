//
//  MapsViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/22/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit
import CoreData

class MapsViewController: UIViewController {
    
    let cellRowCount = 16
    let cellColCount = 16
    let deliveryCount = 3
    let backgroundImage = #imageLiteral(resourceName: "Image")
    let spacing = CGFloat(4.0)
    let gridCellIdentifier = "defaultCell"
    let trackerCellIdentifier = "trackedItem"
    let presentStatePickerSegueIdentifier = "presentStatePicker"
    let popupReserveInstanceViewControllerSegueIdentifier = "popupReserveInstanceViewController"
    let popupReserveDeliveryViewControllerSegueIdentifier = "popupReserveDeliveryViewController"
    
    var managedObjectContext: NSManagedObjectContext!
    
    var delegate: MapsViewDelegate?
    private var mapsDate: ReservationDate?
    var reservations: [[ReservationInstance?]]?
    var deliverys: [ReservationDelivery?]?
    var allTrackedItems: [TrackedItem]!
    var trackedItems: [TrackedItem]!
    
    public var date: ReservationDate? {
        set(newDate) {
            self.mapsDate = newDate
            refreshDate()
        }
        get {
            return mapsDate
        }
    }
    
    public var showGridLines: Bool {
        set(newShowGridLines) {
            self.gridLinesView.isHidden = !newShowGridLines
        }
        get {
            return !self.gridLinesView.isHidden
        }
    }
    
    public var showItmes: Bool {
        set(newShowItems) {
            trackerItemsView.isHidden = !newShowItems
        }
        get {
            return !trackerItemsView.isHidden
        }
    }
    
    public var showMyItems: Bool = false
    public var showCriticalItems: Bool = false
    public var showItemsToMove: Bool = false
    
    public var showDelivery: Bool {
        set(newShowDelivery) {
            self.deliveryView.isHidden = !newShowDelivery
        }
        get {
            return !self.self.deliveryView.isHidden
        }
    }
    
    struct MapCellColor {
        static let Available = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        static let Reserved = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        static let Occupied = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        static let Blocked = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }

    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var statePickerAnchorPoint: UIButton!
    @IBOutlet weak var gridLinesView: UICollectionView!
    @IBOutlet weak var trackerItemsView: UICollectionView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet var deliveryRegions: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionViewFlowLayout.itemSize = CGSize(width: backgroundImage.size.width / CGFloat(cellColCount) - spacing,
                                                   height: backgroundImage.size.height / CGFloat(cellRowCount) - spacing)
        collectionViewFlowLayout.minimumLineSpacing = spacing
        collectionViewFlowLayout.minimumInteritemSpacing = spacing
        collectionViewFlowLayout.sectionInset.left = spacing / 2.0
        collectionViewFlowLayout.sectionInset.top = spacing / 2.0
        
        if mapsDate == nil {
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            mapsDate = ReservationDate.getAllDatesSorted(context: managedObjectContext)[0]
        }
        try! allTrackedItems = managedObjectContext.fetch(TrackedItem.fetchRequest())
        refreshDate()
        if let initialGridLineShown = self.delegate?.initialGridLineShown {
            self.showGridLines = initialGridLineShown
        }
        if let initialDeliveryShown = self.delegate?.initialDeliveryShown {
            self.showDelivery = initialDeliveryShown
        }
        if let initialShowItems = self.delegate?.initialShowItems {
            self.showItmes = initialShowItems
        }
        refreshTrackedItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshDate()
    }
    
    func refreshTrackedItems() {
        trackedItems = []
        for item in allTrackedItems {
            if showCriticalItems == false || item.urgent == true {
                if showMyItems == false || item.mine == true {
                    if showItemsToMove == false || item.toMove == true {
                        trackedItems.append(item)
                    }
                }
            }
        }
        (self.trackerItemsView.collectionViewLayout as! TrackerViewLayout).trackers = trackedItems
        self.trackerItemsView.reloadData()
    }
    
    func refreshDate() {
        reservations = Array.init(repeating: Array.init(repeating: nil, count: cellColCount), count: cellRowCount)
        for instance in mapsDate!.reservedInstances! {
            if instance.x >= 0 && instance.x < Int16(reservations!.count) {
                if instance.y >= 0 && instance.y < Int16(reservations![Int(instance.x)].count) {
                    reservations![Int(instance.x)][Int(instance.y)] = instance
                } else {
                    print("Illegal Instance!!!")
                    mapsDate?.removeFromReservedInstances(instance)
                }
            } else {
                print("Illegal Instance!!!")
                mapsDate?.removeFromReservedInstances(instance)
            }
        }
        deliverys = Array.init(repeating: nil, count: deliveryCount)
        for deliveryInstance in mapsDate!.reservedDelivery! {
            if deliveryInstance.which >= 0 && Int(deliveryInstance.which) < deliveryCount {
                deliverys![Int(deliveryInstance.which)] = deliveryInstance
            } else {
                print("Illegal Instance!!!")
                mapsDate?.removeFromReservedDelivery(deliveryInstance)
            }
        }
        gridLinesView.reloadData()
        for button in deliveryRegions {
            if let state = deliverys?[button.tag]?.type {
                switch state {
                case .Available:
                    button.backgroundColor = MapCellColor.Available
                case .Reserved:
                    button.backgroundColor = MapCellColor.Reserved
                case .Occupied:
                    button.backgroundColor = MapCellColor.Occupied
                case .Blocked:
                    button.backgroundColor = MapCellColor.Blocked
                }
            }
        }
    }

    @IBAction func selectedDeliveryRegion(_ sender: UIButton) {
        statePickerAnchorPoint.center = CGPoint(x: sender.center.x,
                                                y: sender.center.y)
        performSegue(withIdentifier: popupReserveDeliveryViewControllerSegueIdentifier, sender: sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == popupReserveDeliveryViewControllerSegueIdentifier {
            let destination = segue.destination as! ReserveDelieveryViewController
            let sender = sender as! UIButton
            destination.delegate = self
            destination.deliveryInstance = deliverys![sender.tag]
        }
        
        if segue.identifier == popupReserveInstanceViewControllerSegueIdentifier {
            let destination = segue.destination as! ReserveInstanceViewController
            let sender = sender as! MapCell
            destination.delegate = self
            destination.reserveInstance = reservations![sender.index.0][sender.index.1]
        }
    }
    
    

}

class MapCell: UICollectionViewCell {
    var index: (Int, Int)!
}

class TrackerCell: UICollectionViewCell {
    var trackerItem: TrackedItem!
}

extension MapsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            let currentCell = collectionView.cellForItem(at: indexPath)!
            statePickerAnchorPoint.center = CGPoint(x: currentCell.center.x + collectionView.contentOffset.x,
                                                    y: currentCell.center.y + collectionView.contentOffset.y)
            performSegue(withIdentifier: popupReserveInstanceViewControllerSegueIdentifier, sender: currentCell)
        }
    }
}

extension MapsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return cellRowCount * cellColCount
        } else if collectionView.tag == 1 {
            return trackedItems!.count
        }
        fatalError()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellIdentifier, for: indexPath) as! MapCell
            assert(indexPath.row < cellColCount * cellRowCount)
            cell.index = (indexPath.row % cellColCount, indexPath.row / cellColCount)
            if let reservation = reservations![cell.index.0][cell.index.1] {
                switch reservation.type {
                case .Available:
                    cell.backgroundColor = MapCellColor.Available
                case .Reserved:
                    cell.backgroundColor = MapCellColor.Reserved
                case .Occupied:
                    cell.backgroundColor = MapCellColor.Occupied
                case .Blocked:
                    cell.backgroundColor = MapCellColor.Blocked
                }
            } else {
                cell.backgroundColor = MapCellColor.Available
            }
            return cell
        } else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trackerCellIdentifier, for: indexPath) as! TrackerCell
            cell.trackerItem = trackedItems[indexPath.row]
            return cell
        }
        fatalError()
    }
}

class TrackerViewLayout: UICollectionViewLayout {
    var trackers: [TrackedItem]?
    var attributes: [UICollectionViewLayoutAttributes]?
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.bounds.width, height: collectionView!.bounds.height)
    }
    
    override func prepare() {
        if let trackers = trackers {
            attributes = []
            for (i, tracker) in trackers.enumerated() {
                let attribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: i, section: 0))
//                attribute.center = CGPoint(x: Double(tracker.latitude), y: Double(tracker.longitude))
//                attribute.bounds = CGRect(x: CGFloat(tracker.latitude), y: CGFloat(tracker.longitude), width: 50, height: 50)
                attribute.frame = CGRect(x: CGFloat(tracker.latitude), y: CGFloat(tracker.longitude), width: 50, height: 50)
//                attribute.size = CGSize(width: 50, height: 50)
                attributes?.append(attribute)
            }
        } else {
            attributes = nil
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = attributes {
            return attributes[indexPath.row]
        }
        return nil
    }
}

@objc protocol MapsViewDelegate {
    
    @objc optional var initialDate: ReservationDate {
        get
    }

    @objc optional var initialShowItems: Bool {
        get
    }
    
    @objc optional var initialGridLineShown: Bool {
        get
    }

    @objc optional var initialDeliveryShown: Bool {
        get
    }
    
    @objc optional var dashboard: Bool {
        get
    }
}
