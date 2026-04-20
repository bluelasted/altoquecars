import UIKit
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //para que no se vea xd jen
        tfPassword.isSecureTextEntry = true
    }

    @IBAction func btnIngresar(_ sender: UIButton){
        let correo = tfCorreo.text!
        let password = tfPassword.text!
        
        if correo.isEmpty || password.isEmpty{
            self.MostrarAlerta("Debes ingresar tus datos de acceso")
        }else{
            Auth.auth().signIn(withEmail: correo, password: password) { (result, error) in
                if let error = error{
                    self.MostrarAlerta("ERROR : " + error.localizedDescription)
                    return
                }
                
                guard let uid = result?.user.uid else {
                    self.MostrarAlerta("No se pudo obtener el usuario")
                    return
                }
                
                self.db.collection("Usuario").document(uid).getDocument { document, error in
                    if let error = error {
                        self.MostrarAlerta("Error al obtener el rol: " + error.localizedDescription)
                        return
                    }
                    
                    guard let document = document, document.exists else {
                        self.MostrarAlerta("No existe información del usuario")
                        return
                    }
                    
                    let datos = document.data()
                    let rol = datos?["Rol"] as? String ?? "Cliente"
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    if rol == "Vendedor" {
                        if let vendedorVC = storyboard.instantiateViewController(withIdentifier: "HomeVendedor") as? HomeVendedorVC {
                            vendedorVC.correo = correo
                            vendedorVC.modalPresentationStyle = .fullScreen
                            self.present(vendedorVC, animated: true)
                        }
                    } else {
                        if let homeVC = storyboard.instantiateViewController(withIdentifier: "Home") as? HomeVC {
                            homeVC.correo = correo
                            homeVC.modalPresentationStyle = .fullScreen
                            self.present(homeVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnIrRegistro(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let registroVC = storyboard.instantiateViewController(withIdentifier: "RegistroVCController") as? RegistroVCController {
            registroVC.modalPresentationStyle = .fullScreen
            self.present(registroVC, animated: true)
        }
    }

    func MostrarAlerta(_ mensaje:String){
        let alerta = UIAlertController(title: "Alerta login", message: mensaje, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alerta.addAction(action)
        present(alerta, animated: true)
    }
}
