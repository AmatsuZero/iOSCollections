//
// AudioSpectrum02
// A demo project for blog: https://juejin.im/post/5c1bbec66fb9a049cb18b64c
// Created by: potato04 on 2019/1/13
//

import UIKit


protocol TrackCellDelegate: AnyObject {
    func playTapped(_ cell: TrackCell)
    func stopTapped(_ cell: TrackCell)
}

class TrackCell: UITableViewCell {
    
    weak var delegate: TrackCellDelegate?
    let playOrStopButton = UIButton(type: .custom)
    let trackNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(trackNameLabel)
        trackNameLabel.frame = CGRect(x: 10, y: 0, width: 250, height: 16)
        trackNameLabel.font = UIFont.systemFont(ofSize: 13)
        trackNameLabel.textColor = .darkText
        
        playOrStopButton.frame = CGRect(x: contentView.frame.maxX + 10, y: 0, width: 40, height: 20)
        playOrStopButton.setTitleColor(.blue, for: .normal)
        contentView.addSubview(playOrStopButton)
        playOrStopButton.addTarget(self, action: #selector(TrackCell.playOrStopTapped(_:)), for: .touchUpInside)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        trackNameLabel.frame.origin.y = (rect.height - trackNameLabel.frame.height) / 2
        playOrStopButton.frame.origin.y = (rect.height - playOrStopButton.frame.height) / 2;
//        playOrStopButton.frame.size.width = max((rect.width - trackNameLabel.frame.maxX - 10), 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(trackName: String, playing: Bool) {
        trackNameLabel.text = trackName
        if playing {
            playOrStopButton.setTitle("Stop", for: .normal)
        } else {
            playOrStopButton.setTitle("Play", for: .normal)
        }
    }
    
    @objc func playOrStopTapped(_ sender: UIButton) {
        if playOrStopButton.titleLabel?.text == "Stop" {
            playOrStopButton.setTitle("Play", for: .normal)
            self.delegate?.stopTapped(self)
        } else if playOrStopButton.titleLabel?.text == "Play" {
            playOrStopButton.setTitle("Stop", for: .normal)
            self.delegate?.playTapped(self)
        }
    }
}
