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
    
    var curFromDate : NSDate? = NSDate()
    let daysToAdd : NSTimeInterval = 10
    var _curToDate : NSDate?
    var curToDate : NSDate? {
        get {
            if (_curToDate == nil) {
                _curToDate = NSDate(timeIntervalSinceNow: 60*60*24*daysToAdd)
            }
            return _curToDate
        }
        set(newValue) {
            _curToDate = newValue
        }
    }
    lazy var formatter: NSDateFormatter = {
        var tmpFormatter = NSDateFormatter()
        tmpFormatter.dateFormat = "dd/MM/yyyy"
        return tmpFormatter
    }()
    lazy var fromDatePicker : THDatePickerViewController = {
        let picker = THDatePickerViewController.datePicker()
        picker.delegate = self
        picker.date = self.curFromDate
        picker.selectedBackgroundColor = UIColor.brownColor()
        picker.currentDateColor = UIColor.orangeColor()
        picker.currentDateColorSelected = UIColor.yellowColor()
        return picker
    }()
    lazy var toDatePicker : THDatePickerViewController = {
        let picker = THDatePickerViewController.datePicker()
        picker.delegate = self
        picker.date = self.curToDate
        picker.selectedBackgroundColor = UIColor.brownColor()
        picker.currentDateColor = UIColor.orangeColor()
        picker.currentDateColorSelected = UIColor.yellowColor()
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
        fromDateButton.setTitle((curFromDate != nil ? formatter.stringFromDate(curFromDate!) : "No date selected"), forState: UIControlState.Normal)
        toDateButton.setTitle((curToDate != nil ? formatter.stringFromDate(curToDate!) : "No date selected"), forState: UIControlState.Normal)
    }
    
    @IBAction func touchedButton(sender: AnyObject) {
        if (sender.tag == 10) {
            fromDatePicker.date = self.curFromDate
            fromDatePicker.setDateRangeFrom(self.curFromDate, toDate: self.curToDate)
            
            presentSemiViewController(fromDatePicker, withOptions: [
                convertCfTypeToString(KNSemiModalOptionKeys.shadowOpacity) as String! : 0.3 as Float,
                convertCfTypeToString(KNSemiModalOptionKeys.animationDuration) as String! : 1.0 as Float,
                convertCfTypeToString(KNSemiModalOptionKeys.pushParentBack) as String! : false as Bool
                ])
        } else if (sender.tag == 20) {
            toDatePicker.date = self.curToDate
            toDatePicker.setDateRangeFrom(self.curFromDate, toDate: self.curToDate)
            presentSemiViewController(toDatePicker, withOptions: [
                convertCfTypeToString(KNSemiModalOptionKeys.shadowOpacity) as String! : 0.3 as Float,
                convertCfTypeToString(KNSemiModalOptionKeys.animationDuration) as String! : 1.0 as Float,
                convertCfTypeToString(KNSemiModalOptionKeys.pushParentBack) as String! : false as Bool
                ])
        }
    }

    /* https://vandadnp.wordpress.com/2014/07/07/swift-convert-unmanaged-to-string/ */
    func convertCfTypeToString(cfValue: Unmanaged<NSString>!) -> String?{
        /* Coded by Vandad Nahavandipoor */
        let value = Unmanaged<CFStringRef>.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFStringRef
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else {
            return nil
        }
    }
    
    // MARK: THDatePickerDelegate
    
    func datePickerDonePressed(datePicker: THDatePickerViewController!) {
        if datePicker == fromDatePicker {
            curFromDate = datePicker.date
        } else if datePicker == toDatePicker {
            curToDate = datePicker.date
        }
        refreshTitle()
        dismissSemiModalView()
    }
    
    func datePickerCancelPressed(datePicker: THDatePickerViewController!) {
        dismissSemiModalView()
    }
    
    func datePicker(datePicker: THDatePickerViewController!, selectedDate: NSDate!) {
        print("Date selected: ", formatter.stringFromDate(selectedDate))
    }
}

