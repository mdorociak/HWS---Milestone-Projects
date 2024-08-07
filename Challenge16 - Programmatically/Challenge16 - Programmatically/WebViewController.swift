//
//  WebViewController.swift
//  Challenge16 - Programmatically
//
//  Created by lz on 06/08/2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView: WKWebView!
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        
        webView.load(URLRequest(url: url))
    }
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
}
