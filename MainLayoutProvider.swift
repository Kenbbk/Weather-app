//
//  LayoutProvider.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 10/5/23.
//

import UIKit

struct MainLayoutProvider {
    
    let sections: [Section] = [.first, .second, .third]
    
    func getMainLayout() -> UICollectionViewCompositionalLayout {
        
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviro in
            
            let section = sections[sectionIndex]
            switch section {
            case .first:
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(70), heightDimension: .estimated(95)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .continuous
               
                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
                
                
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundReusableView.identifier)
                
                section.decorationItems = [backgroundItem]
                return section
                
            case .second:
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), repeatingSubitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundReusableView.identifier)
                
                section.decorationItems = [backgroundItem]
                
                return section
                
                
                
            case .third:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), repeatingSubitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                
                
                
                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundReusableView.identifier)
                
                backgroundItem.contentInsets = section.contentInsets
                
                section.decorationItems = [backgroundItem]
                
                return section
                
//            case .fourth:
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//                item.contentInsets = .init(top: 3, leading: 7.5, bottom: 3, trailing: 7.5)
//
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(180)), repeatingSubitem: item, count: 2)
//                group.contentInsets = .init(top: 0, leading: 0, bottom: 5, trailing: 0)
//                let section = NSCollectionLayoutSection(group: group)
//
//                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundReusableView.identifier)
//
//                backgroundItem.contentInsets = section.contentInsets
//
//                section.decorationItems = [backgroundItem]
//                return section
            }
            
            
        }
        
        layout.register(BackgroundReusableView.self,
                        forDecorationViewOfKind: BackgroundReusableView.identifier)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        
        layout.configuration = config
        
        return layout
        
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return header
    }
}
