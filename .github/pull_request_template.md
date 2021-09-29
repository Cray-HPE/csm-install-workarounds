### Summary and Scope

EXPLAIN WHY THIS PR IS NECESSARY. WHAT IS IMPACTED?
IS THIS A NEW FEATURE OR CRITICAL BUG FIX? SUMMARIZE WHAT CHANGED.

DOES THIS CHANGE INVOLVE ANY SCHEME CHANGES?  Y/N

REMINDER: HAVE YOU INCREMENTED VERSION NUMBERS? E.G., .spec, Chart.yaml, .version, CHANGELOG.md

REMINDER 2: HAVE YOU UPDATED THE COPYRIGHT PER hpe GUIDELINES: (C) Copyright 2014-2021 Hewlett Packard Enterprise Development LP    ? Y/N

### Issues and Related PRs

LIST AND CHARACTERIZE RELATIONSHIP TO JIRA ISSUES AND OTHER PULL REQUESTS. BE SURE LIST DEPENDENCIES.

* Resolves CASM-XYZ
* Change will also be needed in `<insert branch name here>`
* Future work required by CASM-ABC
* Merge with `<insert PR URL here>`
* Merge before `<insert PR URL here>`
* Merge after `<insert PR URL here>`

### Testing

LIST THE ENVIRONMENTS IN WHICH THESE CHANGES WERE TESTED.

Tested on:

* `<drink system>`
* Craystack
* CMS base-box
* Virtual Shasta

Were the install/upgrade based validation checks/tests run?(goss tests/install-validation doc)
Were continuous integration tests run? Y/N   If not, Why?
Was an Upgrade tested?                 Y/N   If not, Why?
Was a Downgrade tested?                Y/N   If not, Why?
If schema changes were part of this change, how were those handled in your upgrade/downgrade testing?

WHAT WAS THE EXTENT OF TESTING PERFORMED? MANUAL VERSUS AUTOMATED TESTS (UNIT/SMOKE/OTHER)
HOW WERE CHANGES VERIFIED TO BE SUCCESSFUL?

### Risks and Mitigations

HAS A SECURITY AUDIT BEEN RUN? (./runSnyk.sh)
ARE THERE KNOWN ISSUES WITH THESE CHANGES?
ANY OTHER SPECIAL CONSIDERATIONS?

INCLUDE THE FOLLOWING ITEMS THAT APPLY. LIST ADDITIONAL ITEMS AND PROVIDE MORE DETAILED INFORMATION AS APPROPRIATE.

Requires:

* Additional testing on bare-metal
* Compute nodes
* 3rd party software
* Broader integration testing
* Fresh install
* Platform upgrade
