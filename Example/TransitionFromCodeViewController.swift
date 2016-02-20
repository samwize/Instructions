// TransitionFromCodeViewController.swift
//
// Copyright (c) 2016 Frédéric Maquin <fred@ephread.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Instructions

// That's the default controller, using every defaults made available by Instructions.
// It can't get any simpler.
internal class TransitionFromCodeViewController: ProfileViewController, CoachMarksControllerDataSource, CoachMarksControllerDelegate {

    let text1 = "(1) That's the first coach mark."
    let text2 = "(2) Second coach mark no one will see."
    let text3 = "(3) We skipped the second one (look at how we did it in the code). Now, please tap on this button to continue!"
    let text4 = "(4) We are finally hitting the fourth one!"
    let text5 = "(5) And now the fifth one!"
    let text6 = "(6) This instruction is the last one."

    @IBOutlet var tapMeButton : UIButton!

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coachMarksController?.dataSource = self
        self.coachMarksController?.delegate = self

        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", forState: .Normal)

        self.coachMarksController?.skipView = skipView
        self.coachMarksController?.allowOverlayTap = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    //MARK: - Protocol Conformance | CoachMarksControllerDataSource
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 6
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.coachMarkForView(self.navigationController?.navigationBar) { (frame: CGRect) -> UIBezierPath in
                // This will make a cutoutPath matching the shape of
                // the component (no padding, no rounded corners).
                return UIBezierPath(rect: frame)
            }
        case 1:
            return coachMarksController.coachMarkForView(self.handleLabel)
        case 2:
            var coachMark = coachMarksController.coachMarkForView(self.tapMeButton)
            // Since we've allowed the user to tap on the overlay to show the
            // next coach mark, we'll disable this ability for the current
            // coach mark to force the user to perform the appropriate action.
            coachMark.disableOverlayTap = true
            return coachMark
        case 3:
            return coachMarksController.coachMarkForView(self.emailLabel)
        case 4:
            return coachMarksController.coachMarkForView(self.postsLabel)
        case 5:
            return coachMarksController.coachMarkForView(self.reputationLabel)
        default:
            return coachMarksController.coachMarkForView()
        }
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        var coachViews: (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?)

        // For the coach mark at index 2, we disable the ability to tap on the
        // coach mark to get to the next one, forcing the user to perform
        // the appropriate action.
        switch(index) {
        case 2:
            coachViews = coachMarksController.defaultCoachViewsWithArrow(true, withNextText: false, arrowOrientation: coachMark.arrowOrientation)
            coachViews.bodyView.userInteractionEnabled = false
        default:
            coachViews = coachMarksController.defaultCoachViewsWithArrow(true, withNextText: true, arrowOrientation: coachMark.arrowOrientation)
        }

        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = self.text1
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = self.text2
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = self.text3
        case 3:
            coachViews.bodyView.hintLabel.text = self.text4
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 4:
            coachViews.bodyView.hintLabel.text = self.text5
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 5:
            coachViews.bodyView.hintLabel.text = self.text6
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        default: break
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillLoadForIndex index: Int) -> Bool {
        switch(index) {
        case 1:
            // Skipping the second coach mark.
            return false
        default:
            return true
        }
    }

    @IBAction func performButtonTap(sender: AnyObject) {
        // The user tapped on the button, so let's carry on!
        self.coachMarksController?.showNext()
    }
}