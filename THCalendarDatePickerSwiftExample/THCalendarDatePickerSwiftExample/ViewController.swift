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

    @IBOutlet weak var dateButton: UIButton!
    
    var curDate : NSDate? = NSDate()
    lazy var formatter: NSDateFormatter = {
        var tmpFormatter = NSDateFormatter()
        tmpFormatter.dateFormat = "dd/MM/yyyy --- HH:mm"
        return tmpFormatter
    }()
    lazy var datePicker : THDatePickerViewController = {
        let picker = THDatePickerViewController.datePicker()
        picker.delegate = self
        picker.date = self.curDate
        picker.setAllowClearDate(false)
        picker.setClearAsToday(false)
        picker.setAutoCloseOnSelectDate(true)
        picker.setAllowSelectionOfSelectedDate(true)
        picker.setDisableYearSwitch(true)
        //picker.setDisableFutureSelection(false)
        picker.setDaysInHistorySelection(45)
        picker.setDaysInFutureSelection(0)
        picker.setDateTimeZoneWithName("UTC")
        picker.autoCloseCancelDelay = 5.0
        picker.rounded = true
        picker.dateTitle = "My DatePicker"
        picker.selectedBackgroundColor = UIColor(red: 125.0/255.0, green: 208.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        picker.currentDateColor = UIColor(red: 242.0/255.0, green: 121.0/255.0, blue: 53.0/255.0, alpha: 1.0)
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
        dateButton.setTitle((curDate != nil ? formatter.stringFromDate(curDate!) : "No date selected"), forState: UIControlState.Normal)
    }
    
    @IBAction func touchedButton(sender: AnyObject) {
        datePicker.date = self.curDate
        datePicker.setDateHasItemsCallback { (date: NSDate!) -> Bool in
            let tmp = (arc4random() % 30)+1
            return (tmp % 5 == 0)
        }
        presentSemiViewController(datePicker, withOptions: [
            convertCfTypeToString(KNSemiModalOptionKeys.shadowOpacity) as String! : 0.3 as Float,
            convertCfTypeToString(KNSemiModalOptionKeys.animationDuration) as String! : 1.0 as Float,
            convertCfTypeToString(KNSemiModalOptionKeys.pushParentBack) as String! : false as Bool
            ])
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
        curDate = datePicker.date
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

