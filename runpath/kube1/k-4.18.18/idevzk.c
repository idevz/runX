#include <linux/module.h> /* Needed by all modules */
#include <linux/kernel.h> /* Needed for KERN_INFO */
#include <linux/init.h>   /* Needed for the macros */

// http://www.tldp.org/LDP/lkmpg/2.6/html/x121.html
static int __init idevzk_init(void)
{
    printk(KERN_INFO "Welcome to K\n");
    return 0;
}

static void __exit idevzk_exit(void)
{
    printk(KERN_INFO "Goodbye, K\n");
}

module_init(idevzk_init);
module_exit(idevzk_exit);
MODULE_LICENSE("GPL");