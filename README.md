# docker image for openvinoi 2020.4 on ubuntu 20.04

- download source file for the intel openvino like l_openvino_toolkit_p_2020.4.287.tgz
- docker build . --tag openvino:20.04 --build-arg FN=l_openvino_toolkit_p_2020.4.287.tgz


the image contains a user with username usr and password usr


![screenshot cpu](https://github.com/t-lou/docker-openvino/blob/master/cpu.png)
![screenshot gpu](https://github.com/t-lou/docker-openvino/blob/master/gpu.png)
