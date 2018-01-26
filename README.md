# docker_tibero
Scripts to create docker image with [Tibero](http://tmaxsoft.com/products/tibero/)
## How to use
### 1. Check that docker is installed 
    $ docker --version
    Docker version 17.05.0-ce, build 89658be
if not, install docker following the [instructions](https://docs.docker.com/engine/installation)
### 2. Register on the [TmaxSoft TechNet site](https://technet.tmaxsoft.com/en/front/main/main.do)
### 3. Download [Tibero for Linux (x86) 64-bit](https://technet.tmaxsoft.com/en/front/download/viewDownload.do?cmProductCode=0301&version_seq=PVER-20170217-000001&doc_type_cd=DN) and rename file to Tibero.tar.gz
### 4. Request Demo License on the [TmaxSoft TechNet site](https://technet.tmaxsoft.com/en/front/main/main.do)
### 5. Download [Java JDK jdk-...-linux-x64.rpm](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and rename file to jdk.rpm
### 6. Put Tibero.tar.gz, license.xml, jdk.rpm and this script files together in one directory and set this directory to the current one:
    $ cd docker_tibero
    [docker@localhost docker_tibero]$ ls
    bash_profile.add  create_database.sql  Dockerfile  jdk.rpm  LICENSE  license.xml  README.md  tibero.sh  Tibero.tar.gz
### 7. Run tibero.sh:
    $ ./tibero.sh
    Sending build context to Docker daemon  623.7MB
    Step 1/13 : FROM centos
     ---> 3bee3060bfc8
    Step 2/13 : MAINTAINER Vasiliy Floka <Vasiliy@Floka.ru>
    ---> Running in 90d5dbda5af3
     ---> c33e35319beb
    Removing intermediate container 90d5dbda5af3
    Step 3/13 : RUN yum install -y gcc.x86_64 gcc-c++.x86_64 compat-libstdc++-33.x86_64 libaio-devel.x86_64
    ---> Running in 00aa24d88a1f
    ...
        Complete!
    ---> d9880182c9ca
    Removing intermediate container 00aa24d88a1f
    Step 4/13 : RUN groupadd dba &&         useradd -g dba tibero &&        echo tibero soft nproc 2047 >> /etc/security/limits.conf &&     echo tibero hard nproc 16384 >> /etc/security/limits.conf &&        echo tibero soft nofile 1024 >> /etc/security/limits.conf &&    echo tibero hard nofile 65536 >> /etc/security/limits.conf
    ---> Running in 97dbd380fdd2
    ---> bdcf33a9ca13
    Removing intermediate container 97dbd380fdd2
    Step 5/13 : ENV TB_HOME /home/tibero/tibero6 TB_SID tibero
    ---> Running in e903430c9775
    ---> d3007a0146ac
    Removing intermediate container e903430c9775
    Step 6/13 : EXPOSE 8629
    ---> Running in 0eef71fea3f1
    ---> 69f66e962f8a
    Removing intermediate container 0eef71fea3f1
    Step 7/13 : ADD Tibero.tar.gz /home/tibero
    ---> 6266d9bf560b
    Removing intermediate container b3247e29cbb6
    Step 8/13 : COPY license.xml $TB_HOME/license
    ---> c698044df330
    Removing intermediate container b6b14553494f
    Step 9/13 : COPY create_database.sql $TB_HOME/scripts
    ---> c6e5f9a74d9f
    Removing intermediate container caa0ea7e1d04
    Step 10/13 : COPY bash_profile.add /home/tibero
    ---> 0cc245716fbc
    Removing intermediate container 4aeb4985241b
    Step 11/13 : RUN chown -R tibero:dba /home/tibero &&    chmod -R 775 /home/tibero &&    cat /home/tibero/bash_profile.add >> /home/tibero/.bash_profile
    ---> Running in 67444c5060ef
    ---> 5a8df027a1de
    Removing intermediate container 67444c5060ef
    Step 12/13 : COPY jdk.rpm /tmp
    ---> ed022001a127
    Removing intermediate container 1a121706fcfa
    Step 13/13 : RUN rpm -ivh /tmp/jdk.rpm
    ---> Running in ff69ff9c318e
    Preparing...                          ########################################
    Updating / installing...
    jdk1.8-2000:1.8.0_161-fcs             ########################################
    Unpacking JAR files...
            tools.jar...
            plugin.jar...
            javaws.jar...
            deploy.jar...
            rt.jar...
            jsse.jar...
            charsets.jar...
            localedata.jar...
    ---> be915bd1a4af
    Removing intermediate container ff69ff9c318e
    Successfully built be915bd1a4af
    Successfully tagged tibero6:latest
### 8. After starting the container, you have to set MEMORY_TARGET in Megabytes:
    [docker@localhost docker_tibero]$ docker run --name t6 -p 8888:8629 --hostname node1 -ti tibero6 su - tibero
    ***** Welcome! *****
    Using TB_SID "tibero"
    /home/tibero/tibero6/config/tibero.tip generated
    /home/tibero/tibero6/config/psm_commands generated
    /home/tibero/tibero6/client/config/tbdsn.tbr generated.
    Running client/config/gen_esql_cfg.sh
    Done.
    Enter value in Megabytes of MEMORY_TARGET:2048
    # tip file generated from /home/tibero/tibero6/config/tip.template (Fri Jan 26 13:56:07 UTC 2018)
    #-------------------------------------------------------------------------------
    #
    # RDBMS initialization parameter
    #
    #-------------------------------------------------------------------------------

    DB_NAME=tibero
    LISTENER_PORT=8629
    CONTROL_FILES="/home/tibero/tibero6/database/tibero/c1.ctl"
    #CERTIFICATE_FILE="/home/tibero/tibero6/config/svr_wallet/tibero.crt"
    #PRIVKEY_FILE="/home/tibero/tibero6/config/svr_wallet/tibero.key"
    #WALLET_FILE="/home/tibero/tibero6/config/svr_wallet/WALLET"
    #ILOG_MAP="/home/tibero/tibero6/config/ilog.map"

    MAX_SESSION_COUNT=20

    TOTAL_SHM_SIZE=1024M#2G
    MEMORY_TARGET=2048M#4G

    _PSM_BOOT_JEPA=Y
    cat: /proc/sys/net/ipv4/tcp_wmem: No such file or directory
    cat: /proc/sys/net/ipv4/tcp_wmem: No such file or directory
    cat: /proc/sys/net/ipv4/tcp_wmem: No such file or directory
    cat: /proc/sys/net/ipv4/tcp_rmem: No such file or directory
    cat: /proc/sys/net/ipv4/tcp_rmem: No such file or directory
    cat: /proc/sys/net/ipv4/tcp_rmem: No such file or directory
    cat: /proc/sys/net/core/wmem_max: No such file or directory
    cat: /proc/sys/net/core/rmem_max: No such file or directory
    Listener port = 8629

    Tibero 6

    TmaxData Corporation Copyright (c) 2008-. All rights reserved.
    Tibero instance started up (NOMOUNT mode).

    tbSQL 6

    TmaxData Corporation Copyright (c) 2008-. All rights reserved.

    Connected to Tibero.

    Spooling is started.
    Database created.

    Disconnected.
    cat: /proc/sys/net/ipv4/tcp_wmem: No such file or directory
    cat: /proc/sys/net/ipv4/tcp_wmem: No such file or directory
    cat: /proc/sys/net/ipv4/tcp_wmem: No such file or directory
    cat: /proc/sys/net/ipv4/tcp_rmem: No such file or directory
    cat: /proc/sys/net/ipv4/tcp_rmem: No such file or directory
    cat: /proc/sys/net/ipv4/tcp_rmem: No such file or directory
    cat: /proc/sys/net/core/wmem_max: No such file or directory
    cat: /proc/sys/net/core/rmem_max: No such file or directory
    Listener port = 8629

    Tibero 6

    TmaxData Corporation Copyright (c) 2008-. All rights reserved.
    Tibero instance started up (NORMAL mode).
    Dropping agent table...
    Creating text packages table ...
    Creating the role DBA...
    Creating system users & roles...
    Creating example users...
    Creating virtual tables(1)...
    Creating virtual tables(2)...
    Granting public access to _VT_DUAL...
    Creating the system generated sequences...
    Creating internal dynamic performance views...
    Creating outline table...
    Creating system tables related to dbms_job...
    Creating system tables related to dbms_lock...
    Creating system tables related to scheduler...
    Creating system tables related to server_alert...
    Creating system tables related to tpm...
    Creating system tables related to tsn and timestamp...
    Creating system tables related to rsrc...
    Creating system tables related to workspacemanager...
    Creating system tables related to statistics...
    Creating system tables related to mview...
    Creating system package specifications:
        Running /home/tibero/tibero6/scripts/pkg/pkg_standard.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_standard_extension.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_clobxmlinterface.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_udt_meta.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_seaf.sql...
        Running /home/tibero/tibero6/scripts/pkg/anydata.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_standard.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_db2_standard.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_application_info.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_aq.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_aq_utl.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_aqadm.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_assert.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_crypto.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_db2_translator.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_db_version.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_ddl.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_debug.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_debug_jdwp.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_errlog.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_expression.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_fga.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_flashback.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_geom.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_java.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_job.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_lob.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_lock.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_metadata.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_mssql_translator.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_mview.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_mview_refresh_util.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_mview_util.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_obfuscation.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_output.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_pipe.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_random.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_redefinition.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_redefinition_stats.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_repair.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_result_cache.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_rls.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_rowid.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_rsrc.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_scheduler.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_session.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_space.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_space_admin.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_sph.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_sql.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_sql_analyze.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_sql_translator.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_sqltune.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_stats.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_stats_util.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_system.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_transaction.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_types.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_utility.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_utl_tb.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_verify.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_xmldom.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_xmlgen.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_xmlquery.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_xplan.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dg_cipher.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_htf.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_htp.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_psm_sql_result_cache.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_sys_util.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_tb_utility.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_text.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_tudiconst.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_encode.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_file.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_tcp.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_http.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_url.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_i18n.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_match.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_raw.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_smtp.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_str.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_compress.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_text_japanese_lexer.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_tpm.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_recomp.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_monitor.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_server_alert.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_ctx_ddl.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_odci.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_utl_ref.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_owa_util.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_alert.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_client_internal.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_xslprocessor.sql...
        Running /home/tibero/tibero6/scripts/pkg/uda_wm_concat.sql...
        Running /home/tibero/tibero6/scripts/pkg/pkg_diutil.sql...
    Creating public synonyms for system packages...
    Creating remaining public synonyms for system packages...
    Creating auxiliary tables used in static views...
    Creating system tables related to profile...
    Creating internal system tables...
    Check TPR status..
    Stop TPR
    Dropping tables used in TPR...
    Creating auxiliary tables used in TPR...
    Creating static views...
    Creating static view descriptions...
    Creating objects for sph:
    Running /home/tibero/tibero6/scripts/iparam_desc_gen.sql...
    Creating dynamic performance views...
    Creating dynamic performance view descriptions...
    Creating package bodies:
        Running /home/tibero/tibero6/scripts/pkg/_pkg_db2_standard.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_aq.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_aq_utl.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_aqadm.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_assert.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_db2_translator.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_errlog.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_metadata.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_mssql_translator.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_mview.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_mview_refresh_util.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_redefinition_stats.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_rsrc.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_scheduler.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_session.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_sph.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_sql_analyze.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_sql_translator.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_sqltune.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_stats.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_stats_util.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_utility.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_utl_tb.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_verify.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_workspacemanager.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_xplan.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dg_cipher.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_htf.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_htp.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_text.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_utl_http.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_utl_url.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_utl_i18n.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_utl_smtp.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_text_japanese_lexer.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_tpm.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_utl_recomp.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_server_alert.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_xslprocessor.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_uda_wm_concat.tbw...
    Registering dbms_stats job to Job Scheduler...
    Creating audit event pacakge...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_audit_event.tbw...
    Creating packages for TPR...
        Running /home/tibero/tibero6/scripts/pkg/pkg_dbms_tpr.sql...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_tpr.tbw...
        Running /home/tibero/tibero6/scripts/pkg/_pkg_dbms_apm.tbw...
    Start TPR
    Create tudi interface
        Running /home/tibero/tibero6/scripts/odci.sql...
    Creating spatial meta tables and views ...
    Creating internal system jobs...
    Creating Japanese Lexer epa source ...
    Creating internal system notice queue ...
    Creating sql translator profiles ...
    Creating agent table...
    Done.
    For details, check /home/tibero/tibero6/instance/tibero/log/system_init.log.
### 9. After database creation enter 2, to start tbsql
    1. tbboot
    2. tbsql
    Enter number of action(1..2):2

    tbSQL 6

    TmaxData Corporation Copyright (c) 2008-. All rights reserved.

    Connected to Tibero.

    SQL> select * from v$database;

        DBID NAME
    ---------- ----------------------------------------
    CREATE_DATE                      CURRENT_TSN OPEN_MODE  RESETLOG_TSN
    -------------------------------- ----------- ---------- ------------
    RESETLOG_DATE                    PREV_RESETLOG_TSN
    -------------------------------- -----------------
    PREV_RESETLOG_DATE               LOG_MODE       CKPT_TSN
    -------------------------------- ------------ ----------
    CKPT_DATE                        CPU_NAME
    -------------------------------- --------------------------------
    PLATFORM_NAME
    --------------------------------
    CPU_MODEL
    --------------------------------------------------------------------------------
    OS_UPTIME
    --------------------------------------------------------------------------------
    881590366 tibero
    2018/01/26                             36092 READ WRITE            0
                                                    0
                                    NOARCHIVELOG      35748
    2018/01/26                       X86
    LINUX_X86_64
    Intel(R) Core(TM) i7-4510U CPU @ 2.00GHz
    14:08:21 up  4:38,  0 users,  load average: 0.00, 0.17, 0.41


    1 row selected.

    SQL>






