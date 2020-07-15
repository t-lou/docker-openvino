# docker image for openvinoi 2020.4 on ubuntu 20.04

- download source file for openvino, for example l_openvino_toolkit_p_2020.4.287.tgz
- docker build . --tag openvino --build-arg FN=l_openvino_toolkit_p_2020.4.287.tgz
- docker run --user usr -v /tmp/.X11-unix:/tmp/.X11-unix --device /dev/dri -e DISPLAY=:0 -it openvino

the image contains a user with username usr and password usr


![screenshot cpu](https://github.com/t-lou/docker-openvino/blob/master/cpu.png)

![screenshot gpu](https://github.com/t-lou/docker-openvino/blob/master/gpu.png)
