//
//  DoorCell.swift
//  DemoDoorsCameras
//
//  Created by Artem Pavlov on 04.08.2023.
//

import UIKit

class DoorCell: UICollectionViewCell, SelfConfiguringCell {

  //MARK: - Static Properties

  static let reuseId: String = "doorCell"

  //MARK: - Private Properties

  private let doorName = UILabel()
  private let lockImage = UIImageView()

  private lazy var cameraImage: ImageView = {
    let view = ImageView()
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
    guard let data = data as? RealmDoorInfo else { return }
    doorName.text = data.name
    lockImage.image = UIImage(named: "lockImage")
    cameraImage.fetchImage(from: data.snapshot ?? "")
  }

  // MARK: - Setup Constraints

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      backgroundColorView.topAnchor.constraint(equalTo: self.topAnchor),
      backgroundColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      backgroundColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      backgroundColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

      cameraImage.topAnchor.constraint(equalTo: backgroundColorView.topAnchor),
      cameraImage.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor),
      cameraImage.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor),
      cameraImage.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: -60),

      doorName.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 16),
      doorName.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: -20),

      lockImage.heightAnchor.constraint(equalToConstant: 30),
      lockImage.widthAnchor.constraint(equalToConstant: 30),
      lockImage.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor, constant: -16),
      lockImage.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: -20),
      ])
  }
}
