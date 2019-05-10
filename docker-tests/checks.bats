#! /usr/bin/env bats

# Variable SUT_IP should be set outside this script and should contain the IP
# address of the System Under Test.

# Tests

@test 'replicator - gridinit up' {
  run bash -c "docker exec -ti ${SUT_ID} gridinit_cmd status @replicator"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ 'TRAVIS-replicator-0 UP' ]]
}

@test 'replicator - log writable' {
  run bash -c "docker exec -ti ${SUT_ID} ls -ald /var/log/oio/sds/TRAVIS/replicator-0"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ 'drwxrwx---' ]]
}
