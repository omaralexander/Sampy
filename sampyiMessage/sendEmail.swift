//
//  sendEmail.swift
//  sampyiMessage
//
//  Created by Omar Abbas on 11/24/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import MessageUI
class sendEmail: UIViewController, MFMailComposeViewControllerDelegate {
    

    var message = String()
    let composer = MFMailComposeViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["sampyteam@gmail.com"])
        composer.setSubject("Report filed against user")
        composer.setMessageBody(message, isHTML: false)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result{
        case .cancelled:
            
            break
        case .saved:
            
            break
        case .sent:
            
            break
        case .failed:
            
            break
        }
        performSegue(withIdentifier: "backToReportEmail", sender: self)
    }
    override func viewDidLayoutSubviews() {
        self.view.frame.origin.y = self.topLayoutGuide.length * 5
        self.view.addSubview(composer.view)
    }
    
}
