//
//  StartViewController.swift
//  ParseStarterProject-Swift
//
//  Created by 陳駿逸 on 2018/8/20.
//  Copyright © 2018年 Parse. All rights reserved.
//

import UIKit
import TweenController
import ParseUI

protocol StartViewControllerDelegate {
    func userDidLogined()
}

//private var foo: Void = {
//    // Do this once
//    let (tc, scrollView) = TutorialBuilder.buildWithContainerViewController(self)
//    tweenController = tc
//    scrollView = scrollView
//    scrollView.delegate = self
//}()

class StartViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var artView: ArtView!
    var pageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 取得螢幕的尺寸
        let fullSize = UIScreen.main.bounds.size
        scrollView.contentSize = CGSize(width: fullSize.width*2, height: fullSize.height*2)
        scrollView.delegate = self
        
        // 建立兩個View
        for i in 0...1 {
            artView.tag = i + 10
            artView.center = CGPoint(x: fullSize.width * (0.5 + CGFloat(i)), y: fullSize.height * 0.5)
            artView.artImage.image = UIImage(named: "Art_\(i+1)")
            if i == 0 {
                artView.artTitle.text = "Social for Your Pet"
                artView.artContent.text = "Bring together pet owners and animal lovers from all over the country!"
            } else if i == 1 {
                artView.artTitle.text = "Show up Your Pet's Live"
                artView.artContent.text = "Create your Pet's profile & share their stories to all"
            }
            let view = artView
            scrollView.addSubview(view!)
        }
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
