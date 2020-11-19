//
//  FilesViewController.swift
//  Sieverb
//
//  Created by Michael Ward on 10/25/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

class FilesViewController: UITableViewController {
    
    var progressGroup = DispatchGroup()
    
    private var displayLink: CADisplayLink?
    private var startTime = 0.0
    private let updateTime = 5.0
    
    let textFinder = TextFinder()
    var counters: [WordCounter] = []
    var totalCount: Int {
        let counts = counters.map { (counter) -> Int in
            let counter = counter.currentState.totalCount
            return counter
        }
        let total = counts.reduce(0,+)
        return total
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFileList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startUpdating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopUpdating()
    }
    
    func updateFileList() {
        
        counters.removeAll()
        
        do {
            try textFinder.withTexts { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                
                case .failure(let error):
                    print("[ERR] (\(#file):\(#line)) - \(error)")
                    
                case .success(let texts):
                    for text in texts {
                        let counter = WordCounter(text: text)
                        self.counters.append(counter)
                        
                        self.progressGroup.enter()
                        counter.start(completion: {
                            self.progressGroup.leave()
                        })
                    }
                    
                    self.tableView.reloadData()
                    
                    self.progressGroup.notify(queue: DispatchQueue.main) {
                        self.navigationItem.title = "\(self.totalCount) Words"
                        self.presentCompletionAlert()
                        self.stopUpdating()
                    }
                }
            }
        } catch {
            print("[ERR] (\(#file):\(#line)) - \(error)")
        }
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCellID", for: indexPath)
        let counter = counters[indexPath.row]
        let count = counter.currentState.totalCount
        cell.textLabel?.text = "\(count)"
        cell.detailTextLabel?.text = counter.text.name
        return cell
    }
    
    // MARK: - All Done!
    
    func presentCompletionAlert() {
        let alert = UIAlertController(title: "Analysis Complete",
                                      message: "\(totalCount) words found across \(counters.count) files",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Thanks!", style: .cancel) {[weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func update() {
        navigationItem.title = "\(totalCount) Words"
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else { return }
        for indexPath in visibleIndexPaths {
            guard let cell = tableView.cellForRow(at: indexPath) else { continue }
            let counter = counters[indexPath.row]
            let count = counter.currentState.totalCount
            cell.textLabel?.text = "\(count)"
        }
    }
    
    func startUpdating() {
        stopUpdating() // stop a previous running display link
        startTime = CACurrentMediaTime() // reset start time
        
        // create displayLink & add it to the run-loop
        let displayLink = CADisplayLink (
            target: self, selector: #selector(displayLinkDidFire)
        )
        
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }
    
    @objc func displayLinkDidFire(_ displayLink: CADisplayLink) {
        var elapsedTime = CACurrentMediaTime() - startTime
        
        if elapsedTime > updateTime {
            stopUpdating()
            elapsedTime = updateTime
        }
        update()
    }
    
    func stopUpdating() {
        displayLink?.invalidate()
        displayLink = nil
        update()
    }
    
    
}
