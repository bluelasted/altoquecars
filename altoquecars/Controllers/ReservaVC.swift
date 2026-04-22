//
//  ReservaVC.swift
//  altoquecars
//
//  Created by Jack Yeiden Cabanillas Correa on 20/04/26.
//

import UIKit
import FirebaseFirestore

class ReservaVC: UIViewController {

    var autoSeleccionado: Auto?
    let db = Firestore.firestore()

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
        
        guard let auto = autoSeleccionado else {
            let alerta = UIAlertController(title: "Error", message: "No se seleccionó ningún auto", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        let fechaInicio = formatter.string(from: dpFechaInicio.date)
        let fechaFin = formatter.string(from: dpFechaFin.date)
        
        let ref = db.collection("Reservas").document()
        
        ref.setData([
            "idReserva": ref.documentID,
            "nombre": txtNombre.text ?? "",
            "dni": txtDni.text ?? "",
            "correo": txtCorreo.text ?? "",
            "telefono": txtTelefono.text ?? "",
            "fechaInicio": fechaInicio,
            "fechaFin": fechaFin,
            "autoMarca": auto.marca,
            "autoModelo": auto.modelo,
            "autoImagen": auto.imagen,
            "autoPrecio": auto.precio
        ]) { error in
            if let error = error {
                let alerta = UIAlertController(title: "Error", message: "No se pudo guardar la reserva: \(error.localizedDescription)", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alerta, animated: true)
            } else {
                let alerta = UIAlertController(title: "Éxito", message: "Reserva enviada correctamente", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.limpiarCampos()
                })
                self.present(alerta, animated: true)
            }
        }
    }
    
    func limpiarCampos() {
        txtNombre.text = ""
        txtDni.text = ""
        txtCorreo.text = ""
        txtTelefono.text = ""
    }
}
