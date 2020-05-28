# Helm push action

This action uploads a chart to chartmuseum or another compatible chart manager using helm 3.

## Usage

### Chart setup

Assuming that you have a helm chart in your repository, here is an example partial file tree (You would set `SOURCE_DIR` to `charts`)

```
- ./
  - charts/
    - myapp/
      - values.yaml
      - Chart.yaml
      - ...
  - Dockerfile
  - ...
```

if the chart is at the top level, you would set `SOURCE_DIR` to `.`

```
- ./
  - myapp/
    - values.yaml
    - Chart.yaml
    - ...
```

You cannot have the helm chart files at the top level of the repository, as it prevents naming the chart for uploads.


### `workflow.yml` Example

Create a new Github Action in `.github/workflows/`. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

Minimal example for a chart located at `charts/chart1`:

```yaml
name: Create and upload chart
on: push

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - uses: unwrittenmedia/helm3-push-action@v1.0.2
      env:
        SOURCE_DIR: 'charts'
        CHART_FOLDER: 'myapp'
        CHARTMUSEUM_URL: 'https://chartmuseum.url'
        CHARTMUSEUM_USER: 'myuser'
        CHARTMUSEUM_PASSWORD: 'mypassword'
```

Full example:

```yaml
name: Create and upload chart
on: push

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - uses: unwrittenmedia/helm3-push-action@v1.0.2
      env:
        SOURCE_DIR: 'charts'
        CHART_FOLDER: 'myapp'
        FORCE: 'True'
        CHARTMUSEUM_URL: 'https://chartmuseum.url'
        CHARTMUSEUM_USER: '${{ secrets.CHARTMUSEUM_USER }}'
        CHARTMUSEUM_PASSWORD: '${{ secrets.CHARTMUSEUM_PASSWORD }}'
```

### Configuration

The following settings must be passed as environment variables as shown in the example. Sensitive information, especially `CHARTMUSEUM_USER` and `CHARTMUSEUM_PASSWORD`, should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) — otherwise, they'll be public to anyone browsing your repository.

| Key | Value | Suggested Type | Required |
| ------------- | ------------- | ------------- | ------------- |
| `CHART_FOLDER` | Folder with charts in repo | `env` | **Yes** |
| `CHARTMUSEUM_URL` | Chartmuseum url | `env` | **Yes** |
| `CHARTMUSEUM_USER` | Username for chartmuseum  | `secret` | **Yes** |
| `CHARTMUSEUM_PASSWORD` | Password for chartmuseum | `secret` | **Yes** |
| `SOURCE_DIR` | The local directory you wish to upload. For example, `./charts`. Defaults to the root of your repository (`.`) if not provided. | `env` | No |
| `FORCE` | Force chart upload (in case version exist in chartmuseum, upload will fail without `FORCE`). Set to `True` or ``. Don't set to any other values. | `env` | No |

## Action versions

- helm3  v3.2.1
- helm-push: v0.8.1

## License

This project is distributed under the [MIT license](LICENSE.md).
