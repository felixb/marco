# Marco

Marco got a baby. So I created a script to replace him.

## Installation

Check out this repository and run

    bundle install

## Usage

First read all existing JIRA tickets:

    ./bin/marco update

Then create as many tickets as you want:

    ./bin/macro create-ticket

## Configuration

It is possible to set up marco via environment variables:

 * `JIRA_PROJECT`: JIRA project
 * `JIRA_TEXT_FIELD`: Name of the text field used for JIRA issues
 * `JIRA_SITE`: JIRA base URL
 * `JIRA_PATH`: path to JIRA
 * `JIRA_USER`: JIRA username
 * `JIRA_PASSWORD`: JIRA password

## Limitations

Marco is not able to create tickets in JIRA.
Please fix marco, if you found out how to fill all those default fields.

## License

This program is licensed under the MIT license. See LICENSE for details.
