//
//  SelfConfiguringCell.swift
//  DemoDoorsCameras
//
//  Created by Артем Павлов on 04.08.2023.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure(with data: Any)
}
