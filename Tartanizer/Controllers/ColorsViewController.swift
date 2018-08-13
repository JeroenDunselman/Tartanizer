//
//  ViewController.swift
//  kleurkiezert
//
//  Created by Jeroen Dunselman on 14/03/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//
//    public let selected = Variable<[Int]>([])
//  private let selectedPhotosSubject = PublishSubject<UIImage>()

import UIKit
import RxSwift

class ColorsViewController: UIViewController {
    
//    private let bag = DisposeBag()
    
    // MARK: private properties
    private let selectedColorIndexesSubject = PublishSubject<Int>()
    var  selectedColorIndexes: Observable<Int> {
        return selectedColorIndexesSubject.asObservable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //    selectedClrIndexesSubject.onCompleted()
    }
    
    private let palet = Palet() //numClrs: 18)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didlood colorsVC")
        
        let pvc: UIPageViewController = self.parent as! UIPageViewController
        let controller = pvc.parent as! ViewController
        controller.subscribeToSelectedColorIndexes(service: self)

//        let controller:
//            EditZonesTableViewController = self.parent as! EditZonesTableViewController
////        let controller = pvc.parent as! ViewController
//        controller.subscribeToSelectedColorIndexes(service: self)
        
        
//        pageController.setViewControllers([viewControllerAtIndex(2)!], direction: .forward, animated: true, completion: nil)
//            [pageController.viewControllers[1]], direction: .forward, animated: true, completion: nil)
        
//        pageController.pageControl.currentPage = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ColorsViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return palet.clrs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedColorIndexesSubject.onNext(indexPath.row) //image)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath)
        
        cell.backgroundColor = palet.clrs[indexPath.row]
        return cell //as TVCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return   self.tableView.frame.size.height / CGFloat(palet.clrs.count)
    }
}

//            selectedColorIndexesSubject
//                .subscribe(onNext: { [weak self] newColorIndex in
//
//                    self?.selected.value.append(newColorIndex)
//
//                    }, onDisposed: {
//                        print("completed photo selection")
//                })
//                .disposed(by: bag)
