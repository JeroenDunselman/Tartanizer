//
//  ViewController.swift
//  PageViewController
//
//  Created by Miguel Fermin on 5/8/17.
//  Copyright © 2017 MAF Software LLC. All rights reserved.
//

import UIKit
import RxSwift 

class ViewController: UIViewController {
    let bag = DisposeBag()

    public var viewControllers: [UIViewController]!
    var pageViewController: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = initVCs()
        setupPageController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupPageController() {
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        
        //enable subscribe parent..
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        //        ...before setting!
        pageViewController.setViewControllers([viewControllerAtIndex(0)!], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        
        pageViewController!.view.frame = view.bounds
        pageViewController.didMove(toParentViewController: self)
        
        // Add the page view controller's gesture recognizers to the view controller's view so that the gestures are started more easily.
        view.gestureRecognizers = pageViewController.gestureRecognizers
    }
    
    func initVCs() -> [UIViewController] {
        let pickerVC = storyboard!.instantiateViewController(withIdentifier: "PickerVC") as! ColorPickerTableViewController
        pickerVC.assets = ColorPickerViewModel(client: pickerVC)
        pickerVC.assets?.subscribeToSelectedColorIndexes()
        
        let libraryVC = storyboard!.instantiateViewController(withIdentifier: "LibraryTVC") as! TartanLibraryTableViewController
        libraryVC.assets.subscribeToSelectedColorIndexes(colorPickerModel: pickerVC.assets!)
        
        let assetsVC = storyboard!.instantiateViewController(withIdentifier: "AssetsTVC") as! ColorPickedAssetsTableViewController
        assetsVC.assets = ColorPickedAssetsViewModel(client: assetsVC)
        assetsVC.assets?.subscribeToSelectedColorIndexes(service: pickerVC.assets!)
        
        return [ libraryVC, pickerVC, assetsVC]
    }

}

// MARK: - UIPageViewController DataSource and Delegate

extension ViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == viewControllers.count {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

// MARK: - Helpers

extension ViewController {
    fileprivate func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if viewControllers.count == 0 || index >= viewControllers.count {
            return nil
        }
        return viewControllers[index]
    }
    
    fileprivate func indexOfViewController(_ viewController: UIViewController) -> Int {
        return viewControllers.index(of: viewController) ?? NSNotFound
    }
    
}

