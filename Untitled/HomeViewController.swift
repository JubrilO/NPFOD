//
//  HomeViewController.swift
//  Untitled
//
//  Created by Jubril on 10/02/2019.
//  Copyright © 2019 HelloWorld. All rights reserved.
//

import UIKit
import Spring
class HomeViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet  var synopsisBottomConstraint: NSLayoutConstraint!
    @IBOutlet  var synopsisTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondStartButton: UIButton!
    @IBOutlet weak var secondParagraphLabel: SpringLabel!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var synopsisImage: UIImageView!
    @IBOutlet weak var cancelButton: SpringButton!
    @IBOutlet weak var firstParagraphLabel: SpringLabel!
    @IBOutlet weak var startExhibition: SpringButton!
    @IBOutlet weak var readSynopsisButton: SpringButton!
    var performedAnimation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIntialState()
    }
    
    func setupIntialState() {
        
        cancelButton.alpha = 0
        firstParagraphLabel.alpha = 0
        synopsisImage.alpha = 0
        secondParagraphLabel.alpha = 0
        secondStartButton.alpha = 0
        readSynopsisButton.alpha = 0
        startExhibition.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        synopsisTopConstraint.isActive = false
        synopsisBottomConstraint.isActive = false
        view.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !performedAnimation {
            readSynopsisButton.animation = "fadeInUp"
            startExhibition.animation = "fadeInUp"
            startExhibition.delay = 0.15
            readSynopsisButton.animate()
            startExhibition.animate()
            performedAnimation = true
        }
    }
    
    @IBAction func onReadButtonTap(_ sender: UIButton) {
        //Scroll view by 153 pts
        scrollView.setContentOffset(CGPoint(x: 0, y: 153), animated: true)
        cancelButton.animation = "fadeInDown"
        cancelButton.animate()
        readSynopsisButton.animation = "fadeOut"
        readSynopsisButton.animate()
        startExhibition.animation = "fadeOut"
        startExhibition.animate()
        synopsisTopConstraint.isActive = true
        synopsisBottomConstraint.isActive = true
        synopsisImage.alpha = 1
        secondStartButton.alpha = 1
        view.layoutIfNeeded()
        firstParagraphLabel.animation = "fadeInUp"
        firstParagraphLabel.animate()
        secondParagraphLabel.animation = "fadeInUp"
        secondParagraphLabel.animate()
        
    }
    
    @IBAction func onStartExhibitionButtonTap(_ sender: UIButton) {
        let galleryVC = storyboard?.instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        present(galleryVC, animated: true)
    }
    
    @IBAction func onCancelButtonTap(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)

        cancelButton.animation = "fadeOutUp"
        cancelButton.animate()
        
        firstParagraphLabel.opacity = 0
        secondParagraphLabel.opacity = 0
        secondParagraphLabel.animation = "slideDown"
        //secondParagraphLabel.animate()
        readSynopsisButton.animation = "fadeInDown"
        readSynopsisButton.animate()
        startExhibition.animation = "fadeInDown"
        startExhibition.animate()
        
        SpringView.animate(withDuration: 0.3, animations: {
            self.firstParagraphLabel.alpha = 0
            self.cancelButton.alpha = 0
            self.secondParagraphLabel.alpha = 0
            self.secondStartButton.alpha = 0
            self.synopsisImage.alpha = 0
        })
        delay(delay: 0.5, closure: {
            self.synopsisTopConstraint.isActive = false
            self.synopsisBottomConstraint.isActive = false
            self.view.layoutIfNeeded()
        })
        
        
        
    }
}
