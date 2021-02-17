@Library("dst-shared@master") _
rpmBuild(
    githubPushRepo: "Cray-HPE/csm-install-workarounds",
    githubPushBranches : "(release/.*|master)",
    specfile : "csm-install-workarounds.spec",
    product : "csm",
    target_node : "ncn",
    build_arch : "noarch",
    fanout_params : ["sle15sp2"],
    channel : "csi-ci-alerts",
    slack_notify : ['', 'SUCCESS', 'FAILURE', 'FIXED']
)