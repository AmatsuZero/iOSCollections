import UIKit

public class ViewController: UIViewController {
    
    let spectrumView = SpectrumView(frame: .zero)
    let trackTableView = UITableView(frame: .zero, style: .plain)
    let player = AudioSpectrumPlayer()
    
    private lazy var trackPaths: [String] = {
        var paths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "Audio")
        paths.sort()
        return paths.map { $0.components(separatedBy: "/").last! }
    }()
    
    private var currentPlayingRow: Int?
    
    override public func loadView() {
        super.loadView()
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 812)
        spectrumView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        view.addSubview(spectrumView)
        
        trackTableView.frame = CGRect(x: 0, y: spectrumView.frame.height, width: view.frame.width, height: view.frame.height - spectrumView.frame.height)
        trackTableView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")
        trackTableView.tableFooterView = UIView()
        view.addSubview(trackTableView)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        trackTableView.dataSource = self
        player.delegate = self
    }
    
    override public func viewDidLayoutSubviews() {
        let barSpace = spectrumView.frame.width / CGFloat(player.analyzer.frequencyBands * 3 - 1)
        spectrumView.barWidth = barSpace * 2
        spectrumView.space = barSpace
    }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackPaths.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! TrackCell
        cell.configure(trackName: "\(trackPaths[indexPath.row])", playing: currentPlayingRow == indexPath.row)
        cell.delegate = self
        return cell
    }
}

// MARK: TrackCellDelegate
extension ViewController: TrackCellDelegate {
    func playTapped(_ cell: TrackCell) {
        if let indexPath = trackTableView.indexPath(for: cell) {
            let previousPlayingRow = currentPlayingRow
            self.currentPlayingRow = indexPath.row
            if indexPath.row != previousPlayingRow && previousPlayingRow != nil  {
                trackTableView.reloadRows(at: [IndexPath(row: previousPlayingRow!, section: 0)], with: .none)
            }
            player.play(withFileName: trackPaths[indexPath.row])
        }
    }
    func stopTapped(_ cell: TrackCell) {
        self.currentPlayingRow = nil
        player.stop()
    }
}

// MARK: SpectrumPlayerDelegate
extension ViewController: AudioSpectrumPlayerDelegate {
    func player(_ player: AudioSpectrumPlayer, didGenerateSpectrum spectra: [[Float]]) {
        DispatchQueue.main.async {
            self.spectrumView.spectra = spectra
        }
    }
}
