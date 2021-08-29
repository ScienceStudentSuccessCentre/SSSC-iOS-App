//
//  MentorsViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-09-04.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import MessageUI
import UIKit

class MentorsViewController: UICollectionViewController {
    private var mentors = [Mentor]()
    private let inset: CGFloat = 16
    private let minimumLineSpacing: CGFloat = 16
    private let minimumInteritemSpacing: CGFloat = 24
    private var selectedMentor: Mentor?
    private var activityIndicatorView: UIActivityIndicatorView!
    private lazy var noMentorsLabel: UILabel = {
        let frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        let label = UILabel(frame: frame)
        label.text = "No mentors, please try again!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private weak var header: MentorHeader?
    
    var registrationType: EmailRegistrationType {
        return .mentoring(mentor: nil)
    }
    
    private lazy var searchController: UISearchController = {
        let resultsViewController = MentorSearchViewController(actionDelegate: self)
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController
        searchController.searchBar.delegate = resultsViewController
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Mentor Search"
        
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
        
        activityIndicatorView = UIActivityIndicatorView(style: .medium)
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
        }.catch { error in
            self.mentors = [Mentor]()
            print("Failed to load mentors:\n\(error)")
            if error.localizedDescription.lowercased().contains("offline") {
                self.presentAlert(kind: .offlineError)
            } else {
                self.presentAlert(kind: .mentorsError)
            }
        }.finally {
            self.collectionView.reloadData()
            if self.mentors.count > 0 {
                self.navigationItem.setRightBarButton(nil, animated: true)
                self.noMentorsLabel.isHidden = true
                self.header?.isHidden = false
            } else {
                self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                      target: self,
                                                                      action: #selector(self.loadMentors)),
                                                      animated: true)
                self.noMentorsLabel.isHidden = false
                self.header?.isHidden = true
            }
            self.activityIndicatorView.isHidden = true
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
        let cell = collectionView.dequeueReusableCell(for: indexPath) as MentorCell
        let mentor = mentors[indexPath.row]
        cell.tag = indexPath.row
        cell.configure(mentor)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(for: indexPath, kind: kind) as MentorHeader
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

// This generates a warning about @objc - can't really do much about it unfortunately!
extension MentorsViewController: BookingDelegate {
    func bookingButtonTapped() {
        if Features.shared.enableEmailMentorRegistration {
            register(fallback: {
                self.openCarletonCentral()
            })
        } else {
            openCarletonCentral()
        }
    }
    
    func openCarletonCentral() {
        guard let url = URL(string: "https://central.carleton.ca/") else { return }
        let webpage = SSSCSafariViewController(url: url)
        present(webpage, animated: true)
    }
}

extension MentorsViewController: EmailRegistrationController, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            let title: String?
            let message: String?
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
            
            switch result {
            case .sent:
                title = "Thanks for contacting us!"
                message = "The SSSC staff should get back to you shortly about your mentoring session."
            case .saved:
                title = "Almost Done!"
                message = "To finish registering, check your Drafts folder and send the email addressed to sssc@carleton.ca."
            case .failed:
                self.presentAlert(kind: .genericError, actions: dismissAction)
                return
            default:
                return
            }
            let dismissedMailAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            dismissedMailAlert.addAction(dismissAction)
            self.present(dismissedMailAlert, animated: true)
        }
    }
}

extension MentorsViewController: MentorSearchActionDelegate {
    func getMentors() -> [Mentor] {
        return mentors
    }
    func didTapMentor(_ mentor: Mentor) {
        selectedMentor = mentor
        performSegue(withIdentifier: "mentorDetail", sender: nil)
    }
}

extension MentorsViewController: UICollectionViewDelegateFlowLayout {
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
