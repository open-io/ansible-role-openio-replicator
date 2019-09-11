[![Build Status](https://travis-ci.org/open-io/ansible-role-openio-replicator.svg?branch=master)](https://travis-ci.org/open-io/ansible-role-openio-replicator)
# Ansible role `replicator`

An Ansible role for OpenIO replicator. Specifically, the responsibilities of this role are to:

- install
- configure

## Requirements

- Ansible 2.4+

## Role Variables


| Variable   | Default | Comments (type)  |
| :---       | :---    | :---             |
| `openio_replicator_consumer_queue` | `"oio-repli"` | Tube used in queue service |
| `openio_replicator_consumer_target` | `"{{ openio_replicator_bind_address }}:6014"` | URL of queue service |
| `openio_replicator_destination_ecd_url` | `""` | remote URL of ECD service |
| `openio_replicator_destination_namespace` | `"OPENIO2"` | remote namespace |
| `openio_replicator_destination_oioproxy_url` | `"http://{{ openio_replicator_bind_address }}:6006"` | remote URL of oioproxy |
| `openio_replicator_ecd_url` | `""` | local URL of ECD |
| `openio_replicator_gridinit_dir` | `"/etc/gridinit.d/{{ openio_replicator_namespace }}"` | Path to copy the gridinit conf |
| `openio_replicator_gridinit_file_prefix` | `""` | Maybe set it to {{ openio_ecd_namespace }}- for old gridinit's style |
| `openio_replicator_log_level` | `INFO` | Log level |
| `openio_replicator_namespace` | `OPENIO` | Namespace |
| `openio_replicator_oioproxy_url` | `"http://{{ openio_replicator_bind_address }}:6006"` | URL of local oioproxy |
| `openio_replicator_provision_only` | `false` | Provision only without restarting services |
| `openio_replicator_same_object_policy` | `false` | To replicate with the same storage policy |
| `openio_replicator_serviceid` | `"{{ 0 + openio_legacy_serviceid | d(0) | int }}"` | ID in gridinit |
| `openio_replicator_workers` | `1` | Number of workers |

## Dependencies

No dependencies.

## Example Playbook

```yaml
- hosts: all
  become: true
  vars:
    NS: OPENIO
  roles:
    - role: users
    - role: repository
      openio_repository_no_log: false
      openio_repository_products:
        sds:
          release: "18.10"

    - role: repository
      openio_repository_no_log: false
      openio_repository_products:
        replicator:
          release: "18.10"
          user: "{{ lookup('env','USER') }}"
          password: "{{ lookup('env','PASS') }}"

    - role: gridinit
      openio_gridinit_namespace: "{{ NS }}"
      openio_gridinit_per_ns: true


    - role: namespace
      openio_namespace_name: "{{ NS }}"
    - role: beanstalkd
      openio_beanstalkd_namespace: "{{ NS }}"
    - role: oioproxy
      openio_oioproxy_namespace: "{{ NS }}"


    - role: namespace
      openio_namespace_name: "{{ NS }}2"
      openio_namespace_oioproxy_url: "{{ ansible_default_ipv4.address }}:6106"
      openio_namespace_event_agent_url: "{{ ansible_default_ipv4.address }}:6114"
    - role: beanstalkd
      openio_beanstalkd_namespace: "{{ NS }}2"
      openio_beanstalkd_bind_port: 6114
    - role: oioproxy
      openio_oioproxy_namespace: "{{ NS }}2"
      openio_oioproxy_bind_port: 6106

    - role: replicator
      openio_replicator_namespace: "{{ NS }}"
      openio_replicator_workers: 1
      openio_replicator_destination_namespace: "{{ NS }}2"
      openio_replicator_destination_oioproxy_url: "http://{{ openio_replicator_bind_address }}:6106"
```

```ini
[all]
node1 ansible_host=192.168.1.173
```

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also very welcome.
The best way to submit a PR is by first creating a fork of this Github project, then creating a topic branch for the suggested change and pushing that branch to your own fork.
Github can then easily create a PR based on that branch.

## License

Apache License, Version 2.0

## Contributors

- [Cedric DELGEHIER](https://github.com/cdelgehier) (maintainer)
