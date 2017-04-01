//
//  ImageViewController.swift
//  Thinh
//
//  Created by Viet Dang Ba on 4/1/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var fullImageView: UIImageView!
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        fullImageView.image = image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
