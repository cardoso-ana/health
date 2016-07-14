//
//  SignUpViewController.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/12/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController
{

    @IBOutlet weak var gradientView: UIView!
    
    let gradientlayer = CAGradientLayer()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        gradientlayer.frame = gradientView.frame
        gradientlayer.colors = [UIColor.init(red: 141, green: 253, blue: 190, alpha: 0.5), UIColor.init(white: 0, alpha: 50)]
        gradientView.layer.addSublayer(gradientlayer)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

