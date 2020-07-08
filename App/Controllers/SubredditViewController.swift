//
//  SubredditViewController.swift
//  rcket
//
//  Created by Jesus Ortega on 7/7/20.
//  Copyright © 2020 Jesus Ortega. All rights reserved.
//
import AppKit
import Kingfisher

class SubredditViewController: NSViewController {
    // MARK: Outlets

    @IBOutlet var topSpacingConstraint: NSLayoutConstraint!

    @IBOutlet var tableView: NSTableView!

    // MARK: Properties

    private var didAppear = false

    // MARK: View Lifecycle

    override func viewDidAppear() {
        super.viewDidAppear()

        if !didAppear {
            didAppear.toggle()

            DispatchQueue.main.async {
                self.notifyCategoryChange()
            }
        }
    }

    // MARK: Functions

    func notifyCategoryChange() {
//        guard 0..<StoryType.allCases.count ~= tableView.selectedRow else { return }
//
//        NotificationCenter.default.post(
//            name: .newCategorySelectedNotification,
//            object: self,
//            userInfo: ["selectedCategory": StoryType.allCases[tableView.selectedRow]]
//        )
    }
}

// MARK: - Notifications

extension Notification.Name {
    static let newCategorySelectedNotification = Notification.Name(
        "NewCategorySelectedNotification")
}

// MARK: - NSUserInterfaceItemIdentifier

extension NSUserInterfaceItemIdentifier {
    static let categoryCell = NSUserInterfaceItemIdentifier("CategoryCell")
    static let categoryRow = NSUserInterfaceItemIdentifier("CategoryRow")
}

// MARK: - NSTableView Data Source

extension SubredditViewController: NSTableViewDataSource {
    func numberOfRows(in _: NSTableView) -> Int {
        return Subreddits.subscriptions().count
//        return StoryType.allCases.count
    }

    func tableViewSelectionDidChange(_: Notification) {
        notifyCategoryChange()
    }
}

// MARK: - NSTableView Delegate

extension SubredditViewController: NSTableViewDelegate {
    func tableView(_: NSTableView, heightOfRow _: Int) -> CGFloat {
        return 30.0
    }

    func tableView(_ tableView: NSTableView, rowViewForRow _: Int) -> NSTableRowView? {
        return
            tableView
            .makeView(withIdentifier: .categoryRow, owner: self) as? NoEmphasisTableRowView
    }

    func tableView(_ tableView: NSTableView, viewFor _: NSTableColumn?, row: Int) -> NSView? {
        let cellView =
            tableView
            .makeView(withIdentifier: .categoryCell, owner: self) as? NSTableCellView

        let subreddit = Subreddits.subscriptions()[row]
        cellView?.textField?.stringValue = subreddit
        
        let url = URL(string: "https://styles.redditmedia.com/t5_2qh1f/styles/communityIcon_omsxpmvxkyx11.jpg")
    
        let processor = DownsamplingImageProcessor(size: cellView?.imageView?.bounds.size ?? CGSize(width: 24, height: 24))
            |> RoundCornerImageProcessor(cornerRadius: 20)
        
        cellView?.imageView?.kf.indicatorType = .activity
        cellView?.imageView?.kf.setImage(with: url, placeholder: nil,
                                         options: [.processor(processor)],
                                         progressBlock: { receivedSize, totalSize in
                                            print("\(row + 1): \(receivedSize)/\(totalSize)")
        },
                                         completionHandler: { result in
                                            print("\(row + 1): Finished")
        })
        
        return cellView
    }
}

