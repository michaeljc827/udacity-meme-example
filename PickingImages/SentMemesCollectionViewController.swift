//
//  SentMemesCollectionViewController.swift
//  PickingImages
//
//  Created by Michael Chavez on 12/12/18.
//  Copyright © 2018 SDM. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Create Right Bar + button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SentMemesCollectionViewController.addMeme))
        
        //Set Collection View Layout properties
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView!.reloadData()
    }
    
    @objc func addMeme(){
            
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createController = storyboard.instantiateViewController(withIdentifier: "MemeCreatorViewController")
        self.present(createController,animated: true, completion: nil)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[ (indexPath as NSIndexPath).row ]
 
        cell.memeImage?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let vc = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        vc.meme = memes[ (indexPath as NSIndexPath).row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
