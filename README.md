## CPP Scaffold
Very minimal c++ project template. 

## Targets
```Bash
make #default target to build object files and binaries
make dist #packages binaries and config into dpkg installer package
make clean #removes all object code and binaries
```
## Commands
```Shell
sudo dpkg --install your_project.deb #installs package
sudo dpkg --remove your_project #removes package
```

