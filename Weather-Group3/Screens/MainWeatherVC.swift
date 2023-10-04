//
//  MainWeatherVC.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 2023/09/27.
//

import UIKit

enum Section {
    case first
    case second
    case third
    case fourth
}


class MainWeatherVC: UIViewController {
    
    
    //MARK: - Properties
    
    var lastPositionY: CGFloat = 0
    
    var currentOffsetY: CGFloat = 0
    
    let sectionPadding: CGFloat = 15
    
    let sectionTopPadding: CGFloat = 5
    
    var heightConstraint: NSLayoutConstraint! {
        didSet {
            print("changed")
        }
    }
    
    //    var heightFloat: CGFloat {
    //        print(heightConstraint.constant)
    //        return heightConstraint.constant
    //
    //    }
    var sections: [Section] = [.first, .second, .third, .fourth]
    
    let mainHeaderView: MainHeaderView = .init(frame: .zero)
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        view.contentInset = .init(top: 260, left: 0, bottom: 0, right: 0)
        view.register(CellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellHeaderView.identifier)
        
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .white
        
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureDataSource()
        applySnapshot()
        
        collectionView.delegate = self
        // Test(sr) - MapCell 등록
        collectionView.register(MapCell.self, forCellWithReuseIdentifier: "mapCell")
        
    }
    
    
    
    
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    private func configureDataSource() {
        // Test(sr) - MapCell 섹션2에 표시
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, _ in
            if indexPath.section == 2 {
                if let mapCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapCell", for: indexPath) as? MapCell {
                    return mapCell
                }
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = .yellow
                return cell
            }
            return UICollectionViewCell()
        })
//        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//            cell.backgroundColor = .yellow
//            return cell
//        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else {
                    fatalError("Could not dequeue sectionHeader: \(CellHeaderView.identifier)")
                }
                return sectionHeader
            
            
           
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections(sections)
        snapshot.appendItems([1,2,3,4,5,6,7], toSection: .first)
        snapshot.appendItems([8,9,10,11,12,13,14,15], toSection: .second)
        snapshot.appendItems([16], toSection: .third)
        snapshot.appendItems([17,18,19,20,21,22,23,24], toSection: .fourth)
        dataSource.apply(snapshot)
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem    {
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.pinToVisibleBounds = true
        return header
    }
    
    //MARK: - UI
    
    private func configureUI() {
        configureCollectionView()
        configureMainHeaderView()
        
    }
    
    func configureMainHeaderView() {
        view.addSubview(mainHeaderView)
        
        mainHeaderView.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = mainHeaderView.heightAnchor.constraint(equalToConstant: 260)
        NSLayoutConstraint.activate([
            mainHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightConstraint
        ])
        
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [ weak self ] sectionIndex, layoutEnviro in
            guard let self else { fatalError()}
            
            let section = self.sections[sectionIndex]
            switch section {
            case .first:
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                //                item.contentInsets = .init(top: 1, leading: 5, bottom: 1, trailing: 5)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(70), heightDimension: .absolute(70)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                
                return section
                
            case .second:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), repeatingSubitem: item, count: 1)
                group.contentInsets = .init(top: 2.5, leading: 0, bottom: 2.5, trailing: 0)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: sectionPadding, bottom: sectionTopPadding, trailing: sectionPadding)
                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                
                return section
                
                
                
            case .third:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                //                item.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), repeatingSubitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                //                section.decorationItems = [UIView()]
                section.contentInsets = .init(top: 0, leading: sectionPadding, bottom: sectionTopPadding, trailing: sectionPadding)
                
                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundReusableView.identifier)
                
                backgroundItem.contentInsets = section.contentInsets
                
                section.decorationItems = [backgroundItem]
                
                return section
                
            case .fourth:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = .init(top: 3, leading: 7.5, bottom: 3, trailing: 7.5)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(180)), repeatingSubitem: item, count: 2)
                group.contentInsets = .init(top: 0, leading: 0, bottom: 5, trailing: 0)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 7.5, bottom: sectionTopPadding, trailing: 7.5)
                //                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                //                section.orthogonalScrollingBehavior = .groupPaging
                return section
            }
            
            
        }
        layout.register(BackgroundReusableView.self,
                        forDecorationViewOfKind: BackgroundReusableView.identifier)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        // config.interSectionSpacing = 20
        
        layout.configuration = config
        
        return layout
        
        
    }
    
}

extension MainWeatherVC: UIScrollViewDelegate {
    
//    func updateOffset(offsetY: CGFloat) {
//
//
//        guard offsetY < -75 else { return }
//
//        let diff = lastPositionY - offsetY
//
//        self.currentOffsetY = currentOffsetY + diff
//        print(lastPositionY, offsetY, diff)
//
//        heightConstraint.constant = currentOffsetY
//
//        lastPositionY = offsetY
//
//    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.contentOffset.y <= 0 else { return }
      
        if scrollView.contentOffset.y > -260 {
            heightConstraint.constant = max(abs(scrollView.contentOffset.y), 105)
            
            mainHeaderView.topConstraint.constant = max((6 / 31) * abs(scrollView.contentOffset.y) - (630 / 31), -5)
            
            print(mainHeaderView.topConstraint.constant)

        } else {
            heightConstraint.constant = 260
            mainHeaderView.topConstraint.constant = 30
        }
        
        
    }
    
  
}

extension MainWeatherVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Test: WeatherViewController 실행(임의로 isSelected 사용)
//           if indexPath.section == 0 {
//               let weatherViewController = WeatherViewController()
//
//               present(weatherViewController, animated: true, completion: nil)
//           }
        
        // Test(sr): MapViewController 실행
        if indexPath.section == 2 {
            let mapViewController = MapViewController()
            present(mapViewController, animated: true)
        }
    }
}
