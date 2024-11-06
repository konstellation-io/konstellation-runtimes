# How to contribute to konstellation-runtimes

This document provides guidelines for contributing to the *konstellation-runtimes* project.

## How can I contribute?

### Did you find a bug?

* **Ensure the bug has not already been reported** by searching on GitHub under [Issues](https://github.com/konstellation-io/konstellation-runtimes/issues).
* If you cannot find an open issue addressing the problem, [open a new one](https://github.com/konstellation-io/konstellation-runtimes/issues/new). Include a **title and clear description**, as much relevant information as possible, and a **code sample** or an **executable test case** demonstrating the unexpected behavior.
* Use the relevant bug report templates to create the issue, if available.

### Do you intend to add a new feature or change an existing one?

* Please discuss first ([open an issue](https://github.com/konstellation-io/konstellation-runtimes/issues)) before starting any significant pull request (e.g., implementing features, refactoring code) to avoid spending time on something that might not be merged.
* Adhere to the project's coding conventions (indentation, accurate comments, etc.) and any other requirements (such as test coverage, documentation).

## Styleguides

### YAML Styleguide

All YAML files must adhere to the following style guide:

* Indentation: Use 2 spaces for indentation.
* No trailing spaces.
* Use hyphens for list items.
* Use camelCase for key names.
* Ensure there are no syntax errors.

Additional rules:

* Always use double quotes for strings.
* Keep lines to a maximum of 80 characters.
* Ensure proper alignment of nested elements.

### Branches

* Use the present tense ("Add feature" not "Added feature").
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...").
* Each Dockerfile modification branch should be named like follows: `<action>/<docker_image>\_<message>`.
  * `action`: The available actions are fix, refactor, feature and docs.
  * `docker_image`: The name of the folder inside `docker/` that represents a Dockerfile.
  * `message`: A general and short message that explain the task or a small title.
* For non Dockerfile modification branches: `<action>/<message>`
  * `action`: The available actions are fix, refactor, feature and docs.
  * `message`: A general and short message that explain the task or a small title.

### Git Commit Messages

> [!CRITICAL]
> If this approach is not followed, the automation won't upgrade the version and publish the changelog on the repo.

* Based on [Angular commit guidelines](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines) for commits because [multi-semantic-release](https://github.com/qiwi/multi-semantic-release) is used, so commits that follow this message style could upgrade images version automatically.
* Use the present tense ("Add feature" not "Added feature").
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...").
* Limit the first line to 72 characters or less.
* Reference issues and pull requests liberally after the first line.
* Example:

    ```console
    feat(component): Add new feature

    My commit description
    ```
