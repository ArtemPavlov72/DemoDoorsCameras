//
//  DoorCell.swift
//  DemoDoorsCameras
//
//  Created by Артем Павлов on 04.08.2023.
//

import UIKit

class DoorCell: UICollectionViewCell, SelfConfiguringCell {

  //MARK: - Static Properties

  static let reuseId: String = "doorCell"

  //MARK: - Private Properties

  private let doorName = UILabel()
  private let lockImage = UIImageView()

  private lazy var cameraImage: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFill
    view.clipsToBounds = true
    view.layer.cornerRadius = 15
    view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    return view
  }()

  private var backgroundColorView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 15
    return view
  }()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupElements(backgroundColorView, cameraImage, doorName, lockImage)
    setupSubViews(backgroundColorView, cameraImage, doorName, lockImage)
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Configure

  func configure(with data: Any) {
    guard let data = data as? DoorInfo else { return }
    getImage(from: data.snapshot)
    doorName.text = data.name
    lockImage.image = UIImage(named: "lockImage")
  }

  private func getImage(from url: String?) {
    DispatchQueue.global().async {
      guard let imageData = ImageManager.shared.loadImage(from: url) else {return}
      DispatchQueue.main.async {
        self.cameraImage.image = UIImage(data: imageData)
      }
    }
  }

  // MARK: - Setup Constraints

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      backgroundColorView.topAnchor.constraint(equalTo: self.topAnchor),
      backgroundColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      backgroundColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      backgroundColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

      cameraImage.topAnchor.constraint(equalTo: backgroundColorView.topAnchor, constant: 0),
      cameraImage.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor),
      cameraImage.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor),

      doorName.topAnchor.constraint(equalTo: cameraImage.bottomAnchor, constant: 20),
      doorName.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 16),
      doorName.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: -20),

      lockImage.heightAnchor.constraint(equalToConstant: 30),
      lockImage.widthAnchor.constraint(equalToConstant: 30),
      lockImage.topAnchor.constraint(equalTo: cameraImage.bottomAnchor, constant: 20),
      lockImage.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor, constant: -16),
      lockImage.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: -30),
      ])
  }
}
