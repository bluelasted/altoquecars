//
//  ReservaVC.swift
//  altoquecars
//
//  Created by Jack Yeiden Cabanillas Correa on 20/04/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ReservaVC: UIViewController {

    var autoSeleccionado: Auto?
    let db = Firestore.firestore()

    @IBOutlet weak var imgAuto: UIImageView!
    @IBOutlet weak var lblAuto: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblKm: UILabel!
    @IBOutlet weak var lblPlaca: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var dpFechaInicio: UIDatePicker!
    @IBOutlet weak var dpFechaFin: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let auto = autoSeleccionado {
            lblAuto.text = "\(auto.marca) \(auto.modelo)"
            imgAuto.image = UIImage(named: auto.imagen)
            lblYear.text = "\(auto.year ?? 0)"
            lblKm.text = "\(auto.km ?? 0) KM"
            lblPlaca.text = "\(auto.placa ?? "AAA111")"
            lblPrecio.text = "$ \(auto.precio)"
        } else {
            lblAuto.text = "Auto no seleccionado"
        }
        
        imgAuto.layer.cornerRadius = 10
        imgAuto.clipsToBounds = true
    }

    @IBAction func btnEnviar(_ sender: UIButton) {
        if false {

            let alerta = UIAlertController(title: "Error", message: "Completa todos los campos", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let autoId = autoSeleccionado?.autoId else {return}
        
        let usuarioRef = db.collection("Usuario").document(uid)
        let autoRef = db.collection("Autos").document(autoId)
        
        let autoData: [String : Any] = [
            "idAuto": autoSeleccionado?.autoId,
            "marca":  autoSeleccionado?.marca,
            "modelo": autoSeleccionado?.modelo,
            "year":   autoSeleccionado?.year,
            "placa":  autoSeleccionado?.placa,
            "km":     autoSeleccionado?.km,
            "precio": autoSeleccionado?.precio,
            "imagen": autoSeleccionado?.imagen
        ]
        
        let reservaData: [String : Any] = [
            "usuario" : usuarioRef,
            "auto" : autoData,
            "fechaInicio": Timestamp(date: dpFechaInicio.date),
            "fechaFin": Timestamp(date: dpFechaFin.date),
            "fechaReserva": Timestamp(date: Date())
        ]
        
        guard let auto = autoSeleccionado else {
            let alerta = UIAlertController(title: "Error", message: "No se seleccionó ningún auto", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
            return
        }
        
        //
        let nuevaReservaRef = db.collection("Reservas").document()

        // 2. Batch — escribe todo junto o nada
        let batch = db.batch()

        // 3. Guardar la reserva
        batch.setData(reservaData, forDocument: nuevaReservaRef)

        // 4. Agregar el ID de la reserva al array del usuario
        batch.updateData([
            "Reservas": FieldValue.arrayUnion([nuevaReservaRef.documentID])  // 👈 agrega sin pisar los anteriores
        ], forDocument: usuarioRef)
        
        batch.commit { error in
            DispatchQueue.main.async {
                if let error = error {
                    let alerta = UIAlertController(title: "Error", message: "No se pudo guardar: \(error.localizedDescription)", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alerta, animated: true)
                } else {
                    let alerta = UIAlertController(title: "Éxito", message: "Reserva enviada correctamente", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        //self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alerta, animated: true)
                }
            }
        }
        //
        /*
        db.collection("Reservas").addDocument(data:reservaData){
            error in
            if let error = error {
                let alerta = UIAlertController(title: "Error", message: "No se pudo guardar la reserva: \(error.localizedDescription)", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alerta, animated: true)
                return
            } else {
                let alerta = UIAlertController(title: "Éxito", message: "Reserva enviada correctamente", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in

                })
                self.present(alerta, animated: true)
            }
        }*/
        /*
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        let fechaInicio = formatter.string(from: dpFechaInicio.date)
        let fechaFin = formatter.string(from: dpFechaFin.date)
        
        let ref = db.collection("Reservas").document()
        
        ref.setData([
            "idReserva": ref.documentID,
            "fechaInicio": fechaInicio,
            "fechaFin": fechaFin,
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
         */
    }
    
    func limpiarCampos() {

    }
}
