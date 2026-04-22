//
//  ReservaVC.swift
//  altoquecars
//
//  Created by Jack Yeiden Cabanillas Correa on 20/04/26.
//

import UIKit

class ReservaVC: UIViewController {

    var autoSeleccionado: Auto?

    @IBOutlet weak var imgAuto: UIImageView!
    @IBOutlet weak var lblAuto: UILabel!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtDni: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var dpFechaInicio: UIDatePicker!
    @IBOutlet weak var dpFechaFin: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let auto = autoSeleccionado {
            lblAuto.text = "\(auto.marca) \(auto.modelo)"
            imgAuto.image = UIImage(named: auto.imagen)
        } else {
            lblAuto.text = "Auto no seleccionado"
        }
        
        imgAuto.layer.cornerRadius = 10
        imgAuto.clipsToBounds = true
    }

    @IBAction func btnEnviar(_ sender: UIButton) {
        if txtNombre.text?.isEmpty == true ||
            txtDni.text?.isEmpty == true ||
            txtCorreo.text?.isEmpty == true ||
            txtTelefono.text?.isEmpty == true {

            let alerta = UIAlertController(title: "Error", message: "Completa todos los campos", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
            return
        }

        let alerta = UIAlertController(title: "Éxito", message: "Reserva enviada correctamente", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }
}
