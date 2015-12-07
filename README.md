# code_manager_face

#### Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
   * [start](#start)
   * [startall](#startall)

## Use at your own risk
This puppet face is intended as a stopgap measure to provide a CLI for the code manager service released in Puppet Enterprise 2015.3. While it has been tested it may not receive additional maintenance or updates and is not a supported product of Puppet Labs. A future release will include a more fully featured and supported CLI tool to replace this interim method.

## Description

code_manager_face provides a face for puppet in order to interact with the
code-manager service. It allows one to start the deploy of a single environment
or all environments. It allows one to wait for the deployment to occur, or
return control immediately after the deployment has been queued. One can also
specify the server and port if that is not specified in the workstations
puppet.conf.

## Usage

### start

```
USAGE: puppet code_manager start [-w | --wait]
[-s SERVER | --cmserver SERVER]
[-p PORT | --cmport PORT]
[-t TOKENFILE | --tokenfile TOKENFILE]
<environment>

Start a deploy of one environment

OPTIONS:
  --verbose                      - Whether to log verbosely.
  --debug                        - Whether to log debug information.
  -p PORT | --cmport PORT        - Code manager port on server
  -s SERVER | --cmserver SERVER  - Code manager server name
  -t TOKENFILE | --tokenfile TO  - File containing RBAC authorization token
  -w | --wait                    - Wait for the code-manager service to return.
```

### startall

```
USAGE: puppet code_manager startall [-w | --wait]
[-s SERVER | --cmserver SERVER]
[-p PORT | --cmport PORT]
[-t TOKENFILE | --tokenfile TOKENFILE]

Start a deploy of all environments.

OPTIONS:
  --verbose                      - Whether to log verbosely.
  --debug                        - Whether to log debug information.
  -p PORT | --cmport PORT        - Code manager port on server
  -s SERVER | --cmserver SERVER  - Code manager server name
  -t TOKENFILE | --tokenfile TO  - File containing RBAC authorization token
  -w | --wait                    - Wait for the code-manager service to return
```
