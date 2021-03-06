setup_ssh_keys() {
  LOCAL_ROOT_DOT_SSH_PATH="/root/.ssh"
  PERSISTENT_SSH_PATH="${LOCAL_DOT_CONFIG_PATH}/ssh"
  mkdir -p ${PERSISTENT_SSH_PATH}

  if [ -e ${LOCAL_ROOT_DOT_SSH_PATH} ]; then
    echo "Ops, you should mount your '.ssh' folder on ${LOCAL_DOT_SSH_PATH}."
    exit 1
  fi

  ln -s ${PERSISTENT_SSH_PATH} ${LOCAL_ROOT_DOT_SSH_PATH}

  LOCAL_DOT_SSH_PATH=${LOCAL_DOT_SSH_PATH:-"/azk/deploy/.ssh"}
  if [ -d ${LOCAL_DOT_SSH_PATH} ] && quiet ls ${LOCAL_DOT_SSH_PATH}/*.pub; then
    if [ "${LOCAL_DOT_SSH_PATH%/}" != "${LOCAL_ROOT_DOT_SSH_PATH}" ]; then
      cp -R ${LOCAL_DOT_SSH_PATH}/* ${LOCAL_ROOT_DOT_SSH_PATH}
    fi
  else
    if ! quiet ls ${LOCAL_ROOT_DOT_SSH_PATH}/id_rsa.pub; then
      ssh-keygen -t rsa -b 4096 -N "" -f ${LOCAL_ROOT_DOT_SSH_PATH}/id_rsa
    fi
  fi
}

set -e

setup_ssh_keys

# Avoid git to check the identity of the remote host
export GIT_SSH="${ROOT_PATH}/utils/git-deploy.sh"

# Avoid Ansible to buffer and suppress its output
export PYTHONUNBUFFERED=1

set +e
