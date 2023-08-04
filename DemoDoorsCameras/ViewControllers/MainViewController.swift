//
//  ViewController.swift
//  DemoDoorsCameras
//
//  Created by Артем Павлов on 03.08.2023.
//

import UIKit
import RealmSwift

protocol MainViewControllerDelegate {
    func didSelectCategory(_ name: String)
}

class MainViewController: UIViewController {

  // MARK: - Private Properties

  private var cameraData: Camera?
  private var categories: [Category] = []
  private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
  private var collectionView: UICollectionView!

  //MARK: - Life Cycles Methods

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavBar()
    getCategoryData()
    setupCollectionView()
    loadData()
  }

  //MARK: - Private Methods

  private func setupCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(collectionView)
    collectionView.backgroundColor = .systemGray5

    collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.reuseId)
    collectionView.register(CameraCell.self, forCellWithReuseIdentifier: CameraCell.reuseId)
  }

  private func setupNavBar() {
    title = "Мой дом"
    navigationItem.largeTitleDisplayMode = .never
  }

  private func getCategoryData() {
    let _ = DataManager.shared.getFakeCategoryData().compactMap { categories.append(Category(categoryName: $0)) }
  }

  private func loadData() {
    NetworkManager.shared.fetchData(from: "http://cars.cprogroup.ru/api/rubetek/cameras/", completion: { result in
      switch result {
      case .success(let camera):
        self.cameraData = camera
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
        let camera = cameraData?.data?.cameras[indexPath.row]
        return configure(CameraCell.self, with: camera, for: indexPath)
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
    snapshot.appendItems(cameraData?.data?.cameras ?? [], toSection: .mainData)

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
    func didSelectCategory(_ name: String) {

//        let indexOfFirstElementOfCategory = products.firstIndex(where: { $0.category == name } )
//        guard let index = indexOfFirstElementOfCategory else {return}
//
//        let indexPath = IndexPath(item: index, section: 1)
//        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
    }
}
