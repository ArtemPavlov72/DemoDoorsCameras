//
//  HeaderCell.swift
//  DemoDoorsCameras
//
//  Created by Артем Павлов on 04.08.2023.
//

import UIKit

class HeaderCell: UICollectionViewCell {

  //MARK: - Static Properties
  static let reuseId: String = "header"

  //MARK: - Public Properties
  private let categoryLabel = UILabel()
  private let bottomView = UIView()


  //MARK: - Cell Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupElements(categoryLabel, bottomView)
    setupSubViews(categoryLabel, bottomView)
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Public Methods
  func configureCell(with category: String) {
    categoryLabel.text = category
  }

  func configureSelectedAppearance() {
    bottomView.backgroundColor = .systemBlue
  }

  func configureStandartAppearance() {
    bottomView.backgroundColor = .systemGray4
  }


  // MARK: - Setup Constraints
  private func setupConstraints() {
    NSLayoutConstraint.activate([
    categoryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
    categoryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),

    bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
    bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
    bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
    bottomView.heightAnchor.constraint(equalToConstant: 2)
    ])
  }
}
