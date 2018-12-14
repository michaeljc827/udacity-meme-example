//
//  MemeDetailViewController.swift
//  PickingImages
//
//  Created by Michael Chavez on 12/14/18.
//  Copyright © 2018 SDM. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memeDetailImageView.image = meme.memedImage 
    }
    
}
