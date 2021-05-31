### Semi Automated OSXCross Tool-chain builder

#### Requirements
1. 5+ GB free disk space
2. Decent network connection
3. Decent powerful computer with recent Linux distribution installed
4. Install `sed wget git cmake llvm clang clang++ bsdtar xz python2 python3 bash cmake`
5. A Command_Line_Tools_for_Xcode_XX.X.dmg downdload from Apple developer page

#### Instructions / Usage
1. Please make sure the `Command_Line_Tools_for_Xcode_XX.X.dmg` is place under osxcross-builder folder
2. [Optional] If you want to install toolchain to somewhere else, set `OC_SYSROOT` environment variable to your desired location
3. Wait for ~1 hour and your tool chain will be built.
4. Run the commands that you are told to run to install runtime libraries.
    * Build osxcross-extra docker image
        ```bash
        $ docker build .
        ```
    * Manual steps
        * please install libusb and change camke default compiler by following steps:
            1. create container from second stage docker image
                ```bash 
                # host terminal - 1:
                $ docker run -it --name {container_name} {builded_second_stage_image_id} /bin/bash
                ```
            2. manually initial macports repo by run osxcross-macports upgrade with interactive command
                ```bash 
                # docker container bash:
                $ osxcross-macports upgrade
                $ osxcross-macports install libusb
                ```
            3. manually change cmake default compiler
                ```bash 
                # docker container bash:
                $ apt install vim
                $ vim /opt/osxcross/toolchain.cmake
                ```
            4. specify your gcc cross compiler at line 23, 24 of /opt/osxcross/toolchain.cmake by
                ```vim 
                # vim /opt/osxcross/toolchain.cmake
                [line 23] # specify the cross compiler
                [line 24] set(CMAKE_C_COMPILER "${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-gcc")
                [line 25] set(CMAKE_CXX_COMPILER "${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-g++")
                ```
            4. commit docker image by second host terminal
                ```bash 
                # host terminal - 2:
                $ docker commit {container_name} {new_image_name}
                ```

#### Influencial Environment Variables

- `XCODE_VER`: the Xcode version you want to use
- `XCODE_NORT`: do not build the compiler runtime
- `OC_SYSROOT`: the path to your preferred installation location
- `SLIENT_RUNNING`: do not print the compilation output to stdout
