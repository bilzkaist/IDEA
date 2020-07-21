//
//  NotificationViewController.swift
//  Notification
//
//  Created by Bilal Dastagir on 2020/07/21.
//  Copyright © 2020 Bilal Dastagir. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        
        //self.bodyText?.text = notifcation.request.content.body
        //self.headlineText?.text = notifcation
    }

}



