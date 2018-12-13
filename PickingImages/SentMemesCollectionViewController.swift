//
//  SentMemesCollectionViewController.swift
//  PickingImages
//
//  Created by Michael Chavez on 12/12/18.
//  Copyright © 2018 SDM. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(SentMemesCollectionViewController.addMeme) )
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
        
    }
    
    @objc func addMeme(){
        if let navigationController = self.navigationController {
            let createController = MemeCreatorViewController()
            navigationController.pushViewController(createController, animated: true)
        }
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let memeCount = memes?.count {
            return memeCount
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[ (indexPath as NSIndexPath).row ]
        
        cell.memeImage?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
    }
    
}
