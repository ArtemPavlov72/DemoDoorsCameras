//
//  CameraCell.swift
//  DemoDoorsCameras
//
//  Created by Artem Pavlov on 04.08.2023.
//

import UIKit

class CameraCell: UICollectionViewCell, SelfConfiguringCell {

  //MARK: - Static Properties

  static let reuseId: String = "camerasCell"

  //MARK: - Private Properties

  private let cameraName = UILabel()
  private let recImage = UIImageView()
  private let favoriteImage = UIImageView()

  private lazy var cameraImage: ImageView = {
    let view = ImageView()
    view.contentMode = .scaleAspectFill
    view.clipsToBounds = true
    view.layer.cornerRadius = 15
    view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    return view
  }()

  private let backgroundColorView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 15
    return view
  }()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupElements(backgroundColorView, cameraImage, recImage, favoriteImage, cameraName)
    setupSubViews(backgroundColorView, cameraImage, recImage, favoriteImage, cameraName)
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Configure

  func configure(with data: Any) {
    guard let data = data as? RealmCameraInfo else { return }
    cameraName.text = data.name
    if data.rec {
      recImage.image = UIImage(named: "recImage")
    }
    print("camera \(data.name) - - \(data.rec)")
    if data.favorites {
      favoriteImage.image = UIImage(named: "starImage")

      cameraImage.fetchImage(from: data.snapshot ?? "")
    }
  }

  // MARK: - Setup Constraints

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      backgroundColorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      backgroundColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      backgroundColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      backgroundColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),

      cameraImage.topAnchor.constraint(equalTo: backgroundColorView.topAnchor),
      cameraImage.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor),
      cameraImage.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor),
      cameraImage.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: -60),
      cameraImage.heightAnchor.constraint(equalToConstant: 280),

      recImage.heightAnchor.constraint(equalToConstant: 40),
      recImage.widthAnchor.constraint(equalToConstant: 40),
      recImage.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 5),
      recImage.topAnchor.constraint(equalTo: backgroundColorView.topAnchor, constant: 5),

      favoriteImage.heightAnchor.constraint(equalToConstant: 30),
      favoriteImage.widthAnchor.constraint(equalToConstant: 30),
      favoriteImage.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor, constant: -5),
      favoriteImage.topAnchor.constraint(equalTo: backgroundColorView.topAnchor, constant: 5),

      cameraName.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 16),
      cameraName.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor, constant: -16),
      cameraName.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: -20)
    ])
  }
}
