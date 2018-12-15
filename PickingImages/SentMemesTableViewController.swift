//
//  SentMemesViewController.swift
//  PickingImages
//
//  Created by Michael Chavez on 12/12/18.
//  Copyright © 2018 SDM. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    func configureMemeLabel(_ label:UILabel){
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tmpCell: MemeTableViewCell
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") {
            tmpCell = cell as! MemeTableViewCell
        } else {
            tmpCell = UITableViewCell(style: .default, reuseIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        }
        let row = (indexPath as NSIndexPath).row
        
        tmpCell.memeImage.image =  memes[ row ].memedImage
        tmpCell.topLabel.text = memes[ row ].topText
        tmpCell.bottomLabel.text = memes[row].bottomText
    
        return tmpCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let meme = self.memes[ (indexPath as NSIndexPath).row ]
        vc.meme = meme
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = CGFloat(100.00)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SentMemesTableViewController.addMeme))
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }
    
    @objc func addMeme(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createController = storyboard.instantiateViewController(withIdentifier: "MemeCreatorViewController")
        self.present(createController,animated: true, completion: nil)
        
    }
    
}
