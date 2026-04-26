//
//  Usuario.swift
//  altoquecars
//
//  Created by Jairo on 11/04/26.
//

import Foundation

struct Usuario{
    let correo: String
    let clave: String?
    let nombres: String?
    let fechaNac: Date?
    let dni: String?
    let telefono: String?
    let reservas: [Reserva]?
}
