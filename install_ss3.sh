#!/bin/bash

# Clone SS3 source and compile with optimization for ss3 docker image

INST=/usr/bin
SS3_HOME=$INST/ss3_exe

cd $INST
git clone --branch v3.30.22.1 https://github.com/nmfs-ost/ss3-source-code $SS3_HOME
cd $SS3_HOME
cat \
SS_versioninfo_330opt.tpl \
SS_readstarter.tpl \
SS_readdata_330.tpl \
SS_readcontrol_330.tpl \
SS_param.tpl \
SS_prelim.tpl \
SS_global.tpl \
SS_proced.tpl \
SS_biofxn.tpl \
SS_miscfxn.tpl \
SS_selex.tpl \
SS_popdyn.tpl \
SS_recruit.tpl \
SS_benchfore.tpl \
SS_expval.tpl \
SS_objfunc.tpl \
SS_write.tpl \
SS_write_ssnew.tpl \
SS_write_report.tpl \
SS_ALK.tpl \
SS_timevaryparm.tpl \
SS_tagrecap.tpl > ss3.tpl
#
admb -f ss3
