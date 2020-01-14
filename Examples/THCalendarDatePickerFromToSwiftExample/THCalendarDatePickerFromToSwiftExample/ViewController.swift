//
//  ViewController.swift
//  THCalendarDatePickerSwiftExample
//
//  Created by Hannes Tribus on 04/09/15.
//  Copyright (c) 2015 3Bus. All rights reserved.
//

import UIKit
import THCalendarDatePicker


class ViewController: UIViewController, THDatePickerDelegate {

    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var toDateButton: UIButton!
    
    var curFromDate : Date = Date()
    let daysToAdd : TimeInterval = 10
    lazy var curToDate : Date = {
        return Date(timeIntervalSinceNow: 60*60*24*daysToAdd)
    }()
    lazy var formatter: DateFormatter = {
        var tmpFormatter = DateFormatter()
        tmpFormatter.dateFormat = "dd/MM/yyyy"
        return tmpFormatter
    }()
    lazy var fromDatePicker : THDatePickerViewController = {
        let picker = THDatePickerViewController.datePicker()
        picker.delegate = self
        picker.date = self.curFromDate
        picker.selectedBackgroundColor = .brown
        picker.currentDateColor = .orange
        picker.currentDateColorSelected = .yellow
        return picker
    }()
    lazy var toDatePicker : THDatePickerViewController = {
        let picker = THDatePickerViewController.datePicker()
        picker.delegate = self
        picker.date = self.curToDate
        picker.selectedBackgroundColor = .yellow
        picker.currentDateColor = .green
        picker.currentDateColorSelected = .brown
        return picker
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshTitle() {
        fromDateButton.setTitle(formatter.string(from: curFromDate), for: .normal)
        toDateButton.setTitle(formatter.string(from: curToDate), for: .normal)
    }
    
    @IBAction func touchedButton(sender: AnyObject) {
        if (sender.tag == 10) {
            fromDatePicker.date = self.curFromDate
            fromDatePicker.setDateRangeFrom(self.curFromDate, to: self.curToDate)
            
            presentSemiViewController(fromDatePicker, withOptions: [
                convertCfTypeToString(cfValue: KNSemiModalOptionKeys.shadowOpacity) ?? "Error_0" : 0.3 as Float,
                convertCfTypeToString(cfValue: KNSemiModalOptionKeys.animationDuration) ?? "Error_1" : 1.0 as Float,
                convertCfTypeToString(cfValue: KNSemiModalOptionKeys.pushParentBack) ?? "Error_2" : false as Bool
                ])
        } else if (sender.tag == 20) {
            toDatePicker.date = self.curToDate
            toDatePicker.setDateRangeFrom(self.curFromDate, to: self.curToDate)
            presentSemiViewController(toDatePicker, withOptions: [
                convertCfTypeToString(cfValue: KNSemiModalOptionKeys.shadowOpacity) ?? "Error_0" : 0.3 as Float,
                convertCfTypeToString(cfValue: KNSemiModalOptionKeys.animationDuration) ?? "Error_1" : 1.0 as Float,
                convertCfTypeToString(cfValue: KNSemiModalOptionKeys.pushParentBack) ?? "Error_2" : false as Bool
                ])
        }
    }

    /* https://vandadnp.wordpress.com/2014/07/07/swift-convert-unmanaged-to-string/ */
    func convertCfTypeToString(cfValue: Unmanaged<NSString>!) -> String?{
        /* Coded by Vandad Nahavandipoor */
        let value = Unmanaged<CFString>.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFString
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else {
            return nil
        }
    }
    
    // MARK: THDatePickerDelegate
    
    func datePickerDonePressed(_ datePicker: THDatePickerViewController) {
        if datePicker == fromDatePicker {
            curFromDate = datePicker.date ?? Date()
        } else if datePicker == toDatePicker {
            curToDate = datePicker.date ?? Date()
        }
        refreshTitle()
        dismissSemiModalView()
    }
    
    func datePickerCancelPressed(_ datePicker: THDatePickerViewController) {
        dismissSemiModalView()
    }
    
    func datePicker(_ datePicker: THDatePickerViewController, selectedDate: Date) {
        print("Date selected: ", formatter.string(from: selectedDate))
    }
}

