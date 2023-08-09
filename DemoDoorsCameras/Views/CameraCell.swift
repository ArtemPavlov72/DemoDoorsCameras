//
//  CameraCell.swift
//  DemoDoorsCameras
//
//  Created by Артем Павлов on 04.08.2023.
//

import UIKit

class CameraCell: UICollectionViewCell, SelfConfiguringCell {

  //MARK: - Static Properties

  static let reuseId: String = "camerasCell"

  //MARK: - Private Properties

  private let cameraName = UILabel()

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
    setupElements(backgroundColorView, cameraImage, cameraName)
    setupSubViews(backgroundColorView, cameraImage, cameraName)
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Configure

  func configure(with data: Any) {
    guard let data = data as? RealmCameraInfo else { return }
    cameraImage.fetchImage(from: data.snapshot)
   // getImage(from: data.snapshot)
    cameraName.text = data.name
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

      cameraImage.topAnchor.constraint(equalTo: backgroundColorView.topAnchor),
      cameraImage.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor),
      cameraImage.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor),
      cameraImage.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: -60),

      cameraName.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 16),
      cameraName.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor, constant: -16),
      cameraName.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: -20)
      ])
  }
}
