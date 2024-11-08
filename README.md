# Konstellation Runtimes

This repository contains the necessary files to build and deploy a **runtime** environment for data science and machine learning applications to be used in `KDL` and `KRE` projects. A **runtime** refers to a pre-configured containerized environment, equipped with the tools, libraries, and dependencies which data scientists need to develop, test and deploy models.

## Table of contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Making a new runtime available](#making-a-new-runtime-available)
- [Image bases](#image-bases)
- [Contributing](#contributing)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Making a new runtime available

After successfully building a new runtime image, you can add it to the list of available runtime images in KAI Lab adding a new document to the `kdl` MongoDB database, under the `runtimes` collection, following the schema below.

```json
{
  "name": "",
  "desc": "Description",
  "labels": ["Python 3.9", "Ubuntu 18.0.4", "GPU", "CUDA 11.6.1"],
  "docker_image": "konstellation/kdl-py",
  "docker_tag": "3.9-cuda11.6-cudnn8-devel-1.0.2"
}
```

## Image bases

It can be confusing at first to know why runtime or devel `CUDA` images have been used as base images for our runtimes. To make a concise explanation, we can resume that NVIDIA's CUDA images are built with the following purposes in mind:

- `base`: starting from `CUDA 9.0`, contains the bare minimum (`libcudart`) to deploy a pre-built `CUDA` application. Use this image if you want to manually select which `CUDA` packages you want to install.
- `runtime`: extends the base image by adding all the shared libraries from the `CUDA` toolkit. Use this image if you have a pre-built application using multiple `CUDA` libraries.
- `devel`: extends the runtime image by adding the compiler toolchain, the debugging tools, the headers and the static libraries. Use this image to compile a `CUDA` application from source.

So, meanwhile you're not sure which image you should use, **you can follow this rule of thumb to select the right runtime for your experiments**:

- If you're not sure of what runtime to choose, choose the runtime version (the one that is not labeled with "`Development`").
- If you need `nvcc` or whichever compiler tools, choose the runtime labeled "`Development`".

![runtimes-schreenshot](./assets/runtimes-screenshot.png)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
