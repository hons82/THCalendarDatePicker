//
//  ViewController.swift
//  THCalendarDatePickerExampleSwift
//
//  Created by Hannes Tribus on 27/05/15.
//  Copyright (c) 2015 3Bus. All rights reserved.
//

import UIKit
import THCalendarDatePicker

class ViewController: UIViewController,THDatePickerDelegate {

    @IBOutlet weak var dateButton: UIButton!
    var curDate:NSDate!
    var formatter:NSDateFormatter!
    lazy var datePicker:THDatePickerViewController = {
        var dp = THDatePickerViewController.datePicker()
        dp.delegate = self
        dp.setAllowClearDate(false)
        dp.setClearAsToday(true)
        dp.setAutoCloseOnSelectDate(false)
        dp.setAllowSelectionOfSelectedDate(true)
        dp.setDisableHistorySelection(true)
        dp.setDisableFutureSelection(false)
        //dp.autoCloseCancelDelay = 5.0
        dp.selectedBackgroundColor = UIColor(red: 125/255.0, green: 208/255.0, blue: 0/255.0, alpha: 1.0)
        dp.currentDateColor = UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        dp.currentDateColorSelected = UIColor.yellowColor()
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curDate = NSDate()
        formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy --- HH:mm"
        refreshTitle()
    }

    func refreshTitle() {
            dateButton.setTitle((curDate != nil ? formatter.stringFromDate(curDate) : "No date selected"), forState: UIControlState.Normal)
    }
    
    @IBAction func dateButtonTouched(sender: AnyObject) {
        datePicker.date = curDate
        datePicker.setDateHasItemsCallback({(date:NSDate!) -> Bool in
            let tmp = (arc4random() % 30) + 1
            return tmp % 5 == 0
        })
        presentSemiViewController(datePicker, withOptions: [
            KNSemiModalOptionKeys.pushParentBack    : NSNumber(bool: false),
            KNSemiModalOptionKeys.animationDuration : NSNumber(float: 1.0),
            KNSemiModalOptionKeys.shadowOpacity     : NSNumber(float: 0.3)
            ])
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
        let tmp = formatter.stringFromDate(selectedDate)
        println("Date selected: \(tmp)")
    }
}

