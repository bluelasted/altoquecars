
import UIKit
import FirebaseAuth

class HomeVendedorVC: UIViewController {

    @IBOutlet weak var lblVendedor: UILabel!
    
    var correo: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        lblVendedor.text = "BIENVENIDO VENDEDOR \(correo)"
    }
    @IBAction func btnCerrarSesion(_ sender: UIButton) {
            do {
                try Auth.auth().signOut()
                dismiss(animated: true)
            } catch {
                let alerta = UIAlertController(title: "Error", message: "No se pudo cerrar sesión", preferredStyle: .alert)
                let accion = UIAlertAction(title: "OK", style: .default)
                alerta.addAction(accion)
                present(alerta, animated: true)
            }
        }
    }
