//
//  SnapshotCurrentArguments.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 16.01.2018.
//  Copyright © 2018 Thomas Evensen. All rights reserved.
//
// 1. ssh -p port user@host "mkdir ~/catalog"
// 2. ssh -p port user@host "cd ~/catalog; rm current; ln -s NN current"
//
// swiftlint:disable

import Foundation

final class SnapshotCurrentArguments: ProcessArguments {

    private var config: Configuration?
    private var args: [String]?
    private var command: String?

    private func remotearguments() {
        var remotearg: String?
        guard self.config != nil else { return }
        if self.config!.sshport != nil {
            self.args!.append("-p")
            self.args!.append(String(self.config!.sshport!))
        }
        if self.config!.offsiteServer.isEmpty == false {
            remotearg = self.config!.offsiteUsername + "@" + self.config!.offsiteServer
            self.args!.append(remotearg!)
        }
        let remotecatalog = config?.offsiteCatalog
        let snapshotnum = (config?.snapshotnum)! - 1
        let remotecommand = "cd " + remotecatalog!+"; " + "rm current;  " + "ln -s " + String(snapshotnum) + " current"
        self.args!.append(remotecommand)
        self.command = "/usr/bin/ssh"
    }

    private func localarguments() {
        guard self.config != nil else { return }
        let remotecatalog = config?.offsiteCatalog
        let snapshotnum = (config?.snapshotnum)! - 1
        let arg1 = "/usr/bin/cd " + remotecatalog!
        let arg2 = "/bin/rm current;  "
        let arg3 = "/bin/ln -s " + String(snapshotnum) + " current"
        self.args!.append(arg1)
        self.args!.append(arg2)
        self.args!.append(arg3)
        self.command = "/usr/bin/env"
    }

    func getArguments() -> [String]? {
        return self.args
    }

    func getCommand() -> String? {
        return self.command
    }

    init (config: Configuration, remote: Bool) {
        self.args = [String]()
        self.config = config
        if remote {
            self.remotearguments()
        } else {
            self.localarguments()
        }
    }

}
