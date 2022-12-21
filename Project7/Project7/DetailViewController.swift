//
//  DetailViewController.swift
//  Project7
//
//  Created by Дария Григорьева on 21.12.2022.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    private let webView = WKWebView()
    var detailItem: Petition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = webView
        htmlSetup()
    }
    
    private func htmlSetup() {
        guard let detailItem = detailItem else {
            return
        }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 130%; } </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """
   
        webView.loadHTMLString(html, baseURL: nil)
    }
}
