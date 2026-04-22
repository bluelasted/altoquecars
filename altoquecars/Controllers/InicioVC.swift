//
//  InicioVC.swift
//  altoquecars
//
//  Created by Jack Yeiden Cabanillas Correa on 22/04/26.
//

import UIKit

class InicioVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.irAlLogin()
        }
    }

    func irAlLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.modalTransitionStyle = .crossDissolve
            self.present(loginVC, animated: true)
        }
    }
}
