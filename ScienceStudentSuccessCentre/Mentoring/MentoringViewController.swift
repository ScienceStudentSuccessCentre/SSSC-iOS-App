//
//  MentoringViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-09-04.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

class MentoringViewController: UICollectionViewController {
    private var mentors = [Mentor]()
    private let inset: CGFloat = 16
    private let minimumLineSpacing: CGFloat = 16
    private let minimumInteritemSpacing: CGFloat = 24
    private var selectedMentor: Mentor?
    private var activityIndicatorView: UIActivityIndicatorView!
    private lazy var noMentorsLabel: UILabel = {
        let frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        let label = UILabel(frame: frame)
        label.text = "Couldn't load mentors, try again!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private weak var header: MentorHeader?
    
    private lazy var searchController: UISearchController = {
        let resultsViewController = MentorSearchViewController(actionDelegate: self)
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController
        searchController.searchBar.delegate = resultsViewController
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Mentor Search"
        searchController.dimsBackgroundDuringPresentation = true
        
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
            searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "searchBarBackground")
            searchController.searchBar.searchTextField.tintColor = .label
        }
        return searchController
    }()
    
    override func viewDidLoad() {
        extendedLayoutIncludesOpaqueBars = true
        definesPresentationContext = true
        navigationItem.searchController = searchController
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.contentInsetAdjustmentBehavior = .always
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.center = view.center
        if #available(iOS 13.0, *) {
            activityIndicatorView.color = .label
        }
        activityIndicatorView.startAnimating()
        collectionView.backgroundView = activityIndicatorView
        collectionView.addSubview(noMentorsLabel)
        noMentorsLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        noMentorsLabel.centerYAnchor.constraint(equalTo: collectionView.topAnchor, constant: collectionView.frame.height / 5).isActive = true
        
        loadMentors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareNavigationBarAppearance()
    }
    
    @objc private func loadMentors() {
        noMentorsLabel.isHidden = true
        activityIndicatorView.isHidden = false
        MentorLoader.loadMentors().done { mentors in
            self.mentors = mentors
            self.navigationItem.setRightBarButton(nil, animated: true)
        }.catch { error in
            self.mentors = [Mentor]()
            self.noMentorsLabel.isHidden = false
            print("Failed to load mentors:\n\(error)")
            let alert: UIAlertController
            if error.localizedDescription.lowercased().contains("offline") {
                alert = UIAlertController(title: "No Connection",
                                          message: "It looks like you might be offline! Please try again once you have an internet connection.",
                                          preferredStyle: .alert)
            } else {
                alert = UIAlertController(title: "Something went wrong!",
                                          // swiftlint:disable:next line_length
                                          message: "Something went wrong when loading the SSSC's mentors! Please try again later. If the issue persists, contact the SSSC so we can fix the problem as soon as possible.",
                                          preferredStyle: .alert)
            }
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                  target: self,
                                                                  action: #selector(self.loadMentors)),
                                                  animated: true)
        }.finally {
            self.collectionView.reloadData()
            self.activityIndicatorView.isHidden = true
            self.header?.bookingButton.isHidden = self.mentors.count == 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let mentorIndex = collectionView.indexPathsForSelectedItems?.first else { return }
        selectedMentor = mentors[mentorIndex.row]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mentors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MentorCell",
                                                            for: indexPath) as? MentorCell
            else { fatalError("Failed to dequeue MentorCell") }
        let mentor = mentors[indexPath.row]
        cell.tag = indexPath.row
        cell.configure(mentor)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let kind = UICollectionView.elementKindSectionHeader
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: "MentorHeader",
                                                                           for: indexPath) as? MentorHeader
            else { fatalError(" Failed to dequeue MentorHeader") }
        header.bookingDelegate = self
        self.header = header
        return header
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mentorDetail" {
            guard let destination = segue.destination as? MentorDetailViewController else { return }
            if let mentorIndex = collectionView.indexPathsForSelectedItems?.first {
                destination.mentor = mentors[mentorIndex.row]
                collectionView.deselectItem(at: mentorIndex, animated: true)
            } else {
                destination.mentor = selectedMentor
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension MentoringViewController: BookingDelegate {
    func bookingButtonTapped() {
        guard let url = URL(string: "https://central.carleton.ca/") else { return }
        let webpage = SSSCSafariViewController(url: url)
        present(webpage, animated: true)
    }
}

extension MentoringViewController: MentorSearchActionDelegate {
    func getMentors() -> [Mentor] {
        return mentors
    }
    func didTapMentor(_ mentor: Mentor) {
        selectedMentor = mentor
        performSegue(withIdentifier: "mentorDetail", sender: nil)
    }
}

extension MentoringViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsPerRow: CGFloat
        let sizeClass = traitCollection.horizontalSizeClass
        let orientation = UIDevice.current.orientation
        switch sizeClass {
        case .compact:
            cellsPerRow = 2
        case .regular:
            if orientation == .portrait || orientation == .portraitUpsideDown {
                cellsPerRow = 3
            } else {
                cellsPerRow = 4
            }
        default:
            cellsPerRow = 2
        }
        
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * (cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / cellsPerRow).rounded(.down)
        let itemHeight = itemWidth + 75
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let header = header {
            return CGSize(width: collectionView.frame.width, height: header.height)
        }
        return CGSize(width: 1, height: 1)
    }
}
