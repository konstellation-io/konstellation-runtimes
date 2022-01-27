# Konstellation Runtimes

Konstellation runtime images to be used in KDL and KRE

## Contributing

### Pull requests

Accepted pull requests for Docker image updates could only contain changes for a single image.

Example:

Given the following project folder structure:
```
docker\
  py3.9\
    Dockerfile
    ...
  py3.10\
    Dockerfile
    ...
```
Pull requests containing changes for both `docker/py3.9` and `docker/py3.10` folders won't be accepted because that could cause the `New Release` workflow to fail.

### Semantic release

This project follows [Angular commit guidelines](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines) for commits because [semantic release](https://github.com/semantic-release/semantic-release) in conjunction with [semantic-release-monorepo](https://github.com/pmowrer/semantic-release-monorepo) is used, so commits that follow the styles message could upgrade the version automatically.

**CAUTION**:

If this approach is not followed, the automation won't upgrade the version and publish the changelog on the repo.

### Branching conventions

Each Dockerfile modification branch should be named like follows:

[action]/[docker_image]_[message]

+ **action**: The available actions are fix, refactor, feature and docs.
+ **docker_image**: The name of the folder inside `docker/` that represents a Dockerfile.
+ **message**: A general and short message that explain the task or a small title.

For non Dockerfile modification branches:

[action]/[message]

+ **action**: The available actions are fix, refactor, feature and docs.
+ **message**: A general and short message that explain the task or a small title.
