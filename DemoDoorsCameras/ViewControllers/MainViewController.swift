//
//  ViewController.swift
//  DemoDoorsCameras
//
//  Created by Артем Павлов on 03.08.2023.
//

import UIKit
import RealmSwift

protocol MainViewControllerDelegate {
    func didSelectCategory(_ index: Int)
}

class MainViewController: UIViewController {

  // MARK: - Private Properties

  private var cameraData: Camera?
  private var doorData: Door?
  private var categoryIndex = 0
  private var categories: [Category] = []
  private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
  private var collectionView: UICollectionView!

  //MARK: - Life Cycles Methods

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavBar()
    getCategoryData()
    setupCollectionView()
    loadSelectedCategory(catery: categoryIndex)
  }

  //MARK: - Private Methods

  private func setupCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(collectionView)
    collectionView.backgroundColor = .systemGray5

    collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.reuseId)
    collectionView.register(CameraCell.self, forCellWithReuseIdentifier: CameraCell.reuseId)
    collectionView.register(DoorCell.self, forCellWithReuseIdentifier: DoorCell.reuseId)
  }

  private func setupNavBar() {
    title = "Мой дом"
    navigationItem.largeTitleDisplayMode = .never
  }

  private func getCategoryData() {
    let _ = DataManager.shared.createFakeCategoryData().compactMap { categories.append(Category(categoryName: $0)) }
  }

  private func loadSelectedCategory(catery: Int) {
    if categoryIndex == 0 {
      loadCameraData()
    } else {
      loadDoorData()
    }
  }

  private func loadCameraData() {
    NetworkManager.shared.fetchData(dataType: Camera.self, from: "http://cars.cprogroup.ru/api/rubetek/cameras/", completion: { result in
      switch result {
      case .success(let camera):
        self.cameraData = camera
        self.createDataSource()
      case .failure(let error):
        print(error)
      }
    })
  }

  private func loadDoorData() {
    NetworkManager.shared.fetchData(dataType: Door.self, from: "http://cars.cprogroup.ru/api/rubetek/doors/", completion: { result in
      switch result {
      case .success(let door):
        self.doorData = door
        self.createDataSource()
      case .failure(let error):
        print(error)
      }
    })
  }

  // MARK: - Manage the Data

  private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with data: AnyHashable, for indexPath: IndexPath) -> T {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else {
      fatalError("Unable to dequeue \(cellType)")
    }
    cell.configure(with: data)
    return cell
  }

  private func createDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) { [self]
      collectionView, indexPath, _ in

      let sections = Section.allCases[indexPath.section]

      switch sections {
      case .mainData:
        if categoryIndex == 0 {
          let camera = cameraData?.data?.cameras[indexPath.row]
          return configure(CameraCell.self, with: camera, for: indexPath)
        } else {
          let door = doorData?.data[indexPath.row]
          return configure(DoorCell.self, with: door, for: indexPath)
        }
      }
    }

    dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header.reuseId, for: indexPath) as? Header else { return Header() }
        sectionHeader.categories = Array(NSOrderedSet(array: self.categories.compactMap {
          $0.categoryName
        } )) as? [String] ?? []
        sectionHeader.delegate = self
        return sectionHeader
    }

    dataSource?.apply(generateSnapshot(), animatingDifferences: true)
  }

  private func generateSnapshot() -> NSDiffableDataSourceSnapshot<Section, AnyHashable>  {
    var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()

    snapshot.appendSections([Section.mainData])
    if categoryIndex == 0 {
      snapshot.appendItems(cameraData?.data?.cameras ?? [], toSection: .mainData)
    } else {
      snapshot.appendItems(doorData?.data ?? [], toSection: .mainData)
    }

    return snapshot
  }

  // MARK: - Setup Layout

  private func createCompositionalLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
      let section = Section.allCases[sectionIndex]

      switch section {
      case .mainData:
        return self.createMainSection()
      }
    }

    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.interSectionSpacing = 8
    layout.configuration = config

    return layout
  }

  private func createMainSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(0.43))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                 subitems: [item])
    group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)

    let layoutSection = NSCollectionLayoutSection(group: group)
    layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))

    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

    header.pinToVisibleBounds = true
    layoutSection.boundarySupplementaryItems = [header]

    return layoutSection
  }
}

//MARK: - MainViewControllerDelegate

private extension MainViewController {
  enum Section: String, Hashable, CaseIterable {
    case mainData
  }
}

//MARK: - MainViewControllerDelegate

extension MainViewController: MainViewControllerDelegate {
    func didSelectCategory(_ index: Int) {
      categoryIndex = index
      loadSelectedCategory(catery: index)
    }
}
