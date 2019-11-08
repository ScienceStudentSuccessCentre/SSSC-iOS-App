//
//  MentoringViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-09-04.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

class MentoringViewController: UIViewController {
    @IBOutlet weak var mentorCollection: UICollectionView?
    private var mentors = [Mentor]()
    private let inset: CGFloat = 16
    private let minimumLineSpacing: CGFloat = 16
    private let minimumInteritemSpacing: CGFloat = 24
    private weak var header: MentorHeader?
    
    override func viewDidLoad() {
        extendedLayoutIncludesOpaqueBars = true
        mentorCollection?.delegate = self
        mentorCollection?.dataSource = self
        mentorCollection?.collectionViewLayout = UICollectionViewFlowLayout()
        mentorCollection?.contentInsetAdjustmentBehavior = .always
        loadMentors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareNavigationBarAppearance()
    }
    
    private func loadMentors() {
        MentorLoader.loadMentors().done { mentors in
            self.mentors = mentors
        }.catch { error in
            self.mentors = [Mentor]()
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
        }.finally {
            self.mentorCollection?.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mentorDetail" {
            guard let destination = segue.destination as? MentorDetailViewController,
                let mentorIndex = mentorCollection?.indexPathsForSelectedItems?.first,
                let cell = mentorCollection?.cellForItem(at: mentorIndex) as? MentorCell else { return }
            destination.mentor = mentors[mentorIndex.row]
            if cell.loadedImage {
                destination.loadedImage = cell.imageView.image
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mentorCollection?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        mentorCollection?.collectionViewLayout.invalidateLayout()
    }
}

extension MentoringViewController: BookingDelegate {
    func bookingButtonTapped() {
        guard let url = URL(string: "https://central.carleton.ca/") else { return }
        let webpage = SSSCSafariViewController(url: url)
        present(webpage, animated: true)
    }
}

extension MentoringViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mentorDetail", sender: nil)
    }
}

extension MentoringViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mentors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MentorCell",
                                                            for: indexPath) as? MentorCell
            else { fatalError("Failed to dequeue MentorCell") }
        let mentor = mentors[indexPath.row]
        cell.configure(mentor)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
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
