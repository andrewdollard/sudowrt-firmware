The sudo mesh firmware builder.

# Requirements

The openwrt wiki has some examples of requirements per distro:
http://wiki.openwrt.org/doc/howto/buildroot.exigence#examples.of.package.installations

# the "easy" way
If you'd like to build the firmware in a controlled/clean environment, you can use [docker](https://docker.io) with the provided [Dockerfile](./Dockerfile):

First clone this repository:

```
git clone https://github.com/sudomesh/sudowrt-firmware
cd sudowrt-firmware
```

To build and run the image (depending on your network connect and hardware, the build takes a couple of hours): 

Collect all the sudowrt-firmware dependencies into a docker image using:
```
docker build -t sudowrt .
```

After building the image, run it using: 
```
docker run -v $PWD/firmware_images:/firmware_images sudowrt [architecture]
``` 

After running the container, the built firmware images will be in the `/firmware_images` directory of the repo.  

In order to build the extender node firmware, you currently have to build home
node firmware first even if you just built it (someone should fix this). To build the home node and 
extender node within in the same docker container, run the following:  
```
docker run -v $PWD/firmware_images:/firmware_images sudowrt ar71xx ar71xx.extender-node
```  
(note: entrypoint currently hardcoded for building both the home node and extender node firmware and it will stay this way until someone rewrites it to work properly within the docker container, if you would like to work on this, look at entrypoint-old.sh and [this](https://github.com/sudomesh/sudowrt-firmware/issues/105) issue)   

If the build fails, capture the console output, yell loudly, talk to someone or create [a new issue](https://github.com/sudomesh/meshwrt-firmware/issues/new).

Now go to https://sudoroom.org/wiki/Mesh/WalkThrough to flash the firmware onto your router.

# the "hard" way
If you'd rather build the firmware without Docker, please keep reading.

Unless you know what you are doing, you should build this on a Ubuntu 64bit box/container. At time of writing (Jan 2017), the [build script does not appear to work on Ubuntu 16.04](https://github.com/sudomesh/sudowrt-firmware/issues/103). 

Be aware that it won't build as root, so if you need to, follow [these instructions](https://www.digitalocean.com/community/tutorials/how-to-add-and-delete-users-on-an-ubuntu-14-04-vps) to create a non-root user, and give it the power to sudo.

Once you're logged in as a non-root user with sudo ability, install the neccesary dependencies:

```shell
sudo apt-get update
sudo apt-get install build-essential subversion libncurses5-dev zlib1g-dev gawk gcc-multilib flex git-core gettext quilt ccache libssl-dev xsltproc unzip python wget
```

# Building home-node firmware

Run:

```
 ./build <arch>
```

Where arch is either ar71xx or atheros e.g:

```
./build ar71xx
```

The build will happen in:

```
built_firmware/builder.ar71xx/
```

The firmware images will be available in:

```
built_firmware/builder.ar71xx/bin/ar71xx/
```

# Building extender-node firmware

Make sure you've already built the home-node firmware as the extender-node firmware will not build otherwise.

Run:

```
./build_extender-node ar71xx
```

The build will happen in:

```
built_firmware/builder.ar71xx.extender-node/
```

The firmware images will be available in:

```
built_firmware/builder.ar71xx.extender-node/bin/ar71xx/
```

# Rebuilding firmware

The rebuild script is untested!

You can use ./rebuild but we're not actually sure what you can safely change and still use the ./rebuild script successfully. Changing packages, feeds and stuff in files/ should work, but if you change the patches then you will have to do a full rebuild.
