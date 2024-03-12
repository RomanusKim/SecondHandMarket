//
//  ZipCodeViewController.swift
//  SecondHandMarket
//
//  Created by romanus on 3/12/24.
//

import Foundation
import WebKit

class ZipCodeViewController : UIViewController {
    weak var delgate: ZipCodeDelegate?
    
    
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)
    var myAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
           view.backgroundColor = .white
           setAttributes()
           setContraints()
       }

       private func setAttributes() {
           let contentController = WKUserContentController()
           contentController.add(self, name: "callBackHandler")

           let configuration = WKWebViewConfiguration()
           configuration.userContentController = contentController

           webView = WKWebView(frame: .zero, configuration: configuration)
           self.webView?.navigationDelegate = self

           guard let url = URL(string: "https://romanuskim.github.io/romanus.github.io/"),
               let webView = webView
               else { return }
           let request = URLRequest(url: url)
           webView.load(request)
           indicator.startAnimating()
       }

       private func setContraints() {
           guard let webView = webView else { return }
           view.addSubview(webView)
           webView.translatesAutoresizingMaskIntoConstraints = false

           webView.addSubview(indicator)
           indicator.translatesAutoresizingMaskIntoConstraints = false

           NSLayoutConstraint.activate([
               webView.topAnchor.constraint(equalTo: view.topAnchor),
               webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

               indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
               indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
           ])
       }
}

extension ZipCodeViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: Any] {
            myAddress = data["bname"] as? String ?? ""
            }
        delgate?.didReceive(address: myAddress)
            self.dismiss(animated: true, completion: nil)
        }
}

extension ZipCodeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            indicator.startAnimating()
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            indicator.stopAnimating()
        }
}
