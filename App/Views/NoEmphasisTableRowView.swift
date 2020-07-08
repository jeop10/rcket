//
//  NoEmphasisTableRowView.swift
//  rcket
//
//  Created by Jesus Ortega on 7/7/20.
//  Copyright © 2020 Jesus Ortega. All rights reserved.
//

import AppKit

class NoEmphasisTableRowView: NSTableRowView {
    override var isEmphasized: Bool {
        get { false }
        set {}
    }
}

