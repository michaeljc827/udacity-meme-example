//
//  SentMemesCollectionViewController.swift
//  PickingImages
//
//  Created by Michael Chavez on 12/12/18.
//  Copyright © 2018 SDM. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    @IBOutlet var collectionViewOutlet: UICollectionView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SentMemesCollectionViewController.addMeme))
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
        
        print("Determining rows \(self.memes.count)")

        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[ (indexPath as NSIndexPath).row ]
 
        print("Creating cell")
        
        cell.memeImage?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
    }
    
}
