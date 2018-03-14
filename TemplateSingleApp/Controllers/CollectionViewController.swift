//
//  ViewController.swift
//  PizzaCheese
//
//  Created by etudiant on 13/02/2018.
//  Copyright © 2018 etudiant. All rights reserved.
//

import UIKit
import RxSwift

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    @IBOutlet weak var mainCollectionView: UICollectionView!
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    private let viewModel = CollectionViewModel()
    private let viewLayout = CollectionViewLayout()
    private let disposeBag = DisposeBag()
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        
        self.viewLayout.delegate = self
        
        CustomCollectionViewCell.register(to: self.mainCollectionView)
       
        self.addRxObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func addRxObservers() {
        
        self.viewModel.items.asObservable().subscribe(onNext: {
            
            products in
            
            self.mainCollectionView.reloadData()
            
        } ).disposed(by: self.disposeBag)
        
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// MARK: UICollectionView
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier(), for: indexPath) as? CustomCollectionViewCell else {
            
            
            fatalError("Expected \(CustomCollectionViewCell.reuseIdentifier()) in this CollectionView")
        }
        
        //  Set a closure handler for the share action
        cell.shareActionHandler = {
        
            cell in
            
            //  do something
        }
        
        cell.textExample = self.viewModel.textExample(atIndex: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.viewLayout.sizeForItemAt(collectionView, sizeForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return self.viewLayout.minimumLineSpacingForSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return self.viewLayout.minimumInteritemSpacingForSectionAt()
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
}

