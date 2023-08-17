#!/usr/bin/env bash

# Copyright © 2023 OpenIM. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#fixme This scripts is the total startup scripts
#fixme The full name of the shell scripts that needs to be started is placed in the need_to_start_server_shell array

#Include shell font styles and some basic information
SCRIPTS_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
OPENIM_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

trap 'openim::util::onCtrlC' INT

#fixme Put the shell scripts name here
need_to_start_server_shell=(
  ${SCRIPTS_ROOT}/openim-rpc.sh
  ${SCRIPTS_ROOT}/openim-msggateway.sh
  ${SCRIPTS_ROOT}/openim-push.sh
  ${SCRIPTS_ROOT}/openim-msgtransfer.sh
  ${SCRIPTS_ROOT}/openim-crontask.sh
)

component_check=start_component_check.sh
chmod +x $SCRIPTS_ROOT/$component_check
$SCRIPTS_ROOT/$component_check
if [ $? -ne 0 ]; then
  # Print error message and exit
  echo "${BOLD_PREFIX}${RED_PREFIX}Error executing ${component_check}. Exiting...${COLOR_SUFFIX}"
  exit -1
fi

#fixme The 10 second delay to start the project is for the docker-compose one-click to start openIM when the infrastructure dependencies are not started

sleep 10
time=`date +"%Y-%m-%d %H:%M:%S"`
echo "==========================================================">>$OPENIM_ROOT/logs/openIM.log 2>&1 &
echo "==========================================================">>$OPENIM_ROOT/logs/openIM.log 2>&1 &
echo "==========================================================">>$OPENIM_ROOT/logs/openIM.log 2>&1 &
echo "==========server start time:${time}===========">>$OPENIM_ROOT/logs/openIM.log 2>&1 &
echo "==========================================================">>$OPENIM_ROOT/logs/openIM.log 2>&1 &
echo "==========================================================">>$OPENIM_ROOT/logs/openIM.log 2>&1 &
echo "==========================================================">>$OPENIM_ROOT/logs/openIM.log 2>&1 &
for i in ${need_to_start_server_shell[*]}; do
  $i
done

sleep 15

#fixme prevents the openIM service exit after execution in the docker container
tail -f /dev/null

# nohup ./bin/seata-server.sh > ./logs/seata.log.out 2>&1 &

# # seata注册到nacos的ip和端口，不配置默认获取本机ip（docker容器ip）
# echo $SEATA_IP $SEATA_PORT

# tail -f logs/seata.log.out