#!/bin/bash
# vim: dict=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /CoreOS/rhcs/acceptance/cli-tests/pki-tps-selftest
#   Description: pki tps selftest tests
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# The following pki key cli commands needs to be tested:
#  pki-tps-selftest --help
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Author: Niranjan Mallapadi <mniranja@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2013 Red Hat, Inc. All rights reserved.
#
#   This copyrighted material is made available to anyone wishing
#   to use, modify, copy, or redistribute it subject to the terms
#   and conditions of the GNU General Public License version 2.
#
#   This program is distributed in the hope that it will be
#   useful, but WITHOUT ANY WARRANTY; without even the implied
#   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#   PURPOSE. See the GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public
#   License along with this program; if not, write to the Free
#   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
#   Boston, MA 02110-1301, USA.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Include rhts environment
. /usr/bin/rhts-environment.sh
. /usr/share/beakerlib/beakerlib.sh
. /opt/rhqa_pki/rhcs-shared.sh
. /opt/rhqa_pki/env.sh

run_pki-tps-selftest_tests()
{
	rlPhaseStartSetup "Create Temporary Directory"
	rlRun "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
	rlRun "pushd $TmpDir"
	rlPhaseEnd

	rlPhaseStartTest "pki tps-selftest --help Test: Show all the options of pki tps-selftest"
	local temp_out="$TmpDir/pki_ca_selftest"
	rlLog "Executing pki tps-selftest --help"
	rlRun "pki tps-selftest --help 1> $temp_out" 0 "pki tps-selftest --help"
	rlAssertGrep "Commands:"	"$temp_out"
	rlAssertGrep " tps-selftest-find       Find selftests" "$temp_out"
	rlAssertGrep " tps-selftest-run        Run selftests" "$temp_out"
	rlAssertGrep " tps-selftest-show       Show selftest" "$temp_out"
	rlPhaseEnd
	
	rlPhaseStartTest "pki_ca_selftest-001: pki tps-selftest with characters should return invalid module"
	local temp_out1="$TmpDir/pki_ca_selftest001"
	local rand=$(openssl rand -base64 50 |  perl -p -e 's/\n//')
	rlLog "Executing pki tps-selftest \"$junk\" characters"
	rlRun "pki tps-selftest \"$junk\" 2> $temp_out1" 1,255 "Command pki tps-selftest with junk characters"
	rlAssertGrep "Error: Invalid module" "$temp_out1"
	rlPhaseEnd
	
	rlPhaseStartCleanup "pki tps-selftest cleanup: Delete temp dir"
	rlRun "popd"
	rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
	rlPhaseEnd
}
