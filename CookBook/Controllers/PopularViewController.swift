//
//  PopularViewController.swift
//  CookBook
//
//  Created by Alexander Altman on 30.11.2022.
//

import UIKit

class PopularViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .none
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    let navApp = UINavigationBarAppearance()
    
    private let sections = CompMockData.shared.pageData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    private func setupViews() {
        title = "Popular Recipes"
        view.backgroundColor = Theme.appColor
        view.addSubview(collectionView)
        collectionView.register(RandomCollectionViewCell.self,
                                forCellWithReuseIdentifier: "RandomCollectionViewCell")
        collectionView.register(VeganCollectionViewCell.self,
                                forCellWithReuseIdentifier: "VeganCollectionViewCell")
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "HeaderSupplementaryView")
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

//MARK: - Create Layout

extension PopularViewController {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            switch section {
            case .random(_):
                return self.createRandomSection()
            case .vegan(_):
                return self.createVeganSection()
            }
        }
    }
    
    private func createLayoutSection(group: NSCollectionLayoutGroup,
                                     behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
                                     intergrouupSpacing: CGFloat,
                                     supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem],
                                     contentInsets: Bool) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.interGroupSpacing = intergrouupSpacing
        section.boundarySupplementaryItems = supplementaryItems
        section.supplementariesFollowContentInsets = contentInsets
        return section
    }
    
    private func createRandomSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalWidth(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9),
                                                                         heightDimension: .fractionalWidth(1)),
                                                       subitems: [item])
        
        let section = createLayoutSection(
            group: group,
            behavior: .groupPaging,
            intergrouupSpacing: 15,
            supplementaryItems: [supplementaryHeaderItem()],
            contentInsets: false
        )
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 0)
        return section
    }
    
    private func createVeganSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalWidth(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                                         heightDimension: .fractionalWidth(0.55)),
                                                       subitems: [item])
        
        let section = createLayoutSection(
            group: group,
            behavior: .groupPaging,
            intergrouupSpacing: 5,
            supplementaryItems: [supplementaryHeaderItem()],
            contentInsets: false
        )
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 0)
        return section
    }
    
    
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                heightDimension: .estimated(30)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top)
    }
}

//MARK: - UICollectionViewDelegate
extension PopularViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDataSource
extension PopularViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            
        case .random(let random):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomCollectionViewCell", for: indexPath) as? RandomCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(mealLabel: random[indexPath.row].title, imageName: random[indexPath.row].image)
            return cell
            
            
        case .vegan(let vegan):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VeganCollectionViewCell", for: indexPath) as? VeganCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(mealLabel: vegan[indexPath.row].title, imageName: vegan[indexPath.row].image)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "HeaderSupplementaryView",
                                                                         for: indexPath) as! HeaderSupplementaryView
            header.configureHeader(categoryName: sections[indexPath.section].title)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - Set Constraints
extension PopularViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
//            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}
