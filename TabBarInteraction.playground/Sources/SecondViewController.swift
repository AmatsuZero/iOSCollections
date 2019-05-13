//
//  SecondViewController.swift
//  TabBarInteraction
//
//  Created by potato04 on 2019/3/27.
//  Copyright © 2019 potato04. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, TabbarInteractable {

    private var clockView = ClockIconView(frame: CGRect.zero)
    let datePicker = UIDatePicker(frame: .zero)
    let calendar = Calendar.current
    lazy var defaultDate: Date = {
        var component = DateComponents()
        component.hour = 9
        component.minute = 0
        return calendar.date(from: component)!
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(datePicker)
    }
    
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tabBarItem = UITabBarItem(title: "Clock", image: UIImage(named: "clock"), tag: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        clockView.lineWidth = 2
        clockView.tintColor = UIColor.white
        clockView.layer.cornerRadius = 12.5
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.date = defaultDate
        
        replaceSwappableImageViews(with: clockView, and: CGSize(width: 25, height: 25))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        datePicker.frame = CGRect(x: 0, y: view.frame.height - 216, width: view.frame.width, height: 216)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        clockView.backgroundColor = view.tintColor
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clockView.backgroundColor = UIColor.gray
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let hour = calendar.component(.hour, from: selectedDate)
        let minute = calendar.component(.minute, from: selectedDate)
        clockView.hour = hour
        clockView.minute = minute
    }
}
