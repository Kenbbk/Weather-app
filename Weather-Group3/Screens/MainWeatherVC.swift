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
    
    //    }
    ////
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
    
    var header: NSCollectionLayoutBoundarySupplementaryItem!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        header = supplementaryHeaderItem()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background2")!)
        configureUI()
        configureDataSource()
        applySnapshot()
        
        collectionView.delegate = self
        print("DD")
        
    }
    
    
    
    
    
    //MARK: - Actions
    
    @objc func collectionTapped() {
        print("CollectionTapped")
    }
    
    //MARK: - Helpers
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath)
                return cell
            } else if indexPath.section == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCell.identifier, for: indexPath) as! SecondCell
                let tuple = TempRangeService().getTempRange(min: 10, max: 30, currentMin: 10, currentMax: 30)
                
                cell.colorViews(min: tuple.0, max: tuple.1)

                cell.colorBar.colors = ColorService().getColors(min: -7, max: 21)
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = .yellow.withAlphaComponent(0.1)
                return cell
            }
            
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else {
                fatalError("Could not dequeue sectionHeader: \(CellHeaderView.identifier)")
            }
            sectionHeader.delegate = self
            sectionHeader.sectionIndex = indexPath.section
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
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        //        header.pinToVisibleBounds = true
        
        return header
    }
    
    // uuid hash uidd red  -> 데이터소스가 변하면 cell이 tableview reload, uuid, color hash
    // model: name: Woojun, age: 20
    //MARK: - UI
    
    private func configureUI() {
        configureMainHeaderView()
        configureCollectionView()
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
            collectionView.topAnchor.constraint(equalTo: mainHeaderView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -15),
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
                //                                item.contentInsets = .init(top: 1, leading: 5, bottom: 10, trailing: 5)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(70), heightDimension: .absolute(50)), subitems: [item])
                
                
                let section = NSCollectionLayoutSection(group: group)
                //                section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
                section.orthogonalScrollingBehavior = .continuous
                //                section.interGroupSpacing = 10
                //                let header = supplementaryHeaderItem()
                
                section.boundarySupplementaryItems = [header]
                section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
                
                
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundReusableView.identifier)
                
                
                
                section.decorationItems = [backgroundItem]
                return section
                
            case .second:
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                //                item.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), repeatingSubitem: item, count: 1)
                //                group.contentInsets = .init(top: 0, leading: 0, bottom: 5, trailing: 0)
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundReusableView.identifier)
                
                
                
                section.decorationItems = [backgroundItem]
                
                return section
                
                
                
            case .third:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                //                item.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), repeatingSubitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                
                
                
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
                
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundReusableView.identifier)
                
                backgroundItem.contentInsets = section.contentInsets
                
                section.decorationItems = [backgroundItem]
                return section
            }
            
            
        }
        
        layout.register(BackgroundReusableView.self,
                        forDecorationViewOfKind: BackgroundReusableView.identifier)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        
        layout.configuration = config
        
        return layout
        
        
    }
    
}

extension MainWeatherVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var a = heightConstraint.constant - scrollView.contentOffset.y
        a = max(115, a)
        a = min(a, 260)
        // 하이트 컨스턴트를 만들고 그값을 업데이트해준뒤
        //        heightFloat = a
        heightConstraint.constant = a // <- 여기에다가 넣어준다
        // 넣어주고 나서 넣어준값이 변경될때마다 City label Constraint를 업데이트 시켜준다
        mainHeaderView.topConstraintConstant = (7 / 29) * heightConstraint.constant - 30.3448
        if heightConstraint.constant > 115 {
            if scrollView.contentOffset.y <= 0 {
                
            } else {
                scrollView.contentOffset.y = 0
            }
            
        }
        
    }
}



extension MainWeatherVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.section)
        header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        //            header.pinToVisibleBounds = true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

extension MainWeatherVC: CellHeaderViewDelegate {
    func cellHeaderViewTapped(sectionIndex: Int) {
        print(sectionIndex)
    }
    
    
}


