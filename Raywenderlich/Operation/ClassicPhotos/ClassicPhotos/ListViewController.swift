//
//  ListViewController.swift
//  ClassicPhotos
//
//  Created by Quoc Nguyen on 2018/06/06.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import UIKit

let dataSourceURL = URL(string:"https://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist")!

class ListViewController: UIViewController {

    @IBAction func ahihidongoc(_ sender: Any) {
        print("AhiiDoNgoc", separator: "", terminator: "")
    }
    @IBOutlet weak var tableView: UITableView!
    var photos = [PhotoRecord]()
    let pendingOperations = PendingOperations()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Classic Photos"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchPhotoDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func fetchPhotoDetails() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let funnyRquest = URLRequest(url: dataSourceURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: funnyRquest) { (data, response, err) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            guard err == nil else {
                print(err!.localizedDescription)
                return
            }
            guard let data = data else {
                return
            }
            guard let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
                return
            }
            guard let result = dict else {
                return
            }
            for (key, val) in result {
                guard let urlStr = val as? String else {
                    continue
                }
                guard let url = URL(string: urlStr) else {
                    continue
                }
                self.photos.append(PhotoRecord(name: key, url: url))
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }

}

extension ListViewController {
    func startOperationsForPhotoRecord(_ photoDetails: PhotoRecord, indexPath: IndexPath){
        switch (photoDetails.state) {
        case .new:
            startDownloadForRecord(photoDetails, indexPath: indexPath)
        case .downloaded:
            startFiltrationForRecord(photoDetails, indexPath: indexPath)
        default:
            break
        }
    }

    func startDownloadForRecord(_ photoDetails: PhotoRecord, indexPath: IndexPath){
        //1
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }
        //2
        let downloader = ImageDownloader(photoRecord: photoDetails)
        //3
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        //4
        pendingOperations.downloadsInProgress[indexPath] = downloader
        //5
        pendingOperations.downloadQueue.addOperation(downloader)
    }

    func startFiltrationForRecord(_ photoDetails: PhotoRecord, indexPath: IndexPath){
        if pendingOperations.filtrationsInProgress[indexPath] != nil {
            return
        }
        let filterer = ImageFiltration(photoRecord: photoDetails)
        filterer.completionBlock = {
            if filterer.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        pendingOperations.filtrationsInProgress[indexPath] = filterer
        pendingOperations.filtrationQueue.addOperation(filterer)
    }

    func suspendAllOperations () {
        pendingOperations.downloadQueue.isSuspended = true
        pendingOperations.filtrationQueue.isSuspended = true
    }

    func resumeAllOperations () {
        pendingOperations.downloadQueue.isSuspended = false
        pendingOperations.filtrationQueue.isSuspended = false
    }

    func loadImagesForOnscreenCells () {
        guard let visiblePaths = tableView.indexPathsForVisibleRows else {
            return
        }

        var allPendingOperations = Set<IndexPath>(pendingOperations.downloadsInProgress.keys)
        allPendingOperations = allPendingOperations.union(pendingOperations.filtrationsInProgress.keys)
        var toBeCancelled = allPendingOperations
        toBeCancelled.subtract(visiblePaths)
            //4
        var toBeStarted = Set(visiblePaths)
        toBeStarted.subtract(allPendingOperations)
            // 5
        for indexPath in toBeCancelled {
            if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                pendingDownload.cancel()
            }
            pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            if let pendingFiltration = pendingOperations.filtrationsInProgress[indexPath] {
                pendingFiltration.cancel()
            }
            pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
        }
        for indexPath in toBeStarted {
            let recordToProcess = self.photos[indexPath.row]
            startOperationsForPhotoRecord(recordToProcess, indexPath: indexPath)
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        if cell.accessoryView == nil {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            cell.accessoryView = indicator
        }
        let indicator = cell.accessoryView as! UIActivityIndicatorView
        let photo = photos[indexPath.row]
        cell.textLabel?.text = photo.name
        cell.imageView?.image = photo.image
        switch (photo.state){
        case .filtered:
            indicator.stopAnimating()
        case .failed:
            indicator.stopAnimating()
            cell.textLabel?.text = "Failed to load"
        case .new, .downloaded:
            indicator.startAnimating()
            if (!tableView.isDragging && !tableView.isDecelerating) {
                self.startOperationsForPhotoRecord(photo,indexPath:indexPath)
            }
        }
        return cell
    }
}

extension ListViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperations()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 3
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
}
