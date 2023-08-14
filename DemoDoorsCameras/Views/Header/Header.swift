//
//  Header.swift
//  DemoDoorsCameras
//
//  Created by Artem Pavlov on 04.08.2023.
//

import UIKit

class Header: UICollectionReusableView {

  static let reuseId: String = "headerSectionId"

  var categories: [String] = []
  private var selectedCategory: Int = 0
  var delegate: MainViewControllerDelegate?

  private var collectionView: UICollectionView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupCollectionView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  private func setupCollectionView() {
    collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(collectionView)
    collectionView.backgroundColor = .systemGray6
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.reuseId)
  }

  private func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
      return self.createSection()
    }

    let config = UICollectionViewCompositionalLayoutConfiguration()
    layout.configuration = config

    return layout
  }

  private func createSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let layoutSection = NSCollectionLayoutSection(group: group)
    layoutSection.orthogonalScrollingBehavior = .continuous

    return layoutSection
  }
}

// MARK: - UICollectionViewDataSource

extension Header: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    categories.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.reuseId, for: indexPath) as? HeaderCell else { return HeaderCell()}
    cell.configureCell(with: categories[indexPath.item])

    if selectedCategory == indexPath.item {
      cell.configureSelectedAppearance()
    } else {
      cell.configureStandartAppearance()
    }
    return cell
  }
}

extension Header: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.didSelectCategory(indexPath.item)
    selectedCategory = indexPath.item
    collectionView.reloadData()
  }
}
