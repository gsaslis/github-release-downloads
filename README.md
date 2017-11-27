# Github Release Downloads Counter

Uses GitHub Public API to report on total downloads of releases of all public repos under a specific GitHub user.

## Usage

This ruby script uses 2 environment variables: 

* `GITHUB_USERNAME`: the GitHub user to scan
* `GITHUB_AUTH_TOKEN`: an authentication token from your own account, which is used to 

## Example

```bash
GITHUB_USER=gsaslis GITHUB_AUTH_TOKEN=<your token> ruby count.rb
``` 
