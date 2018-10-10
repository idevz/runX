# runX
A framework for create a language development environment using Parallels Vms.


## intro

I like play with so many languages, but the environment is a bit complex.
I used using Docker, Vargrant, Vms and so on. After so many try, I think,  
most I like the way is using Parallels Vms.

The traditional way to using Parallels VmS is using it with it's powerful GUI APP.
(I only discuss MACX platform here.) But usually we just only need using the Vms
though ssh, we didn't using the GUI APP so much. In the other hand, It's cost a bit
system resouces to run the GUI APP.

After I bengin to using the powerful command `prlctl`, those were all changed.
I didn't need to run the GUI APP so much. Unless I must to using the GUI to config
my Vms(because the option of the `prlctl` is so comlex, 
I didn't know all about them, but it's enough for daily using).


### why U need this runX

I using runX to set up all kinds of language development. If you like develope in
a Vm, this runX is just for you.


## how to Use

*Below is the steps:*

* Check if your `prlctl` command is work well. (run `prlctl list -a` to list all you vms)
* Clone this runX and set this runX direct as a shared direct with your Vm which you want 
  to set up the environment.
* Run `prlctl exec golang 'sudo -Hiu z set_up'` to setup it(this example is assume to set
  up a Golang development environment, and your Vm id is 'golang'). 'z' is my username,
  please change to yours, and be sure that your username have a sudo permission.


*tips:*

* add export PRLCTL_HOME=/media/psf/runX to /etc/profile
* auto generate a /etc/profile.d/idevz_prlctl_*.sh file for environment variables setting.
